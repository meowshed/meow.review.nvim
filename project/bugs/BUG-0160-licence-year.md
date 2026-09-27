---
id: BUG-0160
artifact: bug
status: draft
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The licence headers say 2025 while the project began in 2026

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 16). The steps below have not been run yet.

1. Run `grep -rn 'Copyright (c)' lua plugin tests scripts LICENSE`.
2. Run `git log --reverse --format=%ad --date=short | head -1`.

## What the system does

The headers say "Copyright (c) 2025"; the first commit is dated 2026-04-12.

## What it should do, and why

The year should match when the work was first published. No requirement covers it.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
