---
id: BUG-0070
artifact: bug
status: draft
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# doc/meow-review.txt gives the wrong default for `export_filename`

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 7). The steps below have not been run yet.

1. Read `doc/meow-review.txt:180`.
2. Read `default_config.export_filename` in `lua/meow/review/config/internal.lua`.

## What the system does

The help file says `.cache/meow-review/review.md`; README.md and the code use `.review.md`.

## What it should do, and why

The help file should give the default the code uses. No requirement covers documentation accuracy.

## Triage

Enters at requirements, because no requirement covers it; the fix is one line of documentation. Minor.

## Closed by

Not closed.
