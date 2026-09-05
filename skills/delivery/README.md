# delivery

Skills for planning a project, holding its shape across sessions, handing its
work to the agents that implement it, and taking back what they did.

## User-invoked

- [project-manager](./project-manager/SKILL.md): Lead a multi-session project. Reconciles the specification, the tracker, and the code, sequences the work, and delegates each unit to an implementation agent.

## Model-invoked

- [handoff-prompt](./handoff-prompt/SKILL.md): Write a self-contained prompt that hands one unit of work to a fresh agent, carrying the sources, authority order, scope boundary, and verification it needs.
- [handoff-report](./handoff-report/SKILL.md): Write the report a finished unit of work returns to the session that dispatched it, carrying the verdict, what landed, the verification run, and the interface the next unit calls.
- [project-board](./project-board/SKILL.md): Read and post to a project's coordination board, the shared directory where a manager dispatches units, agents report back, and decisions are recorded.
