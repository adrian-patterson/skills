# Ship harness-agnostic skills, with no distribution machinery

This repo is modelled on [mattpocock/skills](https://github.com/mattpocock/skills),
which is a published product: it carries changesets, a release GitHub Action, an
npm `package.json`, a Claude Code plugin manifest, a single-plugin marketplace
manifest, an `agents/openai.yaml` beside every skill for Codex, and a `docs/`
tree whose pages are published to a website. Adopting that structure wholesale
would import machinery that exists to serve an audience of tens of thousands of
subscribers across two harnesses.

This is a personal repo with one consumer.

## Decision

Keep the parts that make skills good, drop the parts that make skills
distributable.

**Kept**, because they are what keeps a growing set of skills coherent:

- Bucketed layout under `skills/`, with promoted and non-promoted buckets.
- The user-invoked vs model-invoked split, and the rule that no skill can reach
  a user-invoked one.
- The README index obligations that fire on every change to `skills/`.
- ADRs for structural decisions.
- A `CONTEXT.md` domain model, and the no-em-dashes rule.

**Dropped**:

- **Versioning and release**: changesets, `CHANGELOG.md`, the release workflow,
  `package.json`, and the plugin-version sync script. Nobody subscribes to
  releases, so `git` history is the changelog.
- **Harness manifests**: `.claude-plugin/plugin.json`,
  `.claude-plugin/marketplace.json`, and the per-skill `agents/openai.yaml`.
  A skill is installed as a plain `SKILL.md` directory into `~/.agents/skills`,
  which every supported agent reads. Adding a vendor manifest means maintaining
  a second list of skills that can silently drift from the filesystem.
- **The `docs/` tree** and its writing rules. Those pages exist to be published
  at absolute URLs on a website. With no site, a docs page is a second
  description of a skill that goes stale against the bucket `README.md`.
- **A router skill and a per-repo setup skill**. Both earn their place at a
  certain size. A router over a handful of skills is a file to maintain that
  tells you nothing you could not read off the `README.md`.

**Not taken**: any dependency on another skill set. Skills here stand alone.
Where one needs an interview loop or similar, it either owns that material or
this repo grows its own primitive for it.

## Invariants this creates

- No file in this repo names a specific harness, except the single
  `disable-model-invocation` frontmatter key, whose reason is in
  [.agents/invocation.md](../invocation.md).
- The filesystem is the only list of skills. Nothing enumerates them except the
  `README.md`s, which are for humans and are allowed to be checked by eye.
- Introducing versioning, a vendor manifest, or a docs site is a decision that
  supersedes this ADR, and needs one of its own.
