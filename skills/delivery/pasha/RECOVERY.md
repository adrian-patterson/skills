# Resume the manager

After compaction, a restart, or taking over existing work, complete this sequence
before dispatching or accepting work:

1. Locate the existing board from the continuation or handoff's absolute path;
   otherwise locate it through project-board. Read the README checkpoint first.
2. List decisions and posts. Read governing and newer decisions, outstanding
   objections, live handoffs, and reports awaiting acceptance. Follow source
   pointers for disputed claims; accepted history needs no wholesale reread.
3. Reconcile live grants against actual workers and workspaces. A dispatch
   recorded without a worker identifier may have succeeded: establish its
   outcome before retrying. Use the interrupted-attempt procedure below for
   missing reports or uncertain worker state. Preserve reserved boundaries.
4. Refresh the checkpoint from that evidence, including budgets and the exact
   next action. Resume only within recovered authority and limits. If the board
   is lost, reconstruct from durable decisions, tracker, branches, and worker
   state; name gaps and resolve any uncertainty that prevents the next action.

Completion criterion: pending acceptance, live grants, authority, limits, and
next action are reconciled with sources. A conversation summary alone does not
establish them.

# Recover interrupted attempts

Use this procedure when a handoff lacks a report and its worker may have stopped,
or when reconciliation leaves an attempt's working state uncertain.

1. Match the grant to the worker and workspace. Check the worker's actual state;
   a missing report or an idle task label alone does not prove termination. If
   it can resume safely, retain the grant. Before reassigning its boundary,
   confirm it has stopped, including any commands it left running. If that
   cannot be established, keep the boundary reserved and name the uncertainty.
2. Inspect the branch, commits, uncommitted changes, surviving artifacts, and
   tracker state. Preserve recoverable work and distinguish verified results
   from unverified changes. Missing temporary files are missing evidence.
3. Obtain a final report when the worker can provide one. Otherwise append a
   manager decision closing the interrupted attempt and revoking its grant.
   Name the handoff, termination evidence, surviving revision and workspace,
   verification gaps, and remaining work. Do not impersonate the worker or
   infer acceptance from a closed tracker item. Persist the decision under the
   board's durable-record rule.
4. Refresh the manager checkpoint in the board README. A retry carries the
   prior report, or the recovery decision when no report exists, and states
   what to resume, what was lost, and what must be verified again. Accept a
   completed unit only through the normal acceptance step.
