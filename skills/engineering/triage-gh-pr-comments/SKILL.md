---
name: triage-gh-pr-comments
description: Triage the review comments on the GitHub pull request for the current branch, decide which ones hold, report the verdicts, and fix the approved ones. Use when the user asks to triage, address, answer, or check PR comments, review feedback, requested changes, or bot review findings.
---

# Triage GitHub PR comments

A review comment is a **claim** about the code. Your job is to decide, on evidence, whether each claim holds, and only then to change anything.

Everything before the user's approval is read-only: no edits, no commits, no pushes, no replies, no thread resolutions.

## Prerequisite

This skill runs on the GitHub MCP server. Confirm its tools are available before step 1. If they are not, tell the user this skill needs the GitHub MCP server connected and stop. Do not fall back to `gh`, `git`, or HTTP for GitHub data.

## 1. Pin the PR

Capture the repository root, the `origin` owner and repository, the current branch, local `HEAD`, divergence from upstream, and `git status --short`.

Resolve the PR through GitHub MCP by exact head branch, falling back to exact head SHA. Reject a title-only or merge-commit match. Keep the PR number, URL, title, body, base and head refs and SHAs, and state.

The remote PR head is the source of truth. Surface local divergence and uncommitted work now, since unpushed code cannot prove a remote comment fixed.

Completion criterion: exactly one PR is pinned, and every later step can name it without searching again.

## 2. Fetch what is in scope

In scope, unresolved and issue-bearing only:

- inline review threads that assert a concrete problem or request a change;
- review bodies that do the same.

Out of scope, and not fetched, counted, or reported unless the user asks for them by name: resolved threads, general discussion, praise and acknowledgements, empty review submissions, and bot status output such as previews, coverage, and quality gates. A bot review that names a specific defect in the diff is in scope; its build summary is not.

Paginate to the end. Group replies under their root thread, keep author, body, path, line, thread state, diff hunk, and URL, and give each item an ID that is stable for this run (`T01`, `T02` for threads, `B01` for review bodies). Fetch the PR diff once and keep it.

These IDs are scoped to this run and are reassigned the next time this skill runs on the same PR, so `T03` in one run and `T03` in the next are different comments. They belong in the report and in conversation with the user. Keep them out of anything that outlives the session: commit subjects and bodies, branch names, and replies posted to GitHub.

If nothing survives the scope filter, say so and stop.

Completion criterion: every unresolved thread on the PR has been read and either carries an ID or was excluded for a named reason.

## 3. Decide each claim

For each ID, read the implicated code at the remote head, its direct callers, and its tests. Read the `AGENTS.md`, `CLAUDE.md`, or contributing guidance covering that path. Follow any ticket or issue the PR references only when a claim turns on a requirement you cannot otherwise settle.

Assign exactly one verdict:

- **VALID**: correct and actionable against the current head.
- **PARTLY VALID**: the risk is real, the requested fix or its scope is not.
- **INVALID**: the code, the tests, or documented guidance contradicts the claim.
- **ALREADY ADDRESSED**: a later commit on the PR resolves it.
- **STALE**: the code or premise the comment refers to is gone, and nothing is left to fix.
- **NEEDS DECISION**: validity turns on a product or architecture call that is open.

Every verdict cites the evidence that decides it: a file and line, a test, a guidance rule, or a commit. A verdict with no citation is not finished.

For `VALID` and `PARTLY VALID`, propose the smallest correct fix: the files it touches, the tests that cover it, and its blast radius. Adjacent cleanup you noticed on the way stays out of the proposal.

For `INVALID`, `ALREADY ADDRESSED`, and `STALE`, draft the reply you would post, one or two sentences carrying the evidence.

Completion criterion: every ID from step 2 has a verdict, a citation, and either a proposed fix or a draft reply.

## 4. Report and stop

Report, in this order:

1. **Context**: PR link, base and head, local divergence, and any ticket.
2. **Coverage**: how many in-scope items were evaluated, and any fetch limit that weakens a verdict.
3. **Triage**: one line per ID with author, location, verdict, and the evidence in a clause.
4. **Proposed fixes**: scope, tests, and risk for each `VALID` and `PARTLY VALID`.
5. **Open decisions**: options and a recommendation for each `NEEDS DECISION`.
6. **Draft replies**: for the rejected, stale, and already-addressed items.

Then ask which IDs to fix, revise, or drop, and stop. Wait for the user.

## 5. Fix what was approved

Only for the IDs the user approved.

Work one ID at a time, keeping each fix to the scope proposed in step 3. Run the repository's own tests and checks for the paths you touched. Commit per ID or per coherent group. The subject names the defect that was fixed, not the ID. Where a commit wants a durable referent, put the review thread's URL from step 2 in the body.

Push to the PR head branch. Never force-push, never rebase, and never amend a commit that is already on the remote.

Report what landed: the commits pushed, the checks run and their results, the IDs still open, and any fix you attempted and abandoned, with the reason. Leave posting replies and resolving threads to the user unless they ask you to do it.
