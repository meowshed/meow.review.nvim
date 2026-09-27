---
id: BUG-0080
artifact: bug
status: draft
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Documentation and comments still name the old store file `.meow-review.json`

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 8). The steps below have not been run yet.

1. Run `grep -rn 'meow-review.json' doc lua plugin`.

## What the system does

`doc/meow-review.txt:54`, `doc/meow-review.txt:713`, `lua/meow/review/init.lua:458` and `plugin/meow-review.lua:329` name `.meow-review.json`, while the default store has been `.cache/meow-review/annotations.json` since 0.2.0 (CHANGELOG.md).

## What it should do, and why

Every mention should name the configured `store_path`. No requirement covers documentation accuracy.

## Triage

Enters at requirements. Minor, because the store itself works.

## Closed by

Not closed.
