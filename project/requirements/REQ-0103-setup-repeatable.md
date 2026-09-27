---
id: REQ-0103
artifact: requirement
topic: platform
class: functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0103

Calling `setup()` a second time MUST leave the plugin in the state one call with both calls' options merged would give.

Recovered at onboarding from doc/meow-review.txt, which calls `setup()` "Idempotent — safe to call multiple times" and says each call merges `{opts}` into `vim.g.meow_review` (from doc/meow-review.txt, high).

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The reviewer found that a deep merge of two calls' `annotation_types` unions the two tables, while REQ-0104 says a given table replaces the set. The documents don't say which wins on a repeat call, so it stays open as onboarding gap 21.
- The reviewer found a second divergence: a repeat call that adds a name to `disabled_exporters` leaves that exporter registered, and the deep merge combines lists index by index. Asked with gap 21.
