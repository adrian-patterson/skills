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

**Invocation**:
Who can reach a skill: **model-invoked** (model or user) or **user-invoked**
(human only). See `.agents/invocation.md`.

## Relationships

- A **Bucket** holds many **Skills**
- A **Bucket** is either **Promoted** or not, and that decides what the
  top-level `README.md` lists
- A **Skill** has exactly one **Invocation** mode

## Flagged ambiguities

- None yet.
