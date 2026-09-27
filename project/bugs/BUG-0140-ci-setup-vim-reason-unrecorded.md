---
id: BUG-0140
artifact: bug
status: draft
severity: minor
enters: research
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Replacing and restoring `rhysd/action-setup-vim` in CI has no recorded reason

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 14). The steps below have not been run yet.

1. Run `git show --stat 226852f 4211651`.

## What the system does

CI replaced the action with a manual install and then restored it with a token; only the commit subjects say so.

## What it should do, and why

The choice should be recorded as a decision with its rejected alternative. No requirement covers it.

## Triage

Not a defect in behaviour: an unrecorded decision. Enters at research. Minor.

## Closed by

Not closed.
