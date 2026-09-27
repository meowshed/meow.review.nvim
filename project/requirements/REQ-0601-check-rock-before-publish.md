---
id: REQ-0601
artifact: requirement
topic: release
class: functional
status: approved
revised: 2026-09-27
elaborates: RES-0010
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0601

A rock MUST be published only after a rock built at the commit the release tag names, from the rockspec that is published or the template it is generated from, has been installed and its installed files checked to include `plugin/meow-review.lua`.

Installing a rock succeeds whether or not its runtime directories were copied, so only a check of its contents catches the defect BUG-0310 records (RES-0010, conclusion 2).

## Open review findings

- The reviewer suggested checking `doc/` as well. Left out: RES-0010's
  conclusion names only the plugin file, and `doc/` installs by default
  today; REQ-0600 still requires it.
