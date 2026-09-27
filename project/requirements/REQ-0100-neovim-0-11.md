---
id: REQ-0100
artifact: requirement
topic: platform
class: non-functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0100

The plugin MUST run on Neovim 0.11.0 or later.

Recovered at onboarding from README.md and doc/meow-review.txt, which state Neovim 0.11.0 as the minimum (from README.md, high). The plugin also refuses to load on an older version (from plugin/meow-review.lua, high); this requirement doesn't ask for that refusal.

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
