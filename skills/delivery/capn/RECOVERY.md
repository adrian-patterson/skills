# Recover interrupted attempts

Use this procedure when a handoff lacks a report and its worker may have stopped,
or when a restart leaves the working state uncertain.

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
4. Refresh the board README's live grants and next action. A retry carries the
   prior report, or the recovery decision when no report exists, and states
   what to resume, what was lost, and what must be verified again. Accept a
   completed unit only through the normal acceptance step.
