# Skills

My agent skills. Harness-agnostic: each one is a plain `SKILL.md` directory
built to the [Agent Skills](https://skills.sh) standard, so it runs anywhere
that reads `~/.agents/skills`.

## Install

```bash
npx skills@latest add adrian-patterson/skills
```

Pick the skills you want and the agents to install them on. To update later:

```bash
npx skills@latest update
```

## Reference

Skills split on one axis: who can invoke them. **User-invoked** skills are
reachable only when you type them, and their job is to orchestrate.
**Model-invoked** skills can be typed by you *or* reached for automatically by
the agent when the task fits, and they hold the reusable discipline.

Nothing here yet. Skills and their buckets get added as they are written.

## Working on these

Conventions live in [AGENTS.md](./AGENTS.md): the layout, what a change to
`skills/` obliges, how to write a `SKILL.md`, and the prose rules. The
invocation split is in [.agents/invocation.md](./.agents/invocation.md), the
repo's vocabulary in [CONTEXT.md](./CONTEXT.md), and structural decisions in
[.agents/adr/](./.agents/adr/).

To work on a skill on this machine, symlink the repo into `~/.agents/skills` so
edits are live:

```bash
./scripts/link-skills.sh
```

That is a dev script, not an installer. Use one or the other on a given machine,
never both.
