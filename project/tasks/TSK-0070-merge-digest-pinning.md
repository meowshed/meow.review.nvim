---
id: TSK-0070
artifact: task
status: approved
revised: 2026-09-28
epic: EPC-0020
closes: [REQ-0701]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Merge Renovate's digest-pinning pull request

Renovate's first run after TSK-0060 proposes pinning every action to a commit; merging it leaves every action at a SHA with a `# vX.Y.Z` comment, 

## Acceptance criteria

1. Given Renovate's pinning pull request, when it is read, then it changes only `uses:` lines, each to a 40-character SHA with a `# vX.Y.Z` comment. Closed by: `gh pr diff` of it.
2. Given it merged, when `grep -rn 'uses:' .github/workflows/` runs on `main`, then every action from another repository is at a SHA with a `# vX.Y.Z` comment (REQ-0701). Closed by: the command's output.

## What to do

Wait for Renovate's pinning pull request after TSK-0060 merges; its
schedule may hold it until the Monday run. Check its CI, then merge it with
`gh pr merge --squash` and a subject that passes `meow-scm check-message`.
The pull request changes files under `.github/workflows/`, so the merge needs
a token with the `workflow` scope; if the token lacks it, stop and say so, and never cherry-pick the change onto `main` in its place, because the change has to land through the pull request so CI runs on it and Renovate sees it merged.

## Depends on

TSK-0060, because Renovate proposes the pinning only once its config is on `main`. A `gh` token with the `workflow` scope, which the maintainer provides.

## Evidence

Collected on 2026-09-28 at the squash commit `f977218`, merged through pull
request #12.

- Seen failing first: before #12, 11 of the 12 `uses:` lines on `main`
  referenced a tag, such as `actions/checkout@v7`, and failed the check
  `grep -rn 'uses:' .github/workflows/ | grep -vE '@[0-9a-f]{40} # v[0-9]+\.[0-9]+\.[0-9]+$'`.
- Renovate held the pull request under "Pending Status Checks" in dashboard
  #11, because `prCreation: not-pending` waits for checks and the workflows
  don't run on `renovate/**` pushes; the maintainer asked to force it, and
  ticking its box in #11 made Renovate open #12.
- Criterion 1: #12 changed only `uses:` lines in `ci.yml` (9) and
  `release.yml` (2), each to a 40-character SHA. Ten carried a full version;
  Renovate wrote `JohnnyMorganz/stylua-action@76fd70c… # v5`, keeping the
  moving tag, so commit `096553f` on the pull request changed it to
  `# v5.0.0`, the release tag at the same commit (`gh api
  repos/JohnnyMorganz/stylua-action/tags`: `v5.0.0` and `v5` both at
  `76fd70c03e6340ceaf673366712db9b20560b402`). The same commit replaced the
  stale comment "Dependabot proposes moving the pin" in `release.yml` with
  Renovate (ADR-0020). actionlint 1.7.12 passed; all checks passed on #12.
- Criterion 2 (REQ-0701): on `main` after the merge, all 12 `uses:` lines
  match `@<40-char SHA> # vX.Y.Z` and none fails the check above.
- Finding: every Renovate update here waits about a day for status checks
  that never run on its branches, because of `prCreation: not-pending`;
  REQ-0702's seven days still leaves room, which TSK-0080 will show.

## Left alone

`release.yml`'s `luarocks-tag-release` pin stays as ADR-0010 set it, apart from Renovate's own proposals.
