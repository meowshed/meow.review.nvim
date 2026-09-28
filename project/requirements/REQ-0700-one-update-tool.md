---
id: REQ-0700
artifact: requirement
topic: updates
class: non-functional
status: draft
revised: 2026-09-28
elaborates: RES-0020
verification: judgement
verifier: person
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0700

Exactly one tool MUST propose dependency version updates for this repository.

Two tools watching the same dependencies would each propose their own pull request for one update, as meowg1k's two configurations would (RES-0020, conclusion 1). A tool can also act from settings outside the repository, such as Renovate's in the Mend portal (RES-0020, Finding 8), so the maintainer checks the configuration files and those settings together. Dependabot security updates are out of scope: they propose only a fix for a vulnerable version, which a version-update proposal may duplicate, and that duplicate is accepted because a security fix shouldn't wait for the schedule.
