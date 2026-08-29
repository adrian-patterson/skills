---
name: context-fix
description: Audit a repository's agent context (AGENTS.md, CLAUDE.md, and skill files) against the code it describes, then repair the defects the repository can prove. Use when the user asks to audit, check, verify, update, or fix agent context, AGENTS.md, or CLAUDE.md, wonders whether their agent instructions are still true, or thinks context has gone stale.
---

# Context fix

Agents obey context files. When a context file names a repo-specific tool, agents use it roughly 2.5 times per task; when it does not, roughly 0.05 times. A stale command is not ignored, it is run. Repairing that is the whole job.

Correct what the repository proves false. Change nothing else.

## Guardrail

The first pass is read-only: no edits, no commits, no branches. Report, then stop and ask which findings to apply. Apply approved edits only in a later turn. If the user asked only to audit, stop after the report and do not offer a fix list they did not ask for.

## 1. Map the context

Find the files an agent actually loads, and nothing else:

- `AGENTS.md` and `CLAUDE.md` at every level of the tree;
- skill files under `.agents/skills/`, `.claude/skills/`, or `skills/`;
- any file one of the above tells the agent to read.

Vendor rule files in other formats (`.cursor/rules`, `.github/copilot-instructions.md`, `.windsurfrules`) are listed in the report and never audited. Record which tier each file is in: always loaded, or loaded only under a stated condition.

Completion criterion: you can name every context file, its tier, and the commit you are auditing.

## 2. Check what the repository can prove

Run these eight checks and no others. Each one fails only when a source outside the context files contradicts the text.

1. **Named commands.** A command the context tells the agent to run is absent from `package.json` scripts, the Makefile, the justfile, `pyproject.toml`, `Cargo.toml`, or wherever this repository defines its commands. Proof: the manifest.
2. **Document links.** A relative link to a file in this repository resolves to nothing. Proof: the tree.
3. **Renamed paths.** A referenced path is missing now and `git log --diff-filter=R --follow` shows it moved. Proof: the rename commit. A path that is merely absent, with no rename behind it, is not a finding here. See "What not to check".
4. **Script drift.** The context quotes a command's body or flags and the manifest now defines it differently. Proof: the two texts side by side.
5. **Enumeration drift.** A list presented as complete (the packages, the services, the skills, the rule files) disagrees with the directory or manifest it enumerates. Proof: the listing. This check finds more real defects than any other; run it on every list in the context.
6. **Diverged mirrors.** Two context files carry the same guidance and no longer agree, most often `AGENTS.md` and a `CLAUDE.md` copied from it. Proof: the diff between them.
7. **Completed-work directives.** The context instructs the agent to carry out a migration, plan, or task list that is finished. Proof: the plan document showing every item complete, or the commits that finished it.
8. **Contradicted claims.** A factual claim about the repository that the code, config, or history contradicts. Proof: the file and line that says otherwise.

Read `EVIDENCE.md` beside this file before telling the user what a finding establishes, or when deciding whether a borderline result is worth reporting.

## 3. Hold every finding to its evidence

- **No citation, no finding.** A finding without a file and line supporting it is dropped, not softened into a suggestion.
- **A context file cannot be its own evidence.** Guidance is not proof that the guidance is true. Cite code, config, manifests, or history.
- **A cited path must exist.** Verify each one before it goes in the report.
- **Quote exactly.** If the quoted text is not in the file at the line you cite, the finding is wrong.
- **A correction is a value you found, never prose you wrote.** Substitute the real command, the real path, the real list. If the repository does not supply the replacement, the finding is report-only or a deletion, and it says which.

## 4. Report

Group by check, most certain first. For each finding give a stable ID (`C01`, `C02`, ...), the context file and line, what it says, the evidence that contradicts it, and the exact edit proposed. Mark each one **fix** (an exact substitution or deletion) or **review** (real, but the repair needs a decision you cannot make).

Then a short list of what you checked and found clean, so the user knows the silence was tested rather than skipped.

Say plainly what this establishes: the repository contradicts these claims. It does not establish that any of them changed an agent's behaviour on a real task. Measured effects of context files on task success are null in both directions; what is measured is that agents follow the instructions they are given.

End by asking which IDs to apply.

## 5. Apply

Edit only the lines named by the approved IDs. Make no commit, no branch, and no push, so the user reviews with `git diff`. Report anything an edit turned out not to fit, and leave it unapplied rather than widening it.

## What not to check

Every item below was measured against repositories and failed. Reporting them is how a useful report becomes noise.

- **Bare path references that are absent with no rename behind them.** Between 79% and 90% false on repositories it was not tuned against.
- **Always-loaded token budgets and where content sits.** 31% correct. Its usual remedy moves a constraint every task needs behind a pointer.
- **Directory trees pasted into context.** Detection works and the fixes were worthless: zero correct actionable findings, and only 0.7% of tree entries were stale.
- **File size, section order, and file architecture.** No detectable effect on instruction adherence across 16,050 observations.
- **Missing guidance.** Report an absence if the user asked what is missing. Never author the replacement; that is a different act with different authority.

Do not restructure, reformat, condense, or restyle a context file. Do not add sections. Correctness is the deliverable.
