---
id: BUG-0210
artifact: bug
status: approved
severity: major
violates: REQ-0103
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# A second `setup()` call doesn't give the state one merged call would

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 21). The steps below have not been run yet.

1. Call `setup({ annotation_types = { A = {} } })`, then `setup({ annotation_types = { B = {} } })`.
2. Call `setup({})`, then `setup({ disabled_exporters = { "file" } })`, and list the exporters.

## What the system does

The types become A and B, where REQ-0104 says the given table replaces the set; lists merge index by index; and `file` stays registered after it is disabled (SPC-0010).

## What it should do, and why

A second call should leave the state one call with both calls' options merged would give, as REQ-0103 requires, with `annotation_types` replacing as REQ-0104 requires.

## Triage

Enters at implement, because it violates REQ-0103. Major.

## Closed by

Not closed.
