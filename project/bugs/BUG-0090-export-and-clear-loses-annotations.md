---
id: BUG-0090
artifact: bug
status: approved
severity: critical
violates: REQ-0301
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# `export_and_clear` clears the store when the export wrote nothing

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 9). The steps below have not been run yet.

1. Add an annotation with `:MeowReview add`.
2. Run `:lua require('meow.review').export_and_clear('file_prompt')`.
3. Cancel the filename prompt with `<Esc>`.
4. Run `:MeowReview goto`.

## What the system does

The store is cleared as soon as the prompt opens, so after the cancel every annotation is gone. The same happens when `file` or `file_prompt` can't open its path and when the `json` formatter can't encode, because each reports the error and returns normally (SPC-0030).

## What it should do, and why

The store should stay unchanged when the export writes nothing, as REQ-0301 requires. Whether a cancel counts as a failure is asked in REQ-0301's open findings.

## Triage

Enters at implement, because it violates REQ-0301. Critical, because it destroys every annotation with no way back.

## Closed by

Not closed.
