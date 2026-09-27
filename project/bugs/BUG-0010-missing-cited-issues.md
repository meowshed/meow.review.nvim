---
id: BUG-0010
artifact: bug
status: approved
severity: minor
enters: research
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Commits cite issues #1 to #14 that don't exist in this repository

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 1). The steps below have not been run yet.

1. Run `git log --oneline | grep '#'` and note the issue numbers cited.
2. Run `gh issue list --repo retran/meow.review.nvim --state all`.

## What the system does

Commits cite #1 to #14, but the repository has no issues and only PR #1, which is a different change than commit `563b800` cites as #1 (`meow-github history`).

## What it should do, and why

Every issue a commit cites should resolve in the repository's tracker, so the history can be followed. No requirement covers this.

## Triage

Enters at research: where the issues live, for example `retran/meow`, is unknown. Minor, because only the history's traceability suffers.

## Closed by

Not closed.
