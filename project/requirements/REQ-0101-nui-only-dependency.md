---
id: REQ-0101
artifact: requirement
topic: platform
class: non-functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0101

The plugin MUST load and run its commands with nui.nvim as its only other plugin installed.

Recovered at onboarding from README.md, which lists nui.nvim as the one required dependency and every other plugin as optional, and says the picker falls back to nui.menu without snacks.nvim (from README.md, high).

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
