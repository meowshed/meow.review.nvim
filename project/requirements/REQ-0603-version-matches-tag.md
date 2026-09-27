---
id: REQ-0603
artifact: requirement
topic: release
class: functional
status: draft
revised: 2026-09-27
elaborates: RES-0010
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0603

The version part of the rock published to luarocks.org for a tag `vX.Y.Z` MUST be `X.Y.Z`.

A user can then find the release notes and the source for the version they installed (RES-0010, conclusion 4).  Which rockspec revision is published is left to the design step.
