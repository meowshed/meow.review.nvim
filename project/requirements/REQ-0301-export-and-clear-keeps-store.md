---
id: REQ-0301
artifact: requirement
topic: export
class: functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0301

`export_and_clear` MUST leave the store unchanged when the export fails.

Recovered at onboarding from doc/meow-review.txt: "If export fails, the store is untouched" (from doc/meow-review.txt, high).

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The reviewer asked what counts as a failed export: a raised error, an unknown exporter or formatter, a cancelled prompt, a write error, or having no annotations. The documents don't say, so it stays open as onboarding gap 9.
