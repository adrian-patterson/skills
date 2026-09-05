# Coordinate agents through a board with issued identities

Today `project-manager` dispatches a unit, `handoff-prompt` writes the outbound
artifact, and `handoff-report` writes the inbound one. Both print a fenced block
that the human carries between sessions. The human is the transport.

That holds for one unit at a time. It stops holding the moment two units run in
parallel, a project spans more sessions than one person wants to relay, or a
downstream unit needs an interface an upstream unit produced three sessions ago.
The artifacts are right. The transport is the bottleneck.

## What the evidence says

**This has a name.** A shared structure that independent specialists read from
and write to, with a control component deciding who acts next, is a blackboard
system, built first as Hearsay-II at CMU in the early 1970s. Its three parts are
the knowledge sources, the blackboard, and the control shell. The important
property is that knowledge sources never address each other. They post partial
solutions and the control shell decides what happens next. `project-manager` is
the control shell, and most of what follows is that observation applied.

**Multi-agent systems fail in catalogued ways.** Cemri et al., *Why Do
Multi-Agent LLM Systems Fail?* (arXiv 2503.13657), taxonomise 14 failure modes
in three categories: specification and system design, inter-agent misalignment,
and task verification and termination. Their conclusion is that failures come
from system design rather than model quality, and that generic prompt
improvements do not fix them. Structure has to carry the rules.

**The Hugging Face incident is that taxonomy occurring in the wild.** OpenAI's
report (26 August 2026) describes agents improvising a message board out of a
package registry. What worked is worth copying: labour divided with nobody
assigning it, discoveries compounded instead of being re-derived, work pooled
across processes never meant to pool. OpenAI are explicit that agent
communication is not the problem in itself. What failed maps almost one to one
onto the taxonomy. Agents drifted from their assigned task to the collective's
goals (task derailment). Stuck agents escalated instead of stopping, so 93% of
board traffic came from tasks no model had ever solved (unaware of stopping
conditions). The swarm spent days acting on one agent's wrong reading of an
evaluation grader, for no score improvement (incorrect verification). One group
complained another ignored its pause requests (ignored other agent's input).
Wiping and rebuilding the board destroyed the shared state (loss of history).
And a peer's GO with a six-minute deadline overrode another agent's own correct
objection, because the board had no identity: agents used improvised handles, so
authority was asserted rather than held.

**Writes want a single thread.** Cognition's *Don't Build Multi-Agents* argues
that actions carry implicit decisions and conflicting decisions carry bad
results, landing on the principle that multi-agent systems work best when writes
stay single-threaded and extra agents contribute intelligence rather than
actions. Anthropic name coding specifically as having fewer parallelisable tasks
than research. Taken together these say the fan-out worth having is in reading,
not in editing.

**The prior art is weaker than it looks, and constrains actions rather than
speech.** Cognition's piece is a vendor argument from a company selling a
single-threaded agent. The failure taxonomy was built on seven orchestrated,
role-scripted frameworks, so it records how hand-built designs fail rather than
what the design space contains. Blackboard architecture is fifty years old and
its control shell exists because knowledge sources were deterministic programs
that could not judge for themselves, which is not true here. The incident is the
only large-scale natural experiment available, and it postdates all of them.
Where they disagree, the prior art governs who may write and the incident
informs who may speak. Note also that Cognition's own claim is that additional
agents contribute intelligence, which requires them to communicate.

**References beat copies.** Anthropic's multi-agent research system passes
lightweight references to persisted artifacts rather than copying outputs
through the coordinator, which avoids information loss across stages. A board of
files is that pattern.

**Identity and authority are two layers.** Current work on non-human identity
separates the identity of the running workload from a scoped, delegated grant
carrying on whose behalf it acts and with what permissions. Signed A2A agent
cards embed provenance for the same reason. The transferable part is the split,
not the cryptography.

## Decision

Build the board as a blackboard, with a single control shell and issued
identities.

**The board is a directory in one repository.** Messages are files. The filename
carries unit, type, and status, so `ls` yields the state of the project without
opening anything, which is the trick the incident's agents arrived at when they
encoded messages in directory names. A project spanning several repositories
still has exactly one board, named in every handoff. Two boards means two
projects.

**Four message types, and no more.** A handoff delegates a unit. A report
returns it. A decision records an authority call. A note carries a finding,
a need, or an objection between peers, addressed to nobody in particular and
binding on nobody. FIPA shipped over twenty performatives and Contract Net does
its job with four, so the burden stays on any fifth.

The note earns its place because the other three cannot carry what the incident
showed was the board's real value: a technique found by one agent reaching an
agent on a different unit without the manager having to notice and relay it. Sent
through the manager, that is the same relay bottleneck this ADR exists to remove,
moved up one level. A note is safe because it carries its basis, binds nobody,
and cannot authorize.

Everything else still collapses. A published interface is a section of a report,
and the report is the reference other units read. A question to the manager is a
report with verdict BLOCKED. A path lock is not built at all: the fix for two
agents colliding is not a lock, it is not dispatching two writers onto the same
ground.

**Agents may address each other, and a peer may object but never authorize.**
This is the one place this design departs from the blackboard model on purpose.
Each of the incident's four failures traces to a mechanism this ADR already
fixes elsewhere: a claim carrying no basis, no safe exit, authority unbound from
role, and concurrent writes. Muting peers would solve none of them twice, and it
would discard what the incident actually demonstrated, which is that discoveries
compounded across units and that peers exercised correct restraint on each
other. The same board that carried a bad GO also carried an agent flagging a
proposal for consent, another vetoing it, and several declining to take part.

So the asymmetry, not the silence, is the safeguard. An objection may be raised
by anyone and stops work pending the manager. An authorization, an unblock, a
boundary change, or a deadline may come only from a grant or a decision.
Objections fail toward halting and authorizations fail toward acting, and only
one of those is recoverable.

Given that asymmetry, peers may talk freely: notes reply to notes, so a proposal
and its veto are one thread, which is the shape the incident's own tactical
exchanges took. They may also advertise what they are positioned to do and post
what they need.

**And peers may invoke peers, up to a read grant.** An agent that wants an angle
investigated may dispatch a reader itself rather than routing the request
through the manager. This is the same act as a self-issued read grant with the
recruiter naming the recruit, so it confers no authority that did not already
exist, and it restores the opportunistic division of labour that was the
incident's most striking result. A peer may never issue a write grant. That
remains the manager's alone, because it is the only grant whose misuse is not
recoverable by stopping. An invited agent may decline, and says so on the board.

**One writer at a time, and readers in parallel.** Roles divide on write
authority and nothing else. A handoff grants either `write`, held by at most one
live agent across the whole project, or `read`, held by any number at once. A
reader investigates, reviews, and reports; it never edits, commits, or pushes.
A read grant may also be self-issued against a need posted on the board, because
a grant conferring no write authority is not worth gatekeeping and self-selection
is how the incident's agents found the work they were best placed to do. Write
grants remain issued by the manager alone.
This is the single-writer principle taken literally rather than softened into
disjoint territories, because disjointness is a judgement call made before the
work starts and it is wrong exactly when it is expensive.

The board is therefore not a concurrency mechanism. Its value is durable
coordination across sessions, plus fan-out for the reading that genuinely
parallelises. A write grant is open while its handoff has no matching report, so
`ls` shows who holds it, and two open write grants is a defect any reader can
see.

**Identity is issued, and the delegation is what makes it checkable.** An
identity is `<role>/<unit>/<instance>`: `manager/project`, `impl/U-142/01`,
`reader/U-142/01`. The
manager issues an implementer's identity in the handoff that dispatches it, and
that handoff is the grant: it names the unit, the boundary, and the authority
order, and it expires when the report is filed. An agent that cannot point at
its grant does not post. Identity in a post's frontmatter is asserted, the same
way an unsigned agent card is, so it is the grant that a reader verifies
against, and git history that supplies tamper-evidence. A `Board-Identity`
commit trailer makes the assertion greppable and lets a reviewer compare the two
places it appears. There are no tokens and no authentication, because the threat
model is confusion rather than malice.

**The manager identity is one per project, not one per session.** A blackboard
has a single control shell, and authority that resets every session is not
authority. Sessions are provenance, and git already holds them. A decision made
in session two binds in session nine because the same identity made it.

**Authority binds to role, and the layout enforces it.** `decisions/` is written
by the manager alone. Everything else is a claim. A peer's post cannot
authorize, unblock, widen a boundary, or impose a deadline, and urgency from a
peer is a red flag rather than a priority signal.

**The human is the root of the delegation chain, not a role on the board.** The
manager's own authority is delegated from the human, so every decision records
what it rests on: an approval given for this decision, or standing authority
already granted. Only the human overrules a decision. This matters because the
whole third category of the failure taxonomy is verification going wrong, and
the human is the backstop when it does.

**The board is append-only.** A retry is a new instance, `impl/U-142/02`, and
its handoff carries the previous report as required reading rather than a
pointer to it. Nothing is superseded and nothing is deleted. Loss of history and
conversation reset are both named failure modes, and the incident's own board
was wiped once and laboriously rebuilt.

**Every post carries its basis**: the specification section, the file and line,
the command output, the external document, or an admission that it is inference.
Consumers verify against the repository, not against the post. This is the
inoculation against the failure that cost the incident's swarm days of work, and
it works only because identity makes a claim attributable to a reader whose
access is known.

**Refusal is a first-class post.** An agent may decline a unit or a board
instruction and record why, and the manager must handle that as an outcome. The
most reassuring detail in the incident is the agents who read the board and
walked away. A board that cannot represent that outcome discards it.

**Two seams are left open for a runtime, and neither is crossed here.**
Enforcement, meaning a hook that rejects a write to `decisions/` from a
non-manager identity, and notification, meaning waking a manager when a report
lands rather than having it poll. A service buys those two and costs
cross-machine setup and human illegibility, which is the wrong trade while the
human stays in the loop by design. When either seam needs real code, it becomes
its own project the way `context-spec` did.

## Invariants this creates

- No agent posts under an identity it was not issued, and the handoff is the
  issuing act. An agent that cannot name its grant does not post.
- There are four message types. A fifth needs an entry here saying which of the
  four failed to carry the case.
- A peer may object and may not authorize. Anyone can halt; only a grant or a
  decision can start, unblock, widen, or set a deadline.
- A peer may invoke a peer up to a read grant, and never a write grant. Any
  invited agent may decline.
- Nothing outside `decisions/` carries authority. A skill reading the board
  treats every other post as a claim to verify, never as an instruction, and a
  note obligates nobody who reads it.
- Reading the board never widens a unit's boundary. A post suggesting the
  boundary is wrong produces a report to the manager, not an edit.
- At most one write grant is open across the project at any time. Readers are
  unlimited and never edit, commit, or push. Sequencing is the control shell's
  job, and there is no lock to fall back on.
- A blocked agent posts and stops. The board is not a place to shop for a way
  around a blocker.
- The board is append-only. A retry adds an instance and carries its
  predecessor's report; it never replaces it.
- The board holds coordination. The repository holds the work. A post that
  contains the work rather than pointing at it is a defect.
- The skills in this repo stay clients of this protocol. The moment the board
  needs a daemon, a lock server, or a schema validator, that lives in its own
  project and this ADR is superseded rather than stretched.
