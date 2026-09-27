---
id: BUG-0130
artifact: bug
status: draft
severity: minor
enters: research
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The move of the store to `.cache/meow-review/` has no recorded reason

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 13). The steps below have not been run yet.

1. Read CHANGELOG.md 0.2.0 and `meow.review.nvim-0.1.0-1.rockspec`.

## What the system does

0.1.0 stored annotations in `.meow-review.json`, and 0.2.0 moved them to `.cache/meow-review/`; no document says why or what else was considered.

## What it should do, and why

The choice should be recorded as a decision with its rejected alternative. No requirement covers it.

## Triage

Not a defect in behaviour: an unrecorded decision. Enters at research. Minor.

## Closed by

Not closed.
