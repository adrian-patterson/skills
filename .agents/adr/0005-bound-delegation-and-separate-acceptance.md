# Bound delegation and separate acceptance

The manager workflow produced promising results but spent heavily on delegation
and left the user tracking too much concurrent work. Protecting manager context
alone does not minimize total cost or human attention. Keep the board and
explicit handoffs, but manage one active milestone, permit cheap direct checks,
and make lookahead investigation optional.

This supersedes ADR 0003's unlimited and self-issued read grants: the manager
allocates readers, defaulting to one across the project, with a named reason and
expiry for increases. Nested helpers count toward that limit. Each dispatch has
an effort budget and stopping condition. The single-writer invariant remains.

A report closes an attempt and expires its grant. Acceptance is a separate
manager decision requiring verification and the integration state the handoff
specified. Existing decision posts carry acceptance; no fifth post type or
runtime dependency is introduced. Compare total cost and human interventions
through acceptance when deciding whether delegation earned its expense.
