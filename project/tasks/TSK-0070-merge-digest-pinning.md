---
id: TSK-0070
artifact: task
status: draft
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

Not yet.

## Left alone

`release.yml`'s `luarocks-tag-release` pin stays as ADR-0010 set it, apart from Renovate's own proposals.
