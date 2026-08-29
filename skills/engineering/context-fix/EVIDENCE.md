# What a context finding establishes

This file exists so the skill can be honest about its own value. Read it before
telling a user what a finding proves, or when deciding whether a borderline
result is worth reporting at all.

Every number here comes from a measured run. The findings that killed checks are
recorded at the same weight as the ones that kept them.

## The premise

**Agents follow the instructions in context files.** When a context file names a
repo-specific tool, agents used it about 2.5 times per task instance; when it did
not, about 0.05 times. For `uv` the split was 1.6 against under 0.01.
[arXiv:2602.11988](https://arxiv.org/abs/2602.11988), trace analysis.

This is what makes a wrong context file worse than no context file. A stale
command is not filtered out by a competent reader, it is executed. Every check in
this skill rests on that and on nothing else.

**Context files show no measured effect on whether a task succeeds**, in either
direction, while measurably raising inference cost. Same paper: 300 SWE-bench
Lite tasks plus 138 tasks over 12 repositories with developer-written context
files. Generated context files moved resolution by -0.5% at p=0.87.

Its scope is narrow, and the narrowness matters: Python only, and issue
resolution as the sole outcome. Most of what people put in a context file aims at
*how* work gets done, which that study does not observe. "Did not improve issue
resolution" is not "had no effect", and neither one licenses deleting a
constraint someone wrote on purpose.

So: repair what is false, and make no claim about performance.

## What each check establishes

| Check | It establishes | It does not establish |
|---|---|---|
| Named commands | The command is absent from the manifest at this commit | That anyone ran it and failed |
| Document links | The link target is absent from the tree | That a reader needed it |
| Renamed paths | The path moved, and history names the commit | That the reference was correct before the move |
| Script drift | The quoted body differs from the defined one | Which of the two is wanted |
| Enumeration drift | The list and the directory disagree | Whether the omission was deliberate |
| Diverged mirrors | Two context files disagree | Which one is right |
| Completed-work directives | The referenced work is finished | That an agent acted on the stale instruction |
| Contradicted claims | Repository evidence contradicts the statement | That the claim was ever true |

The first seven are definitional: two artifacts in the repository disagree and
anyone can see it. The eighth depends on judgment about what counts as
contradiction, which is why it needs a citation outside the context files.

A clean result and an unrun check look identical to a user. Say which checks ran.

## What was cut, and what cut it

Do not reintroduce these. Each was implemented, run against repositories it had
not been tuned on, and failed there.

**Bare path resolution.** Reporting any referenced path absent from the tree.
Ten untuned repositories, 87 findings triaged one at a time: 9 true, 69 false, 9
arguable, so **79.3% to 89.7% false**. Five of the ten produced nothing but false
positives. It was corrected four times and performed *worse* on unseen data than
on the data that corrected it, which is the signature of fitting a corpus rather
than a phenomenon. What survives is the rename case, where history supplies proof
that a lexical check cannot.

**Always-loaded token budget and content placement.** 9 true, 3 arguable, 17
false: **31% correct**, wrong more often than right. Worse than the rate, its
defence was that a wrong call costs one extra hop and never a lost constraint.
Ten of the seventeen were a universal build and test gate read as one task's
workflow, six of those the same block in sibling files. Moving those puts a
constraint every task needs behind a pointer. A separate ceiling on skill
descriptions was retired outright: none of its eight breaches had a safe fix,
because every one was trigger content, and moving trigger content into a skill's
body means the skill never fires.

**Pasted directory trees.** Detection was near perfect: 28 of 33 blocks were
genuinely trees, with no shape false positives. Everything downstream was
worthless. **Correct actionable findings: zero**, and resolving every entry across
all 33 blocks found 4 stale in 573, or **0.7%**. Trees stay accurate.

**Structure and size.** 1,650 agent sessions, 16,050 function-level observations,
two codebases, three models. None of file size, instruction position, file
architecture, or contradictions in an adjacent file produced a detectable effect
on instruction adherence after correction for multiple testing.
[arXiv:2607.27250](https://arxiv.org/abs/2607.27250). This is the reason the
skill does not restructure, reorder, or condense.

**Inferability probing.** Strip the context files, ask an agent to recover a
claim from the repository alone, delete the line if it can. The most expensive
check ever built here. In a hand audit of a real repository it fired **zero**
times, and the reason is structural: a well-maintained context file is a routing
overlay of pointers, invariants, and local conventions, and an invariant is
definitionally not recoverable from the tree. Retired.

## The one that justified the exercise

Enumeration drift found three real defects on the first repository it was run
against, where a careful hand audit had found one, including two directory
listings the human reviewer had not thought to check. Lists that claim to be
complete are the highest-yield thing in a context file. Check every one.

Completed-work directives nearly died the opposite way. Its founding case turned
out to be unreachable from any loaded file, so the check briefly stood on
nothing. A real instance was found later in a search over 476 references across
ten repositories: a context file ordering an agent to follow a task list "before
any work", where the list was 93 of 93 complete. One repository in ten, and four
near-misses rejected. Real, and rare.

## Provenance

These findings come from `context-spec`, a rulebook project that measured 22
checks against untuned repository corpora and recorded every demotion. This skill
carries the verdicts, not the machinery. Where a number here disagrees with a
memory of that project, this file is the one the skill was written against.
