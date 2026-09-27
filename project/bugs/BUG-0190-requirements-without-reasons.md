---
id: BUG-0190
artifact: bug
status: draft
severity: minor
enters: requirements
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# No requirement states its reason

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 19). The steps below have not been run yet.

1. Read the `## Open review findings` of each record in `project/requirements/`.

## What the system does

REQ-0100 to REQ-0501 state obligations with no reason, because no document gives one.

## What it should do, and why

Each requirement should say why it holds, so a case nobody foresaw can be decided.

## Triage

Enters at requirements. Minor.

## Closed by

Not closed.
