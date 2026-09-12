---
name: handoff-prompt
description: Write a self-contained prompt that hands one unit of work to a fresh agent, carrying the sources, authority order, scope boundary, and verification it needs to execute without asking. Use when the user asks for a handoff or a prompt for a subagent, wants to delegate or hand off work to another agent or session, or is about to dispatch an implementation task.
---

# Handoff prompt

A **handoff** is a prompt a fresh agent can execute to completion. It knows nothing about this conversation, so everything it needs is in the prompt or reachable from a path the prompt names.

That agent can read the repository. It cannot read this session. So the handoff carries what no file supplies: the decisions made here, the boundary around the work, which source wins when sources disagree, and what done means. Everything a file does supply, the handoff points at rather than restates. A paraphrased spec is a spec that can be wrong; a path is not.

Writing a handoff changes no code. Read the sources, verify the paths, print the prompt.

## 1. Pin the unit, and what the others are stuck on

One sentence naming what the receiving agent delivers, in the vocabulary of the project. If it does not fit one sentence without an "and", it is more than one handoff: say so, propose the split, and write the first one only.

**A batch is the exception, and only for small independent units of the same kind.** Five bug fixes touching different files, under one workspace with one set of validation commands, are one handoff with a numbered item list rather than five handoffs restating the same preamble. On a small unit the shared part is most of the document, and paying for it five times is what makes small units not worth dispatching at all. Each item keeps its own identifier, its own boundary, and its own report.

What disqualifies a batch is dependency, not size: where item 2 has to read item 1's diff to know what to do, they are sequenced units and go out separately. The distinction from a unit that needed an "and" is that a batch's items are separately deliverable and separately reportable, and an "and" is one deliverable with entangled halves.

Capture the identifier the project already uses for this unit (ticket key, issue number, milestone) so every later section can name it.

Then, in one line, the **end** the project is working toward. Then the part that does the work: **the relevant open units in the active milestone, and what each blocked one is blocked on.** Two or three lines, by identifier.

That list is what makes an agent post. An agent knowing only its own deliverable treats everything else it meets as noise, having nothing to measure it against, and the cost lands on whichever unit later pays full price to rediscover it. An agent that knows U-143 has been stuck on the thing it just worked out will say so. The reciprocity is structural rather than moral: whoever reads this list is on it next week.

Where the project has a board this is a listing, not an investigation. An open handoff with no matching report is a live attempt; a returned attempt may still await verification, integration, or a retry. Use manager acceptance decisions to identify accepted units. Carry the manager's reader allocation; a peer's request for help is not a grant.

The list is also what is most likely to be misread as permission, so the handoff states which way it cuts: **what other units need decides what you report; the boundary decides what you do.** Section 4 is what this agent may act on, and it wins.

## 2. Resolve the sources

Ask the user which sources govern this work if the session has not already established them. For each one, record the access route the receiving agent will use: a URL and the tool that reads it, or a path in the repository. Verify each path exists before it goes in the prompt.

The set that usually matters:

- the specification of the intended behaviour;
- the tracker item defining this unit's boundary;
- the technical or domain design refining it;
- the agent guidance the receiving agent must obey (`AGENTS.md` and `CLAUDE.md` at every level covering the target paths, contributing and testing conventions);
- the code the work builds on, named as exact files, not directories.

Read enough of each to write the rest of this handoff. Where a source cannot be reached, never reconstruct it from memory or from adjacent code: name it in the prompt as unreachable and instruct the receiving agent to fetch it first.

## 3. Fix the authority order

Sources will disagree. Rank them explicitly as a numbered list, most authoritative first, and state what each one governs. Existing code is a source of patterns only; it is not the behaviour contract unless nothing else defines the behaviour.

## 4. Draw the boundary

Two lists, both explicit:

- **This unit owns**: the behaviour, files, and decisions in scope.
- **This unit does not own**: the adjacent work, each named by its own identifier and owner where one exists.

The second list is what stops a capable agent from absorbing the neighbouring work. It is not optional, and vague scoping is the most expensive defect a handoff can carry.

## 5. Set the stopping condition

An agent that cannot finish rarely stops. It reaches further: another approach, a tool it was not given, access it was not granted, a redefinition of the task that makes its current position count as progress. The pattern is well documented, it gets stronger the longer the agent runs, and it is the single most expensive thing a handoff can fail to pre-empt, because by the time it shows up in a report the work is already somewhere the plan did not put it.

Use both an effort budget and behavioural stopping conditions. Write the signals into the prompt: a third distinct approach to the same obstacle, reaching for access or tooling this handoff did not name, or changing *what* is being done rather than *how*. Each of those means the unit is wrong, not that the agent is close.

Say plainly that stopping there is the wanted outcome. A `BLOCKED` report naming the obstacle costs the project one dispatch. A unit delivered by going around the obstacle costs it the next three.

Carry a concrete token, cost, tool-call, or elapsed-time allowance from the dispatcher, or state a proportional allowance when none was supplied. Name how it is tracked, reserve verification and reporting within it, and return remaining work when it is exhausted. Include the manager's helper allocation, defaulting to none; the worker cannot renew its own budget or recruit extra readers.

## 6. Establish verification

Copy the build, lint, typecheck, and test commands out of the repository's own manifests, with the directory each runs from. Never invent a command or assume a conventional one.

State the acceptance criteria and required integration state, such as a merged revision or a reviewed artifact. Then enumerate the cases the work must be tested against, as a numbered list. Enumerating them here is what makes the tests exhaustive rather than representative.

## 7. Size the handoff to the unit

A section earns its place by what the receiving agent would get wrong without it, never by whether you have something to put there. On a large unit that is most of them. On a three-line fix the full set costs more to read than the work costs to do, and the agent pays it before it starts, in a context that will never be reused.

Eight are load-bearing whatever the size: the opening sentence, `Workspace`, `Required reading`, `Requirements`, `Scope boundaries`, `Validation`, `Stopping`, `Report`. They are what stop an agent verifying nothing, absorbing its neighbours, and reaching past the boundary, and none of them is long.

The rest earn their place, and on a small unit usually do not. `Authority order` matters where sources can disagree, and a bug with one repro has one source. `Architecture` matters where new files are being placed. `Baseline to build on` matters where a contract is being reused. `Requirements` at specification detail collapses, on a bug, to the repro and the behaviour expected instead. `Where the others are stuck` collapses on a batch to the other items in it, which the same agent already holds.

Omit the heading along with the section. A heading with a placeholder under it is worse than its absence, because the agent reads it looking for the thing that is not there.

## 8. Write the prompt

```
<One sentence: implement <identifier>: <what>.>

Workspace
- <repo root>
- Target: <package or path>
- <commit, push, and PR policy>

Authoritative context
<each source, with the exact URL or path and how to reach it>

Authority order
1. <source> defines <what>.
2. ...
<what to do when a source is unreachable>

The end
<one line: what the project is working toward>

Project state
<what has merged and what it supplies, what comes next, sibling units by identifier>

Where the others are stuck
<open units by identifier; for each blocked one, what it is blocked on>
Anything you learn that would unblock one of these goes in your report, and on the
board as a note where the project has one. It does not widen this unit: what other
units need decides what you report, the boundary below decides what you do.

Required reading
<exact paths to guidance files, verified to exist>

Baseline to build on
<exact paths to the code and contracts to reuse, and what each supplies>

Architecture
<where the new files go, where their tests mirror to, what to keep separate from what>

Requirements
<the behaviour, at specification detail: states, rules, boundaries, error cases>

Items                        <on a batch only; omit the heading otherwise>
1. <identifier>: <what to deliver, and the files it touches>
2. ...
<each item reported separately, with its own verdict>

Scope boundaries
This unit owns: ...
This unit does not own: ...

Tests
<numbered, exhaustive>

Documentation
<the narrowest docs the guidance files require>

Workflow
<ordered steps, ending in a plan the agent surfaces before editing>

Validation
<exact commands, with their directories; acceptance criteria and required integration state>

Stopping
<effort allowance, tracking method, and verification/reporting reserve>
<authorized helper allocation; none unless granted>
Return PARTIAL or BLOCKED with remaining work when the allowance is exhausted.
Stop and report when you reach a third distinct approach to the same obstacle, when
you need access or tooling this handoff did not name, or when you notice you have
changed what you are doing rather than how. Those mean the unit is wrong, not that
you are close. A BLOCKED report naming the obstacle is a finished outcome, and it is
the wanted one.

Report
When the work is finished, blocked, or abandoned, call the Skill tool with "handoff-report".
<Where this handoff named a board: save the report there, and return three lines and
nothing else: the verdict, the path it was saved to, and the one-sentence summary.
The dispatching session reads the section it needs from the board. Returning the body
as well makes it pay for the whole document a second time, in the one context that
has to survive the project.>
<Where it did not: return the report verbatim.>
<anything this unit must report beyond that skill's own sections>
```

## 9. Deliver

Where the project has a board, call the Skill tool with "project-board" and save the handoff there under the identity it issues. Otherwise print it in one fenced block, the last thing in the reply, ready to paste into a fresh session. Above the block or the path, list in one or two lines anything you could not verify.

When another agent invoked this skill in order to dispatch the work itself, return the handoff verbatim as the prompt for that agent to send, and dispatch nothing yourself.

## Grounding rules

- **Every path in the prompt exists.** A wrong path costs the receiving agent more than an omitted one, because it spends its first minutes proving the handoff wrong.
- **Nothing refers to this conversation.** No "as we discussed", no "the file we just changed", no pronoun whose referent is in this session. The receiving agent has none of it.
- **Point, do not paraphrase.** Restate only what lives in no file: the decisions, the boundary, the authority order.
- **Instruct it to report gaps, not infer them.** Surface missing facts that change behaviour, scope, or acceptance. Permit routine reversible implementation choices consistent with the contract, and report material assumptions.
- **Write it as data, not prose.** Lines under each heading, not paragraphs. The receiving agent is looking for the boundary, the commands, and the paths, and everything sitting between those is context it pays for before it starts.
- **Leave no open question inside the handoff.** Resolve it, or mark it a decision point the receiving agent must surface before it starts editing.
