---
id: REQ-0500
artifact: requirement
topic: signs
class: functional
status: approved
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0500

When lines are inserted or deleted above an annotation, its whole range MUST move with the text it was left on, for its sign and for every operation that finds an annotation by position: goto, next, prev, edit, delete, view and resolve.

Recovered at onboarding from README.md, where signs "track position drift as buffers are edited", and from CHANGELOG.md 0.2.1, which fixed goto, next, prev, edit, delete, view and resolve using stale line numbers, and the end line drifting apart from the start (from CHANGELOG.md, high). Resolve still looks up by line before syncing (SPC-0050).

## Open review findings

- The reviewer suggested splitting the sign and the lookups into two requirements. CHANGELOG.md 0.2.1 treats them as one fix, so they stay one obligation here; the person approving can split them.
- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The reviewer asked what happens on edits to the annotated lines themselves. The documents don't say; REQ-0501 covers a snippet that stops matching.
