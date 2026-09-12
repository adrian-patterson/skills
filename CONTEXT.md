# Adrian's Skills

A personal collection of agent skills, written against the Agent Skills standard
and installed with `npx skills`. Harness-agnostic by construction: the repo
carries no vendor manifests.

## Language

**Skill**:
A directory containing a `SKILL.md`, plus any supporting files it owns. The unit
this repo ships. Always the directory, never just the Markdown file.
_Avoid_: command, prompt, plugin

**Bucket**:
A folder directly under `skills/` grouping skills by domain of work. Buckets are
created on demand, not planned in advance.
_Avoid_: category, namespace, group

**Promoted**:
A property of a bucket: its skills are ready to use, so they appear in the
top-level `README.md`. `in-progress/`, `deprecated/`, and `misc/` are the
non-promoted buckets.

**Unit**:
One piece of a project's work, small enough that a single agent can carry it to
completion and large enough to be worth handing off. What a tracker item names,
a handoff scopes, and the manager accepts after verification and required
integration.
_Avoid_: task, ticket, story, chunk

**Milestone**:
The next project outcome the user can accept, with explicit acceptance criteria
and the units needed to deliver it. One is active; later outcomes remain backlog.

**Attempt**:
One execution of a unit under a grant, ending in a report. A returned attempt may
leave the unit pending verification, integration, or another attempt.

**Acceptance**:
The manager's evidence-backed decision that a unit meets its acceptance criteria
and required integration state. Distinct from an agent reporting completion.

**Boundary**:
The line between what a unit owns and what its siblings own. Stated as two
explicit lists in every handoff, and answered by two more in every report,
because a capable agent absorbs its neighbours unless told not to.

**End**:
What the whole project is working toward, stated in one line in every handoff.
Not a unit's deliverable and not a motivation: it is the frame that lets an
agent judge whether something outside its boundary is worth reporting. It
decides what an agent reports and never what it does.
_Avoid_: goal, mission, objective

**Reaching**:
What an agent does instead of stopping when it cannot finish: a third distinct
approach to the same obstacle, needing access nobody granted it, or changing
what it is doing rather than how. Named because it is recognisable from inside,
which is what makes it a usable stopping condition.
_Avoid_: scope creep, going rogue

**Handoff**:
A prompt written for a fresh agent to execute one unit of work to completion,
carrying the sources, authority order, and scope boundary that agent cannot
recover from the repository. The artifact, never the act of delegating.
_Avoid_: brief, spec, task prompt

**Report**:
What an attempt returns to the session that dispatched it, carrying the
verdict, what landed, and the interface the next unit calls. The artifact, never
the act of reporting. Pairs with a handoff, one each way.
_Avoid_: summary, update, status

**Board**:
The directory in a repository where the agents on one project coordinate:
dispatches, reports, and decisions, and nothing else. A blackboard, not a chat.
One project has exactly one. It lives in `.tmp/` and is never committed, so it is
the project's working memory and never its record.
_Avoid_: channel, queue, inbox

**Post**:
One file on a board. Always a claim to verify against the repository, except a
decision, which is the only kind that binds.
_Avoid_: message, note, entry

**Note**:
A post carrying a finding, a need, an offer, a tool, or an objection between
peers. It binds nobody, and it carries the basis of every claim it makes. The
only kind a peer may act on unprompted is an objection, which halts.

**Grant**:
What a handoff issues along with an identity: the unit, the boundary, and
whether the receiving agent may write or only read. It is what makes an
asserted identity checkable, and it expires when the report is filed.

**Authority order**:
The explicit ranking of a project's sources, deciding which one wins where they
disagree. Stated in every handoff, since a receiving agent has no other way to
resolve a conflict.

**Capability tier**:
A provider-agnostic level of agent capability, low, medium, or high, matched to
a unit's complexity, uncertainty, and consequences of error. Distinct from its
read or write grant and effort budget.

**Invocation**:
Who can reach a skill: **model-invoked** (model or user) or **user-invoked**
(human only). See `.agents/invocation.md`.

## Relationships

- A **Bucket** holds many **Skills**
- A **Bucket** is either **Promoted** or not, and that decides what the
  top-level `README.md` lists
- A **Skill** has exactly one **Invocation** mode
- A **Handoff** carries exactly one **Authority order**, and states the project's
  one **End** plus the open **Units** and what each blocked one is blocked on
- A **Handoff** dispatches an **Attempt** of a **Unit**; its **Report** closes
  the attempt, and **Acceptance** closes the unit. A batch shares one grant
  across independent units and returns one report per item
- A **Unit** has exactly one **Boundary**, which the **Handoff** states and the
  **Report** answers against
- A **Board** holds many **Posts**, and every **Handoff** and **Report** is one
- A **Handoff** issues exactly one **Grant**, and at most one write **Grant**
  is open across a project at a time

## Flagged ambiguities

- None yet.
