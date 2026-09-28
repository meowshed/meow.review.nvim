---
id: RES-0020
artifact: research
status: approved
revised: 2026-09-28
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# For this repository Dependabot and Renovate both cover what needs updating; Renovate is the one that also covers the maintainer's other repositories

## Summary

The only dependencies either tool can update here are the GitHub Actions in
`ci.yml` and `release.yml`; both Dependabot and Renovate update them, and
neither updates rockspec dependencies. So the choice for this repository
alone is a tie, and what breaks it is the maintainer's request to use one
tool across all their projects: across the 23 GitHub repositories in
`~/workspace`, 10 pin tools with mise, which Dependabot can't update and
Renovate can. Running both tools at once proposes every update twice. This
covers version updates for this repository; it doesn't cover security
alerts, which GitHub runs separately from either tool's version updates.

## The question

Which tool should propose dependency updates for meow.review.nvim, and what
must hold whichever it is?

The assumption behind the question is that this repository needs a tool
chosen on its own merits. It doesn't: its only updatable dependencies are
GitHub Actions (Finding 1), which both tools cover (Findings 2, 3), so its
merits don't separate them. The question the maintainer asked is broader,
one tool for all their projects (Finding 6), and this document answers it
for this repository in that light.

## Method

- Read `.github/workflows/ci.yml`, `.github/workflows/release.yml`,
  `.github/dependabot.yml` and `meow.review.nvim-scm-1.rockspec` at commit
  `70a73cd`, and the Renovate onboarding pull request #10.
- Read GitHub's page of Dependabot's supported ecosystems and Renovate's
  manager list, its pre-commit manager page and its config presets page.
- Scanned `~/workspace` for git repositories, their GitHub remotes and the
  package files they hold, detecting mise from `mise.toml` or `.mise.toml`
  only.
- Read `renovate.json` in `meowshed/meowg1k` and its pull requests and issues
  from Renovate and Dependabot.
- Read the Mend developer portal's settings for this repository, from the
  maintainer's screenshots.
- Not obtained: which Renovate version the Mend app runs for other
  repositories, and whether meowg1k's duplicate proposals were ever measured.

## Findings

### 1. This repository's updatable dependencies are its GitHub Actions

Renovate's onboarding pull request #10 detected `.github/workflows/ci.yml`
and `.github/workflows/release.yml` as `github-actions` package files and
nothing else (read 2026-09-28). The rockspec's one dependency, `nui.nvim`,
is unpinned (`meow.review.nvim-scm-1.rockspec`, read 2026-09-28).

### 2. Dependabot updates GitHub Actions, pre-commit, Cargo, npm, pip and Docker, and not mise or LuaRocks

GitHub's page of supported ecosystems lists no mise and no LuaRocks, and
lists Nix without version updates (docs.github.com, read 2026-09-28).
Dependabot opened pull requests #6, #7 and #8 here for three action majors
on its first run (read 2026-09-28).

### 3. Renovate updates GitHub Actions, mise, Cargo, npm, pip, Docker and Nix, and pre-commit as an opt-in beta, and not LuaRocks

Renovate's manager list has `github-actions`, `mise`, `cargo`, `npm`,
`dockerfile`, `pep621`, `pip_requirements` and `nix`, and no rockspec
manager; its pre-commit page says "The `pre-commit` manager is disabled by
default and must be opted into through config" (docs.renovatebot.com, read
2026-09-28).

### 4. Renovate can pin actions to commit digests

meowg1k's `renovate.json` sets `pinDigests: true` for the `github-actions`
manager (read 2026-09-28), which replaces a tag with its commit and keeps
the tag as a comment, the form `release.yml` already uses for
`luarocks-tag-release` (ADR-0010).

### 5. One Renovate config can be shared across repositories

A repository's config can extend a preset held in another repository with
`"extends": ["github>owner/repo"]`; the Mend app doesn't pick up an
organisation's preset without that line (docs.renovatebot.com, config
presets, read 2026-09-28). Dependabot has no shared config: each repository
holds its own `dependabot.yml`.

### 6. The maintainer uses Renovate across their accounts and asked for one tool for all projects

Renovate is installed on both `meowshed` and `retran`, and active in
meowg1k, which has an open Dependency Dashboard issue #71 and Renovate pull
requests (read 2026-09-28). The maintainer asked on 2026-09-28 to choose one
tool for all their projects. Of the 23 GitHub repositories in
`~/workspace`, 17 use GitHub Actions, 10 pin tools with mise, 5 use
pre-commit, 3 Cargo, 2 npm, and 1 each Docker and Python (scan, run
2026-09-28).

### 7. Running both tools proposes the same update twice

meowg1k has both a `renovate.json` and a `.github/dependabot.yml` (read
2026-09-28), so both tools watch the same GitHub Actions and each proposes
its own pull request for one update.

### 8. Renovate on the Mend app can run without opening anything

This repository ran in Silent mode, where Renovate completed jobs and opened
no pull request or issue, until the maintainer turned the mode off; with
"Require config file" on, it acts only once a config exists (Mend developer
portal, screenshots, 2026-09-28).

## Options

| Option | Better at | Case against |
| ------ | --------- | ------------ |
| Renovate, replacing Dependabot's version updates | The same tool and config as the maintainer's other repositories (Findings 5, 6); covers mise elsewhere (Finding 3); pins action digests (Finding 4) | A third-party app with write access to the repository; noisier by default without grouping and a schedule; for this repository alone it adds nothing Dependabot lacks (Finding 1) |
| Dependabot, as today | Built into GitHub, no third-party app; already configured and working here (Finding 2) | A second tool beside the Renovate the maintainer runs elsewhere (Finding 6); can't serve their mise repositories (Finding 2) |
| Both | Nothing either does alone | Every update proposed twice (Finding 7) |

Doing nothing is the Dependabot row, since it is what runs today. "Both"
is better at nothing and is kept only to state why it must be avoided. The
comparison leans to Renovate on the maintainer's request (Finding 6), not
on this repository's needs, which the design step should say plainly.

## Conclusions

1. Exactly one tool must propose version updates for this repository's
   dependencies, so no update is proposed twice (Finding 7).
2. Every GitHub Action the workflows use must be pinned to a commit, with
   its version named beside it, so a moved tag can't change what runs
   (Findings 4; ADR-0010).
3. An update to a GitHub Action the workflows use must be proposed as a pull
   request within a week of its release, so pins don't go stale (Findings 2,
   3).
4. The tool must be the one the maintainer uses across their other
   repositories, as they asked (Finding 6).

## Sources

- Renovate onboarding pull request #10 in `meowshed/meow.review.nvim`, read 2026-09-28 - Finding 1.
- `.github/workflows/ci.yml`, `release.yml`, `dependabot.yml` and `meow.review.nvim-scm-1.rockspec` at `70a73cd`, read 2026-09-28 - Findings 1, 2.
- [Dependabot supported ecosystems](https://docs.github.com/en/code-security/dependabot/ecosystems-supported-by-dependabot/supported-ecosystems-and-repositories), read 2026-09-28 - Finding 2.
- [Renovate managers](https://docs.renovatebot.com/modules/manager/), read 2026-09-28 - Finding 3.
- [Renovate pre-commit manager](https://docs.renovatebot.com/modules/manager/pre-commit/), read 2026-09-28 - Finding 3.
- [Renovate config presets](https://docs.renovatebot.com/config-presets/), read 2026-09-28 - Finding 5.
- `renovate.json`, issue #71 and Renovate pull requests in `meowshed/meowg1k`, read 2026-09-28 - Findings 4, 6, 7.
- Scan of `~/workspace`, run 2026-09-28 - Finding 6.
- Mend developer portal for `meowshed/meow.review.nvim`, maintainer's screenshots, 2026-09-28 - Finding 8.
