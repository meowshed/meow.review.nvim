---
id: TSK-0040
artifact: task
status: approved
revised: 2026-09-27
epic: EPC-0010
closes: [REQ-0604]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Add the `publish` job, Dependabot and the new release principle

On a pushed `v*` tag, after `check` passes, the `publish` job uploads the release to luarocks.org with `luarocks-tag-release` pinned to a commit, reading the key only from the `LUAROCKS_API_KEY` secret; Dependabot proposes moving the pin; CLAUDE.md describes the new release form.

## Acceptance criteria

1. Given the workflow, when a pull request runs it, then `publish` is skipped. Closed by: the pull request's run showing `publish` skipped.
2. Given the repository, when `git grep -n LUAROCKS_API_KEY -- .github '*.rockspec'` runs, then every match is a reference to the secret, `${{ secrets.LUAROCKS_API_KEY }}`, or the name it is passed under. Closed by: the command's output. The key's value itself is searched for across the whole history once the key exists, in TSK-0050 criterion 5.
5. Given `release.yml`, when it is read, then the action's `uses:` line names commit `4aa641e8e4befe0617fa3d7db40dbda832ddd27b` with `# v7.3.0` beside it, and the step sets `template: meow.review.nvim-scm-1.rockspec` and `fail_on_duplicate: true`. Closed by: the diff.
3. Given `.github/dependabot.yml` merged, when Dependabot runs, then its update job for the `github-actions` ecosystem succeeds. Closed by: that job's run on the default branch.
4. Given CLAUDE.md, when it is read, then its release principle says a release is a changelog commit and a pushed tag published by `release.yml`, with no versioned rockspec, and gives its reason. Closed by: the diff.

## What to do

In `release.yml`, add `publish` with `needs: check` and `if:
startsWith(github.ref, 'refs/tags/v')`, so it never runs on pull requests.
Use `lumen-oss/luarocks-tag-release@4aa641e8e4befe0617fa3d7db40dbda832ddd27b`
with `# v7.3.0` beside it, `template: meow.review.nvim-scm-1.rockspec`,
`fail_on_duplicate: true` (both ADR-0010), and `LUAROCKS_API_KEY: ${{ secrets.LUAROCKS_API_KEY }}`
in its environment. Add `.github/dependabot.yml` for the `github-actions`
ecosystem, directory `/`, weekly, a default chosen here because the pin moves rarely and a daily prompt would be noise. In CLAUDE.md,
replace the principle `changelog_and_rockspec_per_release` with
`changelog_and_tag_per_release`, describing the new release form and citing
ADR-0010.

## Depends on

TSK-0030, because both edit `release.yml` and `publish` should land after the `check` job is complete.

## Evidence

Collected at commit `faf7efa`, tree `69b9e11bb077`.

- Criterion 1: pull request #5 skipped `Publish to luarocks.org` while
  `Check the rock` passed:
  https://github.com/meowshed/meow.review.nvim/actions/runs/36358346577/job/108730480141.
- Criterion 2 (REQ-0604), seen failing first: with a literal
  `LUAROCKS_API_KEY: not-a-real-key-0000` in `release.yml`, `git grep -n
  LUAROCKS_API_KEY -- .github '*.rockspec'` listed it as a match that isn't a
  secret reference; after restoring the file the only match is
  `.github/workflows/release.yml:45:          LUAROCKS_API_KEY: ${{ secrets.LUAROCKS_API_KEY }}`.
- Criterion 3: after the merge to `main` at `d87462c`, Dependabot's update
  job `github_actions in /.` completed with success:
  https://github.com/meowshed/meow.review.nvim/actions/runs/36358787802.
- Criterion 4: CLAUDE.md's principle `changelog_and_rockspec_per_release` is
  replaced by `changelog_and_tag_per_release`, which gives its reason (the
  published version can't be replaced).
- Criterion 5: `release.yml` uses
  `lumen-oss/luarocks-tag-release@4aa641e8e4befe0617fa3d7db40dbda832ddd27b # v7.3.0`
  with `template: meow.review.nvim-scm-1.rockspec` and `fail_on_duplicate: true`.
- actionlint 1.7.12 with shellcheck 0.11.0 on `release.yml` and `ci.yml`
  exited 0.
- `meow-verbs evidence format lint check test build`, exit 0:
  format passed, record 4a4f7f4aed55, current at tree 69b9e11bb077;
  lint passed, record 7cf6468db8e3, current at tree 69b9e11bb077;
  check passed, record 67fa06e1061b, current at tree 69b9e11bb077;
  test passed, record 0c39b1447a0a, current at tree 69b9e11bb077;
  build passed, record 2df650474b63, current at tree 69b9e11bb077.
- Finding, not a criterion: the pinned action is a composite that runs
  `cachix/install-nix-action@v30`, pinned by tag inside the action, so the
  commit pin in `release.yml` fixes the action's own code but not that step
  (`action.yml` at 4aa641e, read 2026-09-28). ADR-0010's reason for the pin
  covers the template filling, which is the action's own code.

## Left alone

No protected environment is added (ADR-0010). README.md doesn't describe releasing and doesn't change.
