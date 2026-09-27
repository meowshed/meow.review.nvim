---
id: BUG-0120
artifact: bug
status: approved
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The plugin's own review store is committed to the repository

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 12). The steps below have not been run yet.

1. Run `git ls-files .cache`.

## What the system does

`.cache/meow-review/annotations.json` is tracked, committed in `2d724d1`, while `auto_gitignore` exists to keep the store out of git.

## What it should do, and why

Unclear whether the file belongs in the repository. No requirement covers it.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
