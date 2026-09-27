---
id: BUG-0180
artifact: bug
status: draft
severity: minor
enters: research
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# `paw index` writes every kind into the one index block of `project/README.md`

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 18). The steps below have not been run yet.

1. Run `paw index specification --write`, then `paw index defect --write`.
2. Run `paw check`.

## What the system does

Specifications, epics and defects share `project/README.md` as their index, the file can hold only one block that `paw` writes, and `check index` always reports the other kinds as out of date.

## What it should do, and why

Each kind should have an index `check` accepts. This belongs to the meow-flow `paw` tool, not to meow.review.nvim.

## Triage

A defect in the harness, recorded here at the maintainer's request; it should be filed against meow-flow. Enters at research. Minor.

## Closed by

Not closed.
