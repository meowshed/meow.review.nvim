---
id: SPC-0120
artifact: spec
status: live
revised: 2026-09-28
checked-at:
states: [REQ-0700, REQ-0701, REQ-0702, REQ-0703]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Dependency updates

## Scope

This covers how the repository's dependencies are kept current: which tool
proposes updates, from what configuration, and how actions are pinned. It
doesn't cover security alerts or Dependabot security updates, which are
repository settings outside it (REQ-0700).

## Boundary

- `renovate.json` at the repository root configures Renovate, run by the Mend
  GitHub app installed on `meowshed` (ADR-0020).
- In the Mend portal the repository has Silent mode off and "Require config
  file" on (ADR-0020).
- The repository holds no `.github/dependabot.yml` (ADR-0020).
- Renovate keeps a Dependency Dashboard issue in the repository listing what
  waits (ADR-0020).

## Behaviour

- Renovate is the only tool that proposes dependency version updates
  (REQ-0700), and it is the tool installed across the maintainer's GitHub
  accounts (REQ-0703).
- Every action from another repository in `.github/workflows/` is referenced
  by a full commit SHA with a `# vX.Y.Z` comment, and Renovate keeps both
  current (REQ-0701).
- Renovate runs before 6am on Monday, Europe/Amsterdam time, and proposes
  each new release of an action as a pull request at the first run after it,
  within seven days of the release (REQ-0702).
- Minor and patch updates to actions are grouped into one pull request
  titled "github actions" with commit type `ci`, so there is one to review a
  week, and a major release gets a pull request of its own, because it can
  break the workflow (ADR-0020).
- The only package files Renovate updates here are `ci.yml` and
  `release.yml`; the rockspec's `nui.nvim` dependency is unpinned and no tool
  updates rockspecs (RES-0020).

## Failure paths

- With Silent mode on, Renovate runs and proposes nothing, which only the
  Mend portal shows (ADR-0020).
- With "Require config file" off and no `renovate.json`, Renovate would act
  on its defaults (ADR-0020).
- An update held by Renovate's rate limits or by pending checks waits for
  the next Monday run and can exceed seven days; it shows in the Dependency
  Dashboard's rate-limited or awaiting-schedule list (ADR-0020).
- If the Mend app stops running, no update is proposed; a quiet dashboard
  can't tell that from a week without releases, so the maintainer checks the
  last run time in the Mend portal's job log before a release (ADR-0020).
- An update pull request left unmerged keeps the old pin, and the workflows
  miss that release's fixes until it is merged (ADR-0020).

## Open review findings

- Rejected: the reviewer asked to hold this document back from `live` until
  the epic lands. The record's layout allows only `live` for a
  specification, so it states the decided behaviour and the note below says
  what isn't true yet.


- This document states what ADR-0020 decides, before its epic lands: until
  then the repository still has `.github/dependabot.yml`, no `renovate.json`,
  and three actions pinned by tag.
