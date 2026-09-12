---
name: handoff-report
description: Write the report a finished unit of work returns to the session that dispatched it, carrying the verdict, what landed, the verification actually run, the interface the next unit calls, and where the work met its boundary. Use when an agent has finished, stalled, or abandoned work it was handed, when a handoff prompt asks it to report, or when the user asks to report back or close the loop on delegated work.
---

# Handoff report

A **report** is what an attempt returns to the session that dispatched it. It is the other half of a handoff: the handoff carried what the receiving agent could not recover from the repository, and the report carries what the dispatching session cannot recover from this one.

That session has no transcript of this one, no tool output, no diff. It has the boundary it drew and the repository. Everything else, it learns here.

The work is over. Writing the report changes no code: read what landed, verify it, print the report.

## 1. Fix the verdict first

One of these, chosen before anything else is written, because a verdict picked last gets written to match the narrative:

- **COMPLETE**: everything the unit owned is delivered and verified.
- **COMPLETE WITH DEVIATIONS**: delivered, but something differs from what the handoff specified. Every deviation is named, with what forced it.
- **PARTIAL**: some requirements landed and others did not. The split is named requirement by requirement.
- **BLOCKED**: the work cannot proceed without a decision, a fact, or an access this session does not have. What would unblock it is named exactly.
- **ABANDONED**: work was started and undone. What was reverted, and what state the branch is left in, are both named.

**A batch gets one report per item, each with its own verdict.** The handoff granted several units together to pay for its preamble once; the reports stay separate so the board still shows each unit's outcome, and so a blocked item does not drag a delivered one into its verdict.

**BLOCKED beats a guess.** Never widen the scope, infer a missing fact, or reach past the boundary in order to turn a BLOCKED into a COMPLETE. A blocked unit with its blocker named is a finished report, and it is worth more than a completion that has to be unpicked.

The signals arrive before the verdict does, and they are behavioural: a third distinct approach to the same obstacle, needing access or tooling the handoff never named, or noticing that you have changed *what* you are doing rather than *how*. Each of those means the unit was scoped wrong, not that you were close. An agent that cannot finish rarely stops on its own; it reaches further, and every step of that reaching is work somebody has to unpick later.

The verdict closes this attempt and its grant. The manager accepts the unit separately against verification and the required integration state; `COMPLETE` alone does not assert that a branch is merged or the unit accepted.

## 2. Establish what landed

Read the diff. Do not recall it.

- The files changed, each with what it now does.
- The commits, branch, and pull request by identifier, and what is pushed rather than sitting local.
- Anything created outside the repository: a migration run, a resource provisioned, a secret set.

## 3. Report the verification you ran

Take the commands from the handoff's validation section, or from the repository's own manifests where the work arrived without one. Give the result of each: passed, failed, or not run with the reason. Name the directory each ran from.

Never report a check that was not run, and never report a result from memory. A skipped check said plainly costs the reader a minute. A check reported as passing that never ran costs them the next unit.

Include available token or cost usage, elapsed time, and whether the allowance was exhausted. Mark unavailable measurements as unavailable rather than estimating them as facts.

## 4. Report the interface

What the next units call, and where it lives: exported names and signatures, routes, schemas, configuration keys, migrations, fixtures. This is what the dispatching session folds into the plan, and it is the first thing a summary loses.

## 5. Report the boundary

Two lists, answering the ones the handoff drew:

- **Left alone**: adjacent work reached during this unit and deliberately not taken, named by its own identifier where one exists.
- **Went past**: anything changed that this unit did not own, each with why. Empty is the expected answer, and an empty list arrived at by checking is worth more than one asserted.

Where the boundary itself was wrong, say so. A unit that could not be built without its neighbour is a finding about the plan, and the dispatching session is the one that can act on it.

## 6. Report what you found for others

The handoff named the open units and what each blocked one was blocked on. Answer it: anything you learned that bears on one of them, with its basis.

This is knowledge, not scope. You were right not to act on it, and you would be wrong to drop it, because the alternative is that whichever unit owns that ground pays full price to rediscover what you already know. A pointer costs you a line and saves it a dispatch.

Two things belong here that a summary always loses. The first is the wrong turn: the approach that looked right and was not, and how far in that became clear. The second is anything you built for yourself that another unit could run as-is, a script, a fixture, a query, a repro case. Commit it to the repository and give the path, never the contents.

Where the project has a board, each of these is also a note on it, so it reaches the agent working now instead of waiting on the manager to relay it.

## 7. Report what is unresolved

- Decisions surfaced and left open, each with the options and what turns on them.
- Assumptions made in order to proceed, each with what backs it.
- Defects in the handoff: a path that did not exist, a command that did not run, a source that could not be reached, a requirement that contradicted another.

The last of these is the most valuable line in the report, because the next handoff is about to repeat it.

## 8. Write and deliver

Include a section only where there is real content for it.

```
<VERDICT>: <identifier>, <one sentence>

Delivered
<what the unit now does, at the altitude the plan is held at>

Changed
<files and what each does; commits, branch, and PR by identifier; what is pushed>

Verification
<each command, its directory, and its result: passed, failed, or not run and why>

Interface
<what the next units call, and where it lives>

Boundary
Left alone: ...
Went past: ...

Found for others
<what you learned that bears on another unit, with its basis; the wrong turn worth
knowing about; anything you built that another unit can run, by path>

Unresolved
<open decisions, assumptions and what backs them, defects found in the handoff>
```

Where the handoff named a board, call the Skill tool with "project-board" and save the report there, then return the verdict, the path, and the one-sentence summary. Those three lines are the whole reply: the report is on the board, and the dispatching session reads the section its verdict points at. Returning the body as well is how a manager ends up holding every report it ever dispatched.

Otherwise print it in one fenced block, the last thing in the reply, ready to paste into the dispatching session. Either way, list in one or two lines anything that could not be verified.

## Grounding rules

- **Cite, do not recall.** Every claim traces to the diff, to a command's output, or to a file. At the end of a long implementation session the memory of what landed is weakest exactly where it feels most settled.
- **Nothing refers to this session.** No "as noted above", no "the file we just changed", no pronoun whose referent is in this conversation. The reader has none of it.
- **Every identifier resolves.** A path, command, or unit name that does not exist in the repository costs the reader more than an omission, because they spend their first minutes proving the report wrong.
- **Write it as data, not prose.** Lines under each heading: paths, identifiers, commands, verdicts, one-clause findings. No preamble, no restating the handoff back, no sign-off. Compress the shape, never the basis: the path and line, the exact command, and the word marking a claim as inference are what make a short report checkable instead of merely confident.
- **A bad outcome reported plainly beats a good one reported vaguely.** The report is read by a session that will check it against the repository, so hedging only delays the correction.
