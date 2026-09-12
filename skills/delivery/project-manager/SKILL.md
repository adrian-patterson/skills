---
name: project-manager
description: Lead a multi-session project one milestone at a time, with bounded delegation and verified acceptance.
disable-model-invocation: true
---

# Project manager

Lead projects whose dependent deliverables span sessions. Reconcile the specification, tracker, and code; sequence units; delegate implementation; and accept the results against evidence. Manage one active milestone, with a visible backlog beyond it.

## 1. Choose the working scope

For a bug, bounded feature, or small refactor, keep one agent responsible for investigation through verification. If invoked for that work, handle it directly without creating a board or management pipeline. Add a bounded helper only for substantial independent investigation or review.

For a multi-session project, name the active **milestone**: the next outcome the user can accept, its acceptance criteria, and the units needed to deliver it. Use the user's priority where given; otherwise select the smallest useful milestone and state the choice. Keep other milestones in the backlog. A new request joins that backlog unless the user changes the active priority; when switching, record what is paused and resolve live grants before starting replacement work.

Use sources already named in the session. Ask for a missing source only when it prevents establishing the milestone or its acceptance criteria. Check available tools before choosing access routes, preferring a connector, then a CLI, then a browser. Name unreachable sources and the claims that remain uncertain.

Fix the **authority order**: which source defines behaviour, refines technical detail, scopes a unit, or supplies patterns. Existing code supplies patterns unless no other source defines behaviour.

For multi-session coordination, call the Skill tool with "project-board" to locate or set up the project's one board. Record the active milestone, acceptance criteria, and operating limits in its README. When taking over existing work, count live grants before dispatching anything; if over the limits, let them finish or cancel them and obtain a final report closing each grant before adding work.

Completion criterion: the active milestone, its acceptance criteria, authority order, and live work are explicit. Mapping the whole backlog is unnecessary unless the user requested it.

## 2. Reconcile only what affects this milestone

Sweep the board first: list posts and decisions, read new decisions, then live attempts and returned attempts still awaiting acceptance. A matching report closes an attempt and its grant, not the unit. Use acceptance decisions to distinguish accepted units from work still pending. Read older accepted work only when a dependency or disputed claim requires it.

Compare the relevant specification sections, tracker units, and code for:

- Required behaviour with no unit, or a unit with no requirement.
- Work already delivered, or existing behaviour that contradicts its contract.
- Overlapping boundaries, missing dependencies, or duplicated mechanisms.

Every finding carries its source. Mark unverified findings as suspected. Investigate outside the milestone only when it could change its scope, order, or acceptance; park other discoveries with a source pointer.

Perform cheap factual checks directly: read a targeted diff, query a tracker item, check a merge or CI result, or inspect a small source section. Delegate when the investigation is substantial, benefits from an independent assessment, or needs separate context. Group questions that share the same reading into one investigation.

Completion criterion: each active unit has a boundary, dependency order, and acceptance criterion; consequential disagreements are resolved or named as blockers.

## 3. Bound the delegation

Default to **one writer and at most one reader across the project**, including any helpers workers request. The writer owns investigation, implementation, and verification within its unit. A reader owns a substantial question or review and may publish coordination artifacts, but cannot change the implementation.

One write grant remains the project invariant. Increase the reader limit only for named independent questions whose expected value justifies the extra cost. Record the reason, limit, and when it returns to the default. A spare concurrency slot is not a reason to fill it.

Before dispatching, check live grants on the board. Peers post requests for help; the manager allocates the reader slot. Issue no further delegation until outstanding objections have been ruled on.

Before every dispatch, including authorized helpers, classify the unit and select the lowest available **capability tier** adequate for its complexity, uncertainty, and consequences of error:

- **Low:** mechanical, well-specified work with straightforward verification.
- **Medium:** bounded implementation or investigation requiring judgment.
- **High:** ambiguous, cross-cutting, or high-consequence reasoning.

Resolve these relative tiers against the environment's available models using its capability descriptions, without hard-coding provider or model names. Record the classification, selected tier, resolved model, and a brief rationale in the handoff. Explicitly apply the selection through the dispatch tool; a label in the prompt alone does not select a model. If selection is unavailable or the mapping is uncertain, disclose the limitation and actual default used. Escalate only with evidence that the current tier is inadequate, carrying that evidence into the next handoff. Read and write grants do not determine capability tier.

Call the Skill tool with "handoff-prompt" to prepare each dispatch. Supply:

- Unit identifier and name, read or write grant, boundary, and authority order.
- The project's end, active milestone, relevant sibling dependencies, and source pointers.
- Acceptance criteria, required verification, and where the result must be integrated.
- A concrete effort budget and stopping condition, plus whether any helper is authorized.
- Capability-tier classification, resolved model selection, and rationale, or the disclosed selection limitation.

Use an available token or cost limit when it can be measured; otherwise specify a tool-call or elapsed-time budget that the worker can track. Use the user's budget where given, or state a proportional starting allowance. Reserve enough of it for verification and reporting. Exhausting the allowance returns a PARTIAL or BLOCKED report with remaining work and a proposed next step; it never silently renews the budget or waives acceptance checks.

Batch small independent units sharing setup and validation into one writer handoff with one report per item. Keep dependent units separate. Send the prepared handoff verbatim, with only the context needed for that unit rather than the full conversation.

A lookahead reader is optional. Dispatch one only when its answer will affect the next decision and is unlikely to be invalidated by the current implementation. Waiting for a writer is otherwise useful and costs no investigation tokens.

After dispatch, wait for the result using the available agent wait mechanism. Avoid repeated status checks and duplicate verification while the worker is still producing that evidence. If the environment cannot wait, name the dispatch, report location, and how to resume the acceptance step.

## 4. Accept the result and advance

On return, read the report's verdict and the sections needed to decide: `Delivered`, `Verification`, and `Changed` for completion; `Interface` for dependencies; deviations and `Boundary` where scope changed; `Unresolved` for blockers; and `Found for others` for relevant discoveries.

- `COMPLETE` or `COMPLETE WITH DEVIATIONS`: assess the evidence against acceptance criteria, rule on deviations, and check the required integration state.
- `PARTIAL` or `ABANDONED`: establish what remains and the branch state before scoping another attempt.
- `BLOCKED`: resolve the named blocker or change the unit's scope before retrying. Carry the prior report into the next handoff.

A report is evidence, not acceptance. Confirm the relevant revision or artifact and verification results. Cheap checks belong here; substantial independent validation can use the reader slot. Repeat checks only for missing evidence, changed code, failures, or unresolved concerns.

Record acceptance as a decision referencing the unit, report, verified artifact or revision, and integration state. Use the existing decision format, not a new post type. If the handoff requires a merge, an unmerged branch remains pending integration. If it requires a reviewed artifact, use that criterion instead. Acceptance within standing authority needs no extra user confirmation; require human acceptance only when the project calls for it.

Fold the accepted interface into the plan and reconsider only affected dependencies. Advance within the authorized milestone. When all its criteria are met, report its outcome and propose the next milestone; start it only when existing authorization covers it.

Completion criterion: returned attempts are accepted, pending named verification or integration, or assigned an explicit remainder. An expired grant alone never means delivered work.

## 5. Keep the user oriented

At meaningful transitions, present one compact status using these fields:

- **Milestone:** the outcome currently being delivered.
- **Finished:** accepted results since the last update.
- **Running:** current writer and reader, each paired with its unit's name.
- **Needs your decision:** consequential choices outside standing authority, with a recommendation; otherwise none.
- **Next:** the next unit or acceptance step.

Pair identifiers with tracker titles or short descriptions. Surface material budget overruns or missing evidence here. Keep the wider backlog out of routine updates unless its priority changed.

At milestone completion, record available total tokens or cost across manager and workers, elapsed time, user interventions, and rework through acceptance. Mark unavailable measurements as unavailable. Compare similar accepted outcomes when judging whether delegation earned its cost; worker count and activity are not success measures.

## Standing rules

- **Act within existing authorization.** Make routine reversible implementation choices consistent with the contract and record material assumptions. Surface gaps that affect behaviour, scope, irreversible actions, or acceptance instead of inventing requirements.
- **Tracker changes follow authority.** Apply corrections or updates already authorized. For a change outside that authority, propose exact text and obtain approval before writing.
- **Persist binding decisions.** Record changes to contracts, boundaries, acceptance, or operating limits on the board and in the project's durable specification, tracker, or ADR. Routine status belongs in the status view, not a new architectural decision.
- **Budget the whole system.** Delegation saves manager context by spending worker context. Prefer a direct check or reused evidence when that answers the same question adequately.
- **Checkpoint when continuity weakens.** If repeated reads or uncertain recollection make decisions unreliable, record the active milestone, accepted and pending units, live grants, budgets, and next action. Resume from that checkpoint and source pointers. A normal board refresh is not itself a reason to replace the manager.
