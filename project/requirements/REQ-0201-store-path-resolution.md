---
id: REQ-0201
artifact: requirement
topic: store
class: functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0201

The store MUST resolve a relative `store_path` against the project root and use an absolute one as given.

Recovered at onboarding from the configuration comments in README.md (from README.md, high).

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
