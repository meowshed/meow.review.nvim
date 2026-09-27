---
id: BUG-0220
artifact: bug
status: draft
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0200 doesn't say whether a killed Neovim counts as a restart

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 22). The steps below have not been run yet.

1. Read REQ-0200.

## What the system does

The requirement says annotations survive a restart without saying whether a crash or kill counts.

## What it should do, and why

The requirement should name the restart, so the check can be written.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
