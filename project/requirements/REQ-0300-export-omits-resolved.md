---
id: REQ-0300
artifact: requirement
topic: export
class: functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0300

Export MUST leave resolved annotations out.

Recovered at onboarding from README.md, which says resolved annotations are excluded from export by default (from README.md, high). CHANGELOG.md 0.2.0 says the same of `store.sorted()`, which includes them when passed `{ include_resolved = true }` (from CHANGELOG.md, high). Export calls `store.sorted()` without that option, so no export entry point includes them (from lua/meow/review/export.lua, high).

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The store offers an opt-in and export doesn't pass it through. Whether export should stays open as onboarding gap 24.
