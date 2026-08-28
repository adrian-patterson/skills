# Working in this repo

This repo is a set of agent skills and nothing else. It targets the Agent Skills
standard, not any one harness: every skill is a plain directory containing a
`SKILL.md`, and it is installed with [`npx skills`](https://skills.sh) into
`~/.agents/skills`. There are no harness-specific manifests here (no
`.claude-plugin/`, no `agents/openai.yaml`), and none should be added without an
ADR saying why.

## Layout

```
skills/<bucket>/<skill-name>/SKILL.md
```

Every skill lives inside a **bucket**: a folder under `skills/` naming a domain
of work, such as `engineering/` or `productivity/`. Buckets are created when a
skill needs one, not up front. A skill that fits no existing bucket either joins
the closest one or gets a new bucket in the same change; two buckets that would
hold the same kind of work is a smell, so widen an existing one before adding a
third.

Three bucket names are reserved with fixed meanings, to be created only when
first used:

- `in-progress/`: drafts. Real, installable, not yet trusted.
- `deprecated/`: retired. Kept only where something still points at it.
- `misc/`: kept around, rarely used, deliberately not promoted.

Every other bucket is **promoted**: it holds skills that are ready to use.

## What a change to `skills/` obliges

Adding, renaming, moving, or removing a skill is never a one-file change. In the
same commit:

- **The top-level `README.md`** lists every promoted skill, with the skill name
  linked to its `SKILL.md`. Skills in `in-progress/`, `deprecated/`, and `misc/`
  never appear there.
- **The bucket's own `README.md`** lists every skill in that bucket with a
  one-line description, name linked to its `SKILL.md`. A new bucket gets a
  `README.md` in the change that creates it.
- Promoted bucket `README.md`s and the top-level `README.md` group entries under
  **User-invoked** and **Model-invoked**. Non-promoted buckets use a flat list.
- A rename moves the folder and updates every reference to the old name.

## Invocation

Every skill is either user-invoked or model-invoked, and the choice is deliberate
rather than a default that fell out. The rules, the frontmatter, and the test for
which one a skill should be are in [.agents/invocation.md](./.agents/invocation.md).

## Writing the skill itself

A `SKILL.md` is a prompt, not documentation. Write it as instructions to the
agent that will run it:

- **Frontmatter carries `name` and `description`, and nothing else that isn't
  load-bearing.** `name` matches the folder name exactly.
- **The `description` is the whole trigger mechanism** for a model-invoked
  skill. It states what the skill does and when to use it, in the words a user
  would actually say. For a user-invoked skill it is a human-facing one-liner
  instead, with the trigger phrasing stripped out.
- **Cut every sentence the agent already knows.** Length is a cost paid on every
  invocation. A skill that restates general good practice teaches nothing and
  crowds out the part that does.
- **Be specific about the shape of the output**, including literal formats where
  the format matters. Vague instructions produce vague runs.
- **Supporting material goes in a sibling file** inside the skill folder
  (`skills/<bucket>/<name>/SOMETHING.md`), reached by a pointer from `SKILL.md`,
  so it is loaded only when needed.

## Prose conventions

- **No em-dashes anywhere in this repo**, in `SKILL.md` files, `README.md`s,
  ADRs, or code comments. Where a sentence reaches for one, rewrite it with a
  comma, colon, period, parentheses, or a conjunction, whichever the sentence
  actually wants. Never do a blind character substitution.
- Use the repo's own vocabulary as recorded in [CONTEXT.md](./CONTEXT.md), and
  add a term there when a new one starts doing real work.

## Decisions

Anything structural that a future reader would otherwise re-litigate goes in
`.agents/adr/NNNN-kebab-title.md`: the constraint, the decision, and the
invariants it creates. Adding a harness-specific manifest, changing the bucket
scheme, or taking on a dependency all qualify.

## Installing locally

`scripts/link-skills.sh` symlinks every skill in this repo into
`~/.agents/skills`, so an edit here is live immediately. Re-run it after adding,
renaming, or removing a skill. It is a dev-only script for this machine, not an
installer for anyone else. Do not run it on a machine where these skills were
installed with `npx skills`, since the two would fight over the same directory.
