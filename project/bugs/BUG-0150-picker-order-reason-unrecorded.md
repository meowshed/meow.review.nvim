---
id: BUG-0150
artifact: bug
status: draft
severity: minor
enters: research
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The picker fallback order has no recorded reason

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 15). The steps below have not been run yet.

1. Read `M.open_picker` in `lua/meow/review/ui.lua`.

## What the system does

The picker tries snacks.nvim, telescope.nvim, fzf-lua, then nui.menu; no document says why in that order.

## What it should do, and why

The order should be recorded as a decision with what it rejected. No requirement covers it.

## Triage

Not a defect in behaviour: an unrecorded decision. Enters at research. Minor.

## Closed by

Not closed.
