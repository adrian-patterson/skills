---
name: figma-reconciler
description: Compare a Figma design against the running UI in the browser and report where they diverge.
disable-model-invocation: true
---

# Figma reconciler

Two sources that are supposed to agree: a Figma node, and the interface actually
rendered in a browser. This skill compares them and reports where they diverge.

A Figma node is a **claim** about what the UI should be. It is not proof. The
design may predate a decision the code already reflects, it may describe one
width of something that has to survive many, and it may specify something an
accessibility fix deliberately overrode. So this skill produces findings for a
human to rule on, and changes nothing.

Everything here is read-only. No edits, no commits, no writes to Figma.

## Prerequisite

This skill runs on the Figma MCP server and a browser the session can drive.
Confirm both before step 1. If the Figma tools are unavailable, tell the user
this skill needs the Figma MCP server connected and stop. Do not fall back to
the Figma REST API, to an exported image, or to reading the design from a
screenshot the user pastes. A comparison whose design half was reconstructed is
worse than no comparison, because it reports differences that are artifacts of
the reconstruction.

## 1. Pin the design

The user supplies a Figma URL, normally from **Copy link to selection**. Take
the file key and the node id out of it. A share URL carries the node as
`node-id=1-234`, with a hyphen; the MCP tools want `1:234`, with a colon.
Converting it is the first thing to get right, because a wrong node id returns
the file's top-level pages rather than an error, and a comparison against the
wrong node looks like a catastrophically broken UI.

Then pull, for that node:

- `get_metadata` for the layer tree: ids, names, types, positions, sizes. This
  is the structure and the geometry.
- `get_variable_defs` for the variables and styles the node uses: colour,
  spacing, typography, radius. This is what the design actually pins.
- `get_screenshot` for a render, to orient yourself and to anchor in step 3.
  It is a reference for your own reading, never evidence in a finding.

`get_design_context` and `get_code_connect_map` are worth pulling where the
project has Code Connect set up, because they resolve a node to the component
that implements it. Most projects do not. Treat their absence as normal and
carry on.

Completion criterion: you can name every layer the node contains, the value of
every variable it binds, and the frame's own width.

## 2. Pin the live UI

Ask the user how to reach the running application. Do not assume a dev server,
a port, or a command. Take whatever they give: a localhost URL, a command to
start it, a deployed preview, a route behind a login.

Ask, in the same breath, **where in that application this design lives**. A
route, a page name, the clicks to get there, whatever they have. The design is
one frame and the application is a whole surface, and nothing in the Figma node
says which part of which page it depicts. The user knows and you do not. Asking
costs one question, and guessing costs the entire run, because every finding
downstream inherits the wrong region.

Open it in the browser and navigate to what they named.

## 3. Anchor the two together

Find the region of the page that corresponds to the node. Read the
accessibility tree rather than looking at pixels: a frame named "Order summary"
is usually a landmark, a heading, or a container with the same text in it.

**Set the viewport to the frame's width** before measuring anything. Geometry
compared at a width the design never described is not a comparison, it is a
list of the ways responsive layout works.

If you cannot anchor confidently, say so and stop. Ask for a CSS selector and
resume from there. Never proceed on a best guess: an unanchored comparison
generates a long, plausible, entirely worthless report, and it costs the user
more to disprove than it would have cost to answer one question.

Completion criterion: one element on the page is the node, and you can name the
selector that reaches it.

## 4. Compare

Three passes, in this order. Each one produces findings the next cannot.

**Structure.** Every layer in the node, present or absent on the page. A layer
with no counterpart is the most valuable finding this skill produces, and it is
the one a visual comparison misses most often, because absence does not look
like anything.

**Tokens.** For each variable the node binds, the computed value on the
corresponding element: colour against `getComputedStyle`, spacing against
padding, margin and gap, typography against font family, size, weight and line
height. Normalise formats before comparing, so `#2563EB` and `rgb(37, 99, 235)`
are one value and not a finding.

**Geometry.** Sizes and positions from `get_metadata` against
`getBoundingClientRect`.

What separates a finding from noise is whether Figma **pinned** it. Compare
what the design specifies, never what its render happens to look like. A colour
bound to a variable is pinned and a difference is a finding. A box whose width
comes from auto-layout is not pinned, and reporting it as a 3px error is how
this skill becomes something nobody runs twice. Differences under a pixel are
never findings, and neither is font rasterisation.

## 5. Report

Findings first, most consequential first: a missing or extra element, then a
token resolving to the wrong value, then geometry. Each one carries:

- **What Figma specifies**: the layer name, its node id, and the value.
- **What the page does**: the measured value, and the selector it was measured
  on. Always the selector. Add the source file where the browser gives it up
  cheaply, as a dev build often does, and leave it out rather than going
  looking, because hunting for it is a different job than this one.
- **Which it is**: a divergence, or something the design left unpinned and the
  implementation chose. Say which. The second kind is worth listing and is not
  a defect.

Then, always, **what was not checked**: the states this frame does not depict
and which sibling frames do, the widths outside the one you measured at,
anything on the page that fell outside the node, and anything you could not
reach. A report that does not bound itself reads as broader than it is, and the
user will act on it as though it were.

Close by saying plainly that these are claims about the design's intent, and
that you changed nothing. What happens next is the user's call: fix them,
document them, or update the design.

## Grounding rules

- **Measure, do not look.** Every finding comes from a computed value or a
  measured rectangle, never from comparing a screenshot to a render by eye.
  Two images differing is not a finding; a value differing is.
- **Never report a difference you did not measure at the frame's width.**
- **Figma is a claim, not the specification**, unless the project has said
  otherwise. Where the code and the design disagree, that is a question for the
  user, not a defect in the code.
- **Say what you could not reach.** A state behind a login, a component that
  needs data you do not have, a node the MCP server would not return: name it
  and move on. Silence reads as a pass.
