---
id: REQ-0104
artifact: requirement
topic: platform
class: functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0104

When the user gives a non-empty `annotation_types`, its keys MUST be the only active annotation types.

Recovered at onboarding from README.md: providing `annotation_types` "replaces the entire set" (from README.md, high). doc/meow-review.txt states the keys: "When provided but missing a built-in key (e.g. \"ISSUE\"), that key is dropped — only the supplied keys are active", and when it is nil or empty, the three built-in types are active (from doc/meow-review.txt, high). A user entry's missing fields are filled from the built-in entry with the same key (from lua/meow/review/types.lua, high).

## Open review findings

- A second `setup()` call merges `annotation_types` with the first call's table, against this obligation; asked as onboarding gap 21.
- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
