---
id: vision
artifact: vision
status: live
revised: 2026-09-27
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# meow.review.nvim

## What it is

meow.review.nvim is a Neovim plugin for reviewing code, AI-generated code in
particular: you leave typed, persistent review comments on lines in the
editor and export them as structured Markdown, so an AI agent knows what to
fix and where (from README.md, high). It belongs to the project meow plugin
family (from README.md, high).

What it replaces or competes with: not yet stated (onboarding gap 2).

## The problem

A reviewer who notices something wrong in AI-generated code keeps it as a
mental note and loses track of it (from README.md, high). The notes need to
survive editor restarts, follow the code as it is edited, and reach the agent
in a form it can act on (from README.md, medium).

## Who it is for

| Audience | Wants | What they do today instead |
| -------- | ----- | -------------------------- |
| A Neovim user reviewing code an AI agent wrote (from README.md, high) | To hand the agent every review comment with its file, line and code, in one message (from README.md, high) | Not yet stated (onboarding gap 3) |

## Quality goals

Not yet stated (onboarding gap 4).

## What it will not do

Not yet stated (onboarding gap 5). The two limits the documents do state, no
key mappings of its own and no plugin besides nui.nvim (from README.md,
high), are draft requirements REQ-0102 and REQ-0101, whose reasons are
onboarding gap 19.

## Risks

No document states a risk. One is live now: `export_and_clear` can clear the
store when an export writes nothing, losing every annotation (from
lua/meow/review/export.lua, high; onboarding gap 9). The other defect
candidates are onboarding gaps 7 to 12, 16, 17, 20 and 27.

## Where it is going

Not yet stated (onboarding gap 30). Release 0.2.0 added exporters for AI
tools (avante.nvim, codecompanion.nvim), a resolved state and stale
detection (from CHANGELOG.md, high), which suggests a review loop with an
agent (low: inferred from the changelog).
