---
id: BUG-0260
artifact: bug
status: approved
severity: major
violates: REQ-0501
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# `validate()` checks less than the help file promises

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 26). The steps below have not been run yet.

1. Annotate a three-line range, then change its second line and write the buffer.
2. Run `:MeowReview validate`.

## What the system does

Only the first snippet line is compared, an empty first line skips the check, and `validate()` and the sign column disagree on hunk annotations (SPC-0050).

## What it should do, and why

An annotation should be stale when its snippet no longer matches the file, as doc/meow-review.txt and REQ-0501 say.

## Triage

Enters at implement, because it violates REQ-0501. Major, because changed code goes unflagged.

## Closed by

Not closed.
