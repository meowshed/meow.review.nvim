---
id: BUG-0270
artifact: bug
status: approved
severity: major
violates: REQ-0200
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# A failed store write leaves the file empty or partial and reports nothing

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 27). The steps below have not been run yet.

1. Make the disk full, or kill Neovim while it writes the store.
2. Start Neovim again.

## What the system does

The file is opened with `w`, which truncates it, and the result of `write` isn't checked, so a failed write leaves it empty or partial with no error (SPC-0020).

## What it should do, and why

Annotations should survive, as REQ-0200 requires: the write should go to a temporary file and be renamed into place, or report failure.

## Triage

Enters at implement, because it violates REQ-0200. Major; it can't be reproduced on demand, because it needs a write to fail.

## Closed by

Closed by TSK-0110 at commit `380e32e`: saves write a temporary file and rename it over the store only after the write succeeds. The reproduction lives as the regression test "keeps the old file when a write fails partway (BUG-0270)" in `tests/spec/store_spec.lua`, seen failing before the fix and passing after it.

## Tasks

- [x] T-001 TSK-0110 Write the store atomically so a failed save keeps the old file
