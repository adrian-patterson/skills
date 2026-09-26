# Recover attempts and bound authorized parallel work

Conjure usage exposed stale grants after workers stopped, work lost from OS
temporary directories, repeated effort overruns, and owner-requested parallel
writers. Keep one writer as the default, while representing these cases without
pretending a missing report proves completion or an estimate is a hard cap.

This supersedes ADR 0005's unconditional single-writer invariant and uniform
budget-exhaustion stop. Parallel writers require explicit user authorization
and a manager decision fixing boundaries, shared-file ownership, isolation,
integration order, and the limit's expiry. Shared-checkout mutations remain
serialized. Planning estimates trigger reassessment; hard limits stop affected
work and can only be extended by their authorizing source.

A manager recovery decision may close an interrupted attempt when the worker
cannot report, after establishing termination and preserving surviving work.
Acceptance still requires verification and the specified integration state.
Retries carry that decision in place of a missing report. Verification names
the tested revision and later changes so acceptance can reuse applicable checks.
Active work survives reboots; the board remains untracked working memory. These
changes use the existing four post types and add no runtime dependency.
