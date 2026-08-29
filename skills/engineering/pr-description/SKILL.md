---
name: pr-description
description: Write the pull request description for the current branch as markdown for the user to paste into GitHub. Use when the user asks for a PR description or PR body, or wants a branch written up before opening a pull request.
---

# PR description

Print a markdown PR description for the current branch. Make no GitHub writes, no commits, and no edits to tracked files.

The diff is the source of truth for **what** changed, and the reviewer can already read it. The description earns its place by carrying **why**: the problem, the approach, and what no diff reveals. Length tracks the change, and most changes are small.

## 1. Gather evidence

Establish the base as the merge-base between the current branch and the repository's default branch. Read the commit subjects and bodies on the branch, and the diff against that base.

Collect, where each exists:

- an issue or ticket reference in the branch name, the commit messages, or a PR already open on the branch;
- a template at `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, or under `.github/PULL_REQUEST_TEMPLATE/`;
- contributing guidance covering what a PR description must contain.

Completion criterion: every commit on the branch is accounted for in your understanding of the change, and you know whether a template governs the output.

## 2. Choose the shape

A repository template wins. Keep its headings and order, fill its sections with real content, strip its instructional comments, and tick a checkbox only where the diff supports it. Leave a section empty rather than padding it, and say in the section why it is empty.

With no template, open with these two:

- **Title**: one imperative sentence naming the change specifically. "Delete the FizzBuzz RPC and replace it with the new system", not "Fix bug", "Refactor", "Update code", or "Phase 1".
- **Opening paragraph**: the problem the change solves and the approach taken, in two or three sentences.

Then add a part only where the evidence calls for it:

- **Bullets** for separable pieces of the change a reader would otherwise have to derive from the diff.
- **Where to look first**, naming the files carrying the real decision, when the diff is large or spread across areas.
- **Tradeoffs**, when the change rejects a plausible alternative or carries a known shortcoming.
- **Links** to the ticket, issue, or anything a future reader needs that lives outside the repository.

A title and one paragraph is a complete description of a small change.

## 3. Ground every sentence

Every claim traces to the diff, the commits, the ticket, or the repository's own docs.

- Say what the change accomplishes, at the altitude of behaviour and intent. The file-by-file walk is the diff's job.
- Treat tests added in the diff as fact. Leave manual verification to the user to add.
- Where the reason for the change is not recoverable from the evidence, name that gap rather than inventing a motive.

## 4. Print it

Output the description in one fenced markdown block, ready to paste. Print the title on its own line above the block. The block is the last thing in the reply.

Where step 3 found a gap, ask the one question that closes it after the block.
