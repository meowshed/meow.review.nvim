---
id: REQ-0605
artifact: requirement
topic: release
class: functional
status: approved
revised: 2026-09-27
elaborates: RES-0010
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0605

When any rockspec revision of the version `X.Y.Z` being published already exists on luarocks.org, the publishing workflow run MUST fail and leave the published files unchanged.

Users who installed a version keep the exact files they installed, and a skipped publish isn't mistaken for a successful one (RES-0010, conclusion 6).  A new revision such as `0.2.1-2` counts, because `luarocks install meow.review.nvim 0.2.1` resolves to the newest revision, so it would change the files a user gets for a version they already know.

## Open review findings

- The reviewer suggested splitting "fail" from "leave the files unchanged".
  Kept as one: both share one trigger and one check asserts both.
