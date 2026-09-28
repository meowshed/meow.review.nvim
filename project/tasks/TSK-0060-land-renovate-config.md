---
id: TSK-0060
artifact: task
status: approved
revised: 2026-09-28
epic: EPC-0020
closes: [REQ-0700, REQ-0703]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Land `renovate.json` through pull request #10 and remove `.github/dependabot.yml`

Renovate becomes the only tool proposing version updates: its config lands on `main` through its own onboarding pull request #10, and Dependabot's version-update config goes.

## Acceptance criteria

1. Given `main` after the merge, when it is read, then `renovate.json` holds the settings ADR-0020 names and `.github/dependabot.yml` doesn't exist (REQ-0700). Closed by: `cat renovate.json` and `ls .github` on `main`, and `gh pr list --author app/dependabot --state open` listing no version-update pull request.
2. Given the merge, when the squash commit named by `gh pr view 10 --json mergeCommit` is read, then its subject passes `meow-scm check-message`. Closed by: the command's output.
3. Given the merge, when Renovate next runs, then its Dependency Dashboard issue exists in the repository. Closed by: the issue's URL.
4. Given the Mend portal, when the maintainer reads the repository's settings, then Silent mode is off and "Require config file" is on, (REQ-0700), and the maintainer confirms Renovate is the tool across their accounts (REQ-0703). Closed by: the maintainer's confirmation, recorded with its date.

## What to do

Check out pull request #10's branch `renovate/configure`, replace its `renovate.json` with ADR-0020's settings, including the preset `helpers:pinGitHubActionDigestsToSemver` its amendment adds (the version waiting in the local
stash `renovate switch, waiting on ADR` has them, apart from its SPC-0110
edit, which the spec step already made), validate it with `npx --yes --package renovate -- renovate-config-validator renovate.json`, keeping its output as evidence, and delete `.github/dependabot.yml`. Push to the branch, wait for
the checks, and merge with `gh pr merge 10 --squash --subject "ci: replace Dependabot with Renovate (#10)"`, because without `--subject` the squash takes the pull request's title, "chore: Configure Renovate", and the branch's own commit "Add renovate.json" fails `meow-scm check-message`.

## Depends on

None.

## Evidence

Collected on 2026-09-28 at the squash commit `df197cb`, merged through pull
request #10.

- Criterion 1 (REQ-0700): pull request #10 changed only `renovate.json`
  (+18) and `.github/dependabot.yml` (-9). On `main`, `renovate.json` holds
  `config:recommended`, `group:recommended` and
  `helpers:pinGitHubActionDigestsToSemver`, timezone `Europe/Amsterdam`,
  schedule "before 6am on Monday", `prCreation: not-pending`, `rebaseWhen:
  conflicted`, the label `dependencies`, and the `github-actions` rule with
  `pinDigests: true`, group "github actions" and type `ci`; `ls .github`
  lists only `workflows`; `gh pr list --author app/dependabot --state open`
  listed none.
- The config was validated with `npx --yes --package renovate@latest --
  renovate-config-validator renovate.json` (Renovate 44.115.13): "Config
  validated successfully against 1 file(s)".
- Criterion 2: `gh pr view 10 --json mergeCommit` names `df197cb`, "ci:
  replace Dependabot with Renovate (#10)", which `meow-scm check-message`
  passes.
- Criterion 3: Renovate created the Dependency Dashboard, issue #11, at
  2026-09-28T00:25:21Z; it lists the pinning update for TSK-0070 under
  "Pending Status Checks".
- Criterion 4 (REQ-0700, REQ-0703): on 2026-09-28 the maintainer confirmed
  that the Mend portal has Silent mode off and "Require config file" on for
  this repository, and that Renovate is the tool across their accounts.
- All checks passed on pull request #10 before the merge.

## Left alone

Dependabot security updates stay as they are (REQ-0700). The workflows are not touched; pinning them is TSK-0070.
