# Carry context-spec's verdicts, not its runtime

[`context-spec`](https://github.com/adrian-patterson/context-spec) is a separate
project that audits the context a coding agent loads. It is a Node runtime: 22
versioned rules, JSON schemas, transaction gates, a metered agent tier, and four
installed skills that are launchers over `run.mjs` with the spec, methodology,
and decision log vendored beside them.

`context-fix` in this repo covers the same ground. It could have been another
launcher.

## Decision

Port the research verdicts into prose. Port none of the machinery.

The runtime cannot come here. [ADR 0001](0001-harness-agnostic-and-barebones.md)
takes no dependency on another skill set, and a launcher for a checkout the
installer does not have is not a skill, it is a broken symlink. Vendoring the
runtime instead would put a second copy of a versioned rulebook in a repo with no
versioning, which is the drift ADR 0001 refused for vendor manifests.

What made context-spec worth the effort was never the scripts. It was running the
rules against repositories nobody there owned and writing down what failed. Most
of the catalog failed: bare path resolution at 79% to 90% false, budget placement
at 31% correct, directory-tree removal at zero correct actionable findings, and
inferability probing at zero findings ever. Those verdicts are portable and the
implementations are not worth porting, because the implementations are the part
that was wrong.

So `context-fix` carries eight checks whose findings a repository can prove, the
evidence discipline that keeps a finding honest, and an `EVIDENCE.md` recording
what each check does and does not establish along with what was cut and what cut
it. An agent with `git` and `grep` runs all of it.

## Invariants this creates

- `context-fix` names no path, script, or version of `context-spec`, and works
  with that project absent, stale, or private. `EVIDENCE.md` credits it in prose
  and is the authority where the two disagree.
- The cut checks stay cut. Reintroducing one needs a measured run on a corpus it
  was not tuned against, and an entry here.
- A skill in this repo may carry a research summary as a sibling file. It may not
  carry a runtime, a rulebook, or a schema. A skill needing one of those is a
  sign the work belongs in its own project, as this one did.
