---
id: BUG-0060
artifact: bug
status: approved
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The permitted dependencies between modules are unstated, and the store and signs call each other

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 6). The steps below have not been run yet.

1. Run `grep -n 'require("meow.review' lua/meow/review/*.lua`.

## What the system does

`store.lua` requires `signs.lua` and `signs.lua` requires `store.lua`; nothing states which calls between modules are allowed (SPC-0010).

## What it should do, and why

The record should state the permitted dependencies, so a new call across a forbidden boundary is a finding. No requirement covers this.

## Triage

Enters at requirements, because no requirement states the module boundaries. Minor.

## Closed by

Not closed.
