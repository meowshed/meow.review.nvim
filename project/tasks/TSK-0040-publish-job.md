---
id: TSK-0040
artifact: task
status: draft
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

Not yet.

## Left alone

No protected environment is added (ADR-0010). README.md doesn't describe releasing and doesn't change.
