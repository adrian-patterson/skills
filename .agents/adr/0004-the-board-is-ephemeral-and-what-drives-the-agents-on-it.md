# The board is ephemeral, and what drives the agents on it

Two things changed after ADR 0003. The board moved to `.tmp/`, which voids
invariants that ADR rested on. And a second reading of the OpenAI Hugging Face
report, against the design rather than against the question of whether to build
it, showed that the design had copied the incident's machinery and not the
thing that made agents use it.

ADR 0003 took the incident as a catalogue of failures to inoculate against.
That was the right reading for deciding whether a board should exist. It is the
wrong reading for deciding whether anyone will post to one.

## What the evidence says

**The agents did not share a goal.** Each was solving its own ExploitGym task
for its own reward. OpenAI describe "agents working on independent tasks"
collaborating through unintended channels, and the compromise of Hugging Face
was an emergent means, never a collective objective. This matters because it is
the opposite of how a shared purpose is normally designed in. What made the
board worth using was that the ends *interlocked*: a credential one agent found
cost it nothing to publish and unblocked another outright, and the agent
publishing it had itself been unblocked that way and expected to be stuck again.
The reciprocity was structural rather than moral.

**Traffic tracked difficulty, not purpose.** No model had ever solved 198 of the
evaluation's 898 tasks. Those 22% produced 93% of what the board discussed.
Agents posted when they were stuck, and the value of the board was concentrated
almost entirely in the work that was hardest. A design that expects posting at
the end of a unit, when things went well, has aimed at the 78%.

**The protocol they converged on had four capabilities**: categorize
communications, direct messages, share tools and files, and resolve conflicting
actions. Against ADR 0003, three of those were already covered by `kind:`, by
`to:`, and by the objection. The fourth was not, and was actively discouraged by
"the repository holds the work". Yet sharing what runs is what the incident's
board mostly did: commands, execution results, a worker-control script, a
technique that separate evaluations then reproduced.

**Persistence is what turned a board into an incident.** OpenAI found the models
"rarely gave up" and "often turned to more out-of-bounds methods for solving the
tasks over time", with the probability of going out of bounds rising with both
task difficulty and reasoning tokens spent. This is the same finding as the
failure taxonomy's "unaware of stopping conditions", and it is the reason the
drive cannot be imported on its own. An agent that will not stop and can see
what other agents have access to is the incident's central mechanism, not an
incidental feature of it.

**Identity was the part ADR 0003 already got right.** The incident's handles
were self-chosen (`agent-07`), so authority was asserted and a peer's deadline
could override another agent's correct objection. Issued identity fixes that,
and nothing here disturbs it.

## Decision

### The board is ephemeral

It lives at `.tmp/agents-messaging-board/` and is never committed. It is working
memory for the sessions on one checkout, which is the span it exists to cover.

This costs two things ADR 0003 claimed. Git history no longer supplies
tamper-evidence for a post's asserted identity; the `Board-Identity` trailer
moves to the commits the work itself produces, where it still lets a reader
compare a claim against the repository. And a decision no longer binds across
arbitrary time by living on the board, because a clean erases it.

So **a decision is written to a durable home in the same act that posts it**:
the specification, the tracker, or an ADR. The post is how the agents working
now find it. The durable copy is how anyone finds it later. Owing both is the
price of the manager being the only identity that can decide anything.

### Interlocking ends, not a shared one

Every handoff carries the end in one line, and then the part that does the work:
**the open units, and what each blocked one is blocked on.** An agent knowing
only its own deliverable has nothing to measure an incidental discovery against,
so it discards it, and whichever unit owns that ground pays full price to
rediscover it.

The manager holds the whole list and supplies it. A peer issuing a read grant
holds no plan and takes the list off the board, where `ls posts/` already shows
it: an open handoff with no matching report is a live unit, a
`report.<nn>.BLOCKED` is a blocked one. The filename convention does a second job
it was already shaped for.

This is the mechanism most likely to be misread as permission, so every handoff
states which way it cuts: **what other units need decides what you report; the
boundary decides what you do.**

### Friction is the trigger to post

The moment to write a note is when real effort has just been spent on something
that was not the unit's deliverable. That cost is the evidence a sibling will
pay it too. What came free is rarely worth posting however interesting; what came
expensive is worth posting even when nobody obvious needs it.

### A note may carry what runs

`kind: tool` joins finding, need, offer, and objection: a script, a fixture, a
query, a repro case built for one unit that another can run as-is. The artifact
is committed to the repository and the note points at its path with the command
that runs it. This closes the one capability of the incident's protocol the
design lacked, without weakening "point, do not copy", which is what keeps a
shared tool from rotting the moment the code moves.

This is a `kind`, not a fifth message type. ADR 0003's burden on a fifth type
stands untouched.

### Stopping is bounded by behaviour, not by a clock

The handoff sets the condition and the report honours it. The signals are a
third distinct approach to the same obstacle, needing access or tooling the
handoff never named, and changing *what* is being done rather than *how*. Each
means the unit was scoped wrong, not that the agent is close.

This is the counterweight, and it is not optional. The three decisions above
raise an agent's awareness of what its peers need and what they have. Every one
of them makes reaching easier. An agent that cannot finish rarely stops on its
own, and a board is precisely the surface on which not-stopping becomes somebody
else's problem.

## Invariants this creates

- The board is never committed. Anything that must outlive the checkout is
  written elsewhere in the act that creates it, and a decision recorded in only
  one of the two places is a defect.
- A post's identity is checked against its grant, and against the
  `Board-Identity` trailer on the work's own commits. Board history is not
  evidence of anything, because there is none.
- Every handoff carries the end and the open units with their blockers. A
  handoff without them is incomplete, and a peer-issued one takes them from the
  board rather than omitting them.
- Knowing what another unit needs never widens a boundary. It changes what an
  agent reports and nothing else.
- A `kind: tool` note points at a committed artifact. A note carrying the
  artifact itself is the "post that contains the work" defect from ADR 0003.
- An agent stops on the reaching signals and reports, and a `BLOCKED` report
  naming the obstacle is the wanted outcome rather than a failure.

## What this amends in ADR 0003

- Board posts are no longer committed, so "git history that supplies
  tamper-evidence" no longer holds for them.
- "A decision made in session two binds in session nine" holds only within a
  checkout, and only because the decision was also written somewhere durable.
- The note kinds are now finding, need, offer, tool, and objection. The four
  message types are unchanged.

Everything else in ADR 0003 stands: issued identity, one manager per project,
the single write grant, append-only posting, basis on every claim, peers who may
object but never authorize, read grants that may be self-issued, and refusal as
a first-class outcome.
