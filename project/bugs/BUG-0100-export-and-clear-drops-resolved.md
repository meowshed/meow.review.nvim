---
id: BUG-0100
artifact: bug
status: approved
severity: major
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# `export_and_clear` clears resolved annotations that the export left out

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 10). The steps below have not been run yet.

1. Add two annotations and resolve one with `:MeowReview resolve`.
2. Run `:MeowReview export_and_clear clipboard`.

## What the system does

The export holds one annotation, and the store is cleared of both (from lua/meow/review/init.lua and lua/meow/review/store.lua).

## What it should do, and why

Unclear: either only exported annotations are cleared, or resolved ones are meant to go too. No requirement covers it.

## Triage

Enters at requirements, because no requirement says which annotations `export_and_clear` removes. Major, because resolved annotations are lost silently.

## Closed by

Not closed.
