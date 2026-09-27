---
id: BUG-0170
artifact: bug
status: approved
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The 0.1.0 rockspec names a tag that doesn't exist

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 17). The steps below have not been run yet.

1. Read `source.tag` in `meow.review.nvim-0.1.0-1.rockspec`.
2. Run `git ls-remote --tags origin`.

## What the system does

The rockspec names `v0.1.0`; the remote has only `v0.2.0` and `v0.2.1`, so `luarocks` can't fetch 0.1.0 from git.

## What it should do, and why

Every rockspec's `source.tag` should resolve. No requirement covers it.

## Triage

Enters at requirements. Minor, because 0.1.0 is superseded.

## Closed by

Not closed.
