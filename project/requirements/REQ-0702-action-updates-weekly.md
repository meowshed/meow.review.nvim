---
id: REQ-0702
artifact: requirement
topic: updates
class: non-functional
status: approved
revised: 2026-09-28
elaborates: RES-0020
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0702

When a newer release of an action the workflows in `.github/workflows/` use is published, an update to it MUST be proposed as a pull request within seven days.

A pinned action changes only through a proposed update, so without one it keeps missing the action's fixes (RES-0020, conclusion 3). Seven days bounds how long a fix goes unapplied while keeping update pull requests to about one batch a week for the maintainer to review; RES-0020 names "within a week" without measuring it, so the number is a default chosen here.
