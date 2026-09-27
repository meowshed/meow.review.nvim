---
id: BUG-0240
artifact: bug
status: approved
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Export can't include resolved annotations although the docs say they are left out only by default

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 24). The steps below have not been run yet.

1. Resolve an annotation and look for an option to include it in `:MeowReview export`.

## What the system does

Export calls `store.sorted()` without `include_resolved`, and no entry point takes the option (SPC-0030).

## What it should do, and why

Unclear whether export should offer the opt-in. REQ-0300 states only the exclusion.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
