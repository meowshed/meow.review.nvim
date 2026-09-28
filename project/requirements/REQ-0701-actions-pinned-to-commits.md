---
id: REQ-0701
artifact: requirement
topic: updates
class: non-functional
status: approved
revised: 2026-09-28
elaborates: RES-0020
verification: static
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0701

Every action from another repository that the workflows in `.github/workflows/` use MUST be referenced by a full commit SHA, with its version in a `# vX.Y.Z` comment beside it.

A tag can be moved and a commit can't, so a pinned action runs only the code a reviewed change chose (RES-0020, conclusion 2). The `# vX.Y.Z` comment is the form the update tool reads and rewrites, and it tells a reviewer which release the SHA is (RES-0020, Finding 4). ADR-0010 already pins `luarocks-tag-release` this way; this extends it to every action.

## Open review findings

- The reviewer noted a static check can confirm the comment is there but not
  that its version resolves to the SHA. Left out: the update tool writes both
  together, and checking the match would need a network lookup.
