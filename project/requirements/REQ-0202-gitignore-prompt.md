---
id: REQ-0202
artifact: requirement
topic: store
class: functional
status: approved
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0202

When `auto_gitignore` is `"prompt"`, the plugin MUST ask the user once before it adds the store file to `.gitignore`.

Recovered at onboarding from README.md, whose configuration comment reads `"prompt" (default): ask once` (from README.md, high). Today the plugin asks again after every write, because a dismissal is not remembered (from lua/meow/review/store.lua, high); SPC-0020 records it.

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The reviewer asked what "once" is counted over: per store file, per session or for ever. The documents don't say, so it stays open as onboarding gap 23.
