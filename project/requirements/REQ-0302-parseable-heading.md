---
id: REQ-0302
artifact: requirement
topic: export
class: functional
status: approved
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0302

The Markdown export MUST head each annotation `[TYPE] file — location — symbol`, so an AI agent can parse it.

Recovered at onboarding from doc/meow-review.txt, which calls the heading "machine-parseable for AI agents" (from doc/meow-review.txt, high). SPC-0030 states the forms the location and the symbol take today.

## Open review findings

- The reviewer asked for the location forms, whether the symbol is optional, and whether ` — ` is reserved. The documents state only the pattern, so fixing the exact grammar here would record a decision nobody took. It stays open as onboarding gap 25.
