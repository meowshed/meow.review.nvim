---
id: ADR-0020
artifact: adr
status: draft
revised: 2026-09-28
addresses: [REQ-0700, REQ-0701, REQ-0702, REQ-0703]
supersedes: []
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# 0020. Renovate proposes every dependency update, from a `renovate.json` in the repository, and Dependabot's version updates are removed

## Decision

Renovate, through the Mend GitHub app installed on `meowshed`, proposes all
dependency version updates for this repository (REQ-0700, REQ-0703). Its
configuration lives in `renovate.json` at the repository root:

- `config:recommended` and `group:recommended`, with timezone
  `Europe/Amsterdam`, schedule "before 6am on Monday", `prCreation:
  not-pending`, `rebaseWhen: conflicted` and the label `dependencies`, the
  settings meowg1k already uses;
- one package rule for the `github-actions` manager: `pinDigests: true`,
  grouped as "github actions", with semantic commit type `ci`.

`.github/dependabot.yml` is deleted, so Dependabot proposes no version
updates (REQ-0700). In the Mend portal the repository has Silent mode off
and "Require config file" on, so Renovate acts only from `renovate.json`.

With `pinDigests`, Renovate's first run proposes pinning `actions/checkout`,
`actions/cache` and `JohnnyMorganz/stylua-action` to commit SHAs with a
`# vX.Y.Z` comment, the form `release.yml` already uses for
`luarocks-tag-release` (REQ-0701), and afterwards proposes each new release
as a digest update on the Monday after it (REQ-0702).

This replaces one provision of ADR-0010, which says "The maintainer moves
the pin, prompted by a Dependabot pull request for the `github-actions`
ecosystem, which this decision adds in `.github/dependabot.yml`"
(ADR-0010, What it costs). Renovate's pull request now prompts the move, and
the file ADR-0010 added is removed. The rest of ADR-0010 stands, so this
decision supersedes nothing.

Once this is accepted and implemented, Renovate proposes all version updates
and every action runs at a pinned commit. What still doesn't hold: the
shared preset for all the maintainer's repositories (RES-0020, Finding 5)
doesn't exist yet, so this repository carries its own copy of the settings.

## Why

- For this repository alone the two tools tie: both update its GitHub
  Actions and neither its rockspec (RES-0020, Findings 1 to 3). REQ-0703
  breaks the tie, because Renovate is the tool installed across the
  maintainer's accounts (RES-0020, Finding 6).
- `pinDigests` both pins every action to a commit and keeps the `# vX.Y.Z`
  comment current, which meets REQ-0701 and REQ-0702 with one rule (RES-0020,
  Finding 4).
- A weekly schedule proposes a release at most seven days after it, the bound
  REQ-0702 sets, and batches the week's updates into one grouped pull
  request.
- Deleting `dependabot.yml` is what makes Renovate the only version-update
  tool; keeping both would propose every update twice (RES-0020, Finding 7).

## Alternatives

| Option | Better at | Why it lost |
| ------ | --------- | ----------- |
| Do nothing: keep Dependabot's version updates | Built into GitHub, no third-party app, already working here (RES-0020, Finding 2) | Breaks REQ-0703; and Renovate's onboarding pull request #10 is already open, so doing nothing means closing it and leaving the repository unlike the maintainer's others |
| Renovate extending a shared preset repository | One set of settings for every repository, which is the maintainer's larger aim (RES-0020, Finding 5) | No preset repository exists yet, and creating one is a decision across repositories this record can't make; it lost on timing, and this repository can switch to `extends` once the preset exists |
| Renovate and Dependabot both | Nothing either does alone | Breaks REQ-0700: every update proposed twice (RES-0020, Finding 7) |

## What it costs

- A third-party app, Mend's Renovate, holds write access to code, pull
  requests and workflows in this repository (the app's permission page). The
  maintainer pays this once, and already pays it for meowg1k.
- Part of the configuration, Silent mode and "Require config file", lives in
  the Mend portal, outside the repository, where no check can see it; the
  maintainer checks it by hand when verifying REQ-0700.
- The maintainer reviews the week's grouped update pull request when
  something was released, a separate one for a major release, and a
  digest-pinning pull request once. If nobody attends to them for a month,
  the pins fall behind and the workflows miss the fixes in those releases;
  REQ-0702 still holds, because it asks only that an update be proposed.
  Renovate's Dependency Dashboard issue lists what waits, and the maintainer
  looks at it before each release.

## What would reverse it

- The maintainer stops using Renovate across their accounts, which removes
  the reason REQ-0703 gives.
- Mend withdraws the free Renovate app, or Renovate stops updating GitHub
  Actions digests.

## Consequences

- New file: `renovate.json`. Removed file: `.github/dependabot.yml`.
- SPC-0110's line naming Dependabot as the tool that moves the pin changes to
  Renovate, citing this decision.
- Renovate's onboarding pull request #10 carries the commit "Add
  renovate.json", which fails the commit convention, so it lands
  squash-merged with a conforming subject. Renovate's later commits use the
  `ci(deps)` and `chore(deps)` forms `.meowpaw/profile.toml` allows.

## How I will know it was realised

1. The repository has `renovate.json` with the settings above and no
   `.github/dependabot.yml`.
2. `grep -rn 'uses:' .github/workflows/` shows every action from another
   repository at a 40-character SHA with a `# vX.Y.Z` comment.
3. Renovate's Dependency Dashboard issue exists in the repository, and no
   update released more than seven days earlier is still waiting for a pull
   request, that is, none sits in its awaiting-schedule or rate-limited
   lists.
4. The maintainer confirms Silent mode is off and "Require config file" is on
   in the Mend portal, and that Renovate is the tool across their accounts.

## What this does not settle

- A shared Renovate preset for the maintainer's repositories.
- Renovate's configuration for the maintainer's other repositories, including
  mise and pre-commit.
- Whether Dependabot security updates stay on; REQ-0700 leaves them out of
  scope.
- The moved or deleted tag's cost in ADR-0010; this decision changes only
  what proposes moving the pin.

## The strongest objection

For this repository alone the switch buys nothing: Dependabot already
updated the actions, and can update SHA-pinned actions too. The objection
holds, and the record says so (RES-0020); the decision is made for
consistency across the maintainer's repositories, which REQ-0703 records as
their instruction, not because this repository needs Renovate.

## Premortem

It is three months later and the pins are stale. Someone turned "Require
config file" off in the org defaults, Renovate onboarded a dozen repositories
with `config:recommended`, and the flood of pull requests got the Mend app
suspended; this repository's weekly updates stopped with it, and nothing in
the repository showed it. The guard is the Dependency Dashboard issue: an
issue that stops updating is visible, and verifying REQ-0702 looks at it.

## Open review findings

- Rejected: the reviewer read SPC-0110 as naming no Dependabot line. It does,
  at `project/specs/SPC-0110-release-and-publishing.md:36`, so the
  consequence stays.
- The reviewer noted `prCreation`, `rebaseWhen` and the timezone rest only on
  meowg1k using them. Kept: matching meowg1k is the point of REQ-0703, and
  none of them changes what REQ-0700 to REQ-0702 require.
