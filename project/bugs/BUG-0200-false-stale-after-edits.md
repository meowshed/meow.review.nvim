---
id: BUG-0200
artifact: bug
status: approved
severity: major
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Lines added above an annotation can mark it stale although its text is unchanged

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 20). The steps below have not been run yet.

1. Annotate a line with a snippet.
2. Insert three lines above it and write the buffer.
3. Run `:MeowReview validate`, or leave and re-enter the buffer.

## What the system does

The snippet is compared at `snippet_start`, which doesn't move with edits while `lnum` does, so the unchanged line is reported stale (SPC-0050).

## What it should do, and why

An annotation whose text is unchanged should not be stale. REQ-0501 states only when to mark stale, not when not to.

## Triage

Enters at requirements, because no requirement states the negative case. Major, because every edit above an annotation produces a false warning.

## Closed by

Not closed.
