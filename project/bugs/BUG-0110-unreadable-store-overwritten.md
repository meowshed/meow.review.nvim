---
id: BUG-0110
artifact: bug
status: approved
severity: critical
violates: REQ-0200
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# A store file that can't be read is overwritten by the next change

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 11). The steps below have not been run yet.

1. Write `{"version": 2, "annotations": []}` or invalid JSON to `.cache/meow-review/annotations.json`, keeping a copy.
2. Start Neovim and add an annotation.

## What the system does

The load warns and starts empty, and the add rewrites the file with the one new annotation, so the old contents are lost with no backup (SPC-0020).

## What it should do, and why

Annotations should survive, as REQ-0200 requires: the plugin should refuse to overwrite a file it couldn't read, or keep a backup.

## Triage

Enters at implement, because it violates REQ-0200. Critical, because a file from a newer version is destroyed.

## Closed by

Not closed.
