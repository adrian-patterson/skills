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

**Handoff**:
A prompt written for a fresh agent to execute one unit of work to completion,
carrying the sources, authority order, and scope boundary that agent cannot
recover from the repository. The artifact, never the act of delegating.
_Avoid_: brief, spec, task prompt

**Authority order**:
The explicit ranking of a project's sources, deciding which one wins where they
disagree. Stated in every handoff, since a receiving agent has no other way to
resolve a conflict.

**Invocation**:
Who can reach a skill: **model-invoked** (model or user) or **user-invoked**
(human only). See `.agents/invocation.md`.

## Relationships

- A **Bucket** holds many **Skills**
- A **Bucket** is either **Promoted** or not, and that decides what the
  top-level `README.md` lists
- A **Skill** has exactly one **Invocation** mode
- A **Handoff** carries exactly one **Authority order**

## Flagged ambiguities

- None yet.
