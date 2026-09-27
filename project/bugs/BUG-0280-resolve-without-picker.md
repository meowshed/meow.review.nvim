---
id: BUG-0280
artifact: bug
status: draft
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Resolve acts on the first annotation on the line without a picker

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 28). The steps below have not been run yet.

1. Add two annotations on the same line.
2. Run `:MeowReview resolve` on that line.

## What the system does

The first annotation is resolved without asking which (SPC-0040); it also looks the line up before syncing positions (SPC-0050).

## What it should do, and why

Unclear: REQ-0400 asks for a picker from edit, delete and view only.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
