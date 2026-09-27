---
id: REQ-0600
artifact: requirement
topic: release
class: functional
status: draft
revised: 2026-09-27
elaborates: RES-0010
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0600

Every rock built for release MUST install `plugin/` and `doc/` along with the Lua modules.

A rock without `plugin/` gives a rocks.nvim user no `:MeowReview` command and no `<Plug>` mapping, and one without `doc/` gives no `:help meow-review` (RES-0010, conclusion 1).
