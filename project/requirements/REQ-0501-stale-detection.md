---
id: REQ-0501
artifact: requirement
topic: signs
class: functional
status: approved
revised: 2026-09-27
elaborates: []
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0501

`validate()` MUST mark an annotation stale when its file is gone, its line is past the end of the file, or its snippet no longer matches the file.

Recovered at onboarding from doc/meow-review.txt, which states it for `validate()` and says stale annotations are highlighted with `MeowReviewStale` and counted in its return value (from doc/meow-review.txt, high). The code compares only the first line of the snippet and skips the check when either line is empty (from lua/meow/review/validate.lua, high); SPC-0050 records both.

## Open review findings

- The reviewer asked for the obligation's reason. No document states one, and writing one here would record a reason nobody gave, so it stays open as a question in the onboarding report (gap 19).
- The reviewer asked what "matches" means. The document says the snippet; the code compares its first line with whitespace trimmed. Which one is intended stays open as onboarding gap 26.
- The reviewer asked for the negative case, that an annotation meeting none of the conditions is not marked stale. The document doesn't state it, so it stays open with gap 26, which now asks it.
- The snippet is compared at `snippet_start`, which doesn't move with edits, so an unchanged annotation can be marked stale after lines are added above it; asked as onboarding gap 20.
- `validate()` doesn't exempt hunk annotations while sign drawing does; asked with gap 26.
