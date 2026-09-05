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

### delivery

Planning a project, holding its shape across sessions, handing its work to the
agents that implement it, and taking back what they did. Bucket index:
[skills/delivery](./skills/delivery/README.md).

**User-invoked**

- [project-manager](./skills/delivery/project-manager/SKILL.md): Lead a
  multi-session project. Reconciles the specification, the tracker, and the
  code, sequences the work, and delegates each unit to an implementation agent.

**Model-invoked**

- [handoff-prompt](./skills/delivery/handoff-prompt/SKILL.md): Write a
  self-contained prompt that hands one unit of work to a fresh agent, carrying
  the sources, authority order, scope boundary, and verification it needs.
- [handoff-report](./skills/delivery/handoff-report/SKILL.md): Write the report
  a finished unit of work returns to the session that dispatched it, carrying
  the verdict, what landed, the verification run, and the interface the next
  unit calls.
- [project-board](./skills/delivery/project-board/SKILL.md): Read and post to a
  project's coordination board, the shared directory where a manager dispatches
  units, agents report back, and decisions are recorded.

### engineering

Writing, reviewing, and shipping code. Bucket index:
[skills/engineering](./skills/engineering/README.md).

**Model-invoked**

- [context-fix](./skills/engineering/context-fix/SKILL.md): Audit a
  repository's agent context against the code it describes, then repair the
  defects the repository can prove.
- [pr-description](./skills/engineering/pr-description/SKILL.md): Write the
  pull request description for the current branch as markdown to paste into
  GitHub.
- [triage-gh-pr-comments](./skills/engineering/triage-gh-pr-comments/SKILL.md):
  Triage the review comments on the current branch's GitHub PR, report the
  verdicts, and fix the approved ones. Needs the GitHub MCP server.

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
