---
id: REQ-0102
artifact: requirement
topic: platform
class: functional
status: draft
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0102

The plugin MUST leave every key mapping outside its own popup windows to the user.

Recovered at onboarding from README.md: "no default keymaps are set" (from README.md, high). The keys inside the add and edit modals are the plugin's own, as doc/meow-review.txt lists them (from doc/meow-review.txt, high), and so are the view popup's `q` and `<Esc>`, which the help file doesn't list (from lua/meow/review/ui.lua, high). Offering each action as a `<Plug>` mapping is REQ-0105.

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
