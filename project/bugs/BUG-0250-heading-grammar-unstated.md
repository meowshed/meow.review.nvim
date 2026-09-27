---
id: BUG-0250
artifact: bug
status: approved
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0302 doesn't state the exact heading grammar it promises

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 25). The steps below have not been run yet.

1. Read REQ-0302 and `format_heading` in `lua/meow/review/export.lua`.

## What the system does

The requirement gives `[TYPE] file — location — symbol`, but not the location forms, the optional symbol, or whether ` — ` may appear in a path.

## What it should do, and why

The heading an agent parses should have a stated grammar.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
