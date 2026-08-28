# Model-invoked vs user-invoked

Every `SKILL.md` in this repo is a skill. The one axis that splits them is
**invocation**, who can reach it.

## Model-invoked

The default. Reachable by the model **or** the user.

```yaml
---
name: diagnosing-bugs
description: Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose" or "debug this", or reports something broken, throwing, failing, or slow.
---
```

The `description` is **model-facing**. It is the entire trigger mechanism, so it
keeps rich trigger phrasing ("Use when the user wants..., mentions..., asks
for...") in the words a user would really say. A description that reads like a
catalogue entry will not fire.

The test for whether a skill should be model-invoked: **could the model usefully
reach for this on its own, without being told?** Reuse across other skills is a
reason to extract a skill, not a reason to make it model-invoked.

## User-invoked

Reachable **only when the human types its name**.

```yaml
---
name: some-orchestrator
description: One line a human reads in a slash-command list.
disable-model-invocation: true
---
```

The `description` is **human-facing**: a one-line summary for someone browsing a
command list. Strip the trigger phrasing; there is nothing to trigger.

`disable-model-invocation` is understood by harnesses that support it and
ignored by those that do not. It is the only harness-shaped key allowed in
frontmatter, because the alternative is a per-harness sidecar file, which this
repo does not carry. On a harness that ignores it, a user-invoked skill degrades
to model-invoked. Design accordingly: never rely on it for safety, only for
keeping an orchestrator out of the model's way.

## The invariant

A user-invoked skill may invoke model-invoked skills. It can never reach another
user-invoked skill, and nothing but the human can fire one.

## Dependencies between skills

A skill that needs another names it as an explicit instruction to **call the
Skill tool**:

```
Call the Skill tool with "grilling".
```

Not a `../other-skill/FILE.md` cross-reference, and not a bare `/grilling` left
for the model to interpret. Naming the tool is what gets it fired: harnesses
expose skill invocation as a tool the model calls, and spelling that out lands
far more reliably than dropping a slash-command name into prose. Leaving off the
leading `/` also keeps the instruction harness-neutral.

The Skill tool takes one skill per call. A step needing two skills is two calls:
say `Call the Skill tool twice, for "grilling" and "domain-modeling"`, not "call
it with X and Y", which reads as one call taking both.

This convention only holds when the named skill is **model-invoked**. Where a
step depends on a user-invoked skill, phrase it as an instruction for the human
("tell the user to run `/setup`"), never as a Skill tool call.

Shared reference material lives inside the skill that owns it. Another skill
reaches it by calling the Skill tool, not by linking across folders.
