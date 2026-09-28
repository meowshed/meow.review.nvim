---
id: TSK-0080
artifact: task
status: approved
revised: 2026-09-28
epic: EPC-0020
closes: [REQ-0702]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Show Renovate proposes an action release within seven days

Once every action is pinned, the first new release of one of them shows
whether Renovate proposes it on schedule, which is what REQ-0702 asks.

## Acceptance criteria

1. Given a release of an action the workflows use, published after TSK-0070
   merged, when Renovate proposes it, then the pull request opens no more
   than seven days after the release. Closed by: the release's date on its
   GitHub release page and the pull request's creation date.
2. Given that pull request, when it is read, then it moves the SHA and the
   `# vX.Y.Z` comment together. Closed by: `gh pr diff` of it.

## What to do

Watch the Dependency Dashboard and the actions' release pages after
TSK-0070 merges. When the first release lands and Renovate proposes it,
record both dates. If a release passes seven days with no pull request,
record that as a failure of REQ-0702 with the dashboard's text, and look in
the Mend portal's job log for why. Merging the pull request is ordinary
maintenance, not this task.

## Depends on

TSK-0070, because the proposal it waits for is a digest update to a pinned
action. A new release of one of `actions/checkout`, `actions/cache`,
`JohnnyMorganz/stylua-action` or `lumen-oss/luarocks-tag-release`, which the
project doesn't control.

## Evidence

Not yet.

## Left alone

The schedule and the grouping stay as ADR-0020 sets them.
