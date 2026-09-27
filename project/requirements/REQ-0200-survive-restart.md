---
id: REQ-0200
artifact: requirement
topic: store
class: functional
status: approved
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0200

Annotations MUST survive a restart of Neovim.

Recovered at onboarding from README.md: "store survives Neovim restarts" (from README.md, high).

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The reviewer asked whether the restart includes a killed process as well as a clean exit. The documents don't say, so it stays open as onboarding gap 22.
