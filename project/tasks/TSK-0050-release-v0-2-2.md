---
id: TSK-0050
artifact: task
status: approved
revised: 2026-09-27
epic: EPC-0010
closes: [REQ-0602, REQ-0603]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Release `v0.2.2` through the new workflow

The first release under ADR-0010 is published by pushing `v0.2.2`, which puts a rock with `plugin/` on luarocks.org, shows the version follows the tag, and closes BUG-0310 for new installs.

## Acceptance criteria

1. Given the `LUAROCKS_API_KEY` secret and the release commit for 0.2.2 merged to `main`, when the maintainer pushes `v0.2.2` on that commit, then `release.yml` publishes `meow.review.nvim 0.2.2-1` with no manual step. Closed by: the workflow run and `luarocks search meow.review.nvim 0.2.2` listing `0.2.2-1`.
2. Given the published rock, when `tree=$(mktemp -d)` and `luarocks --lua-version 5.1 install --tree "$tree" --deps-mode none meow.review.nvim 0.2.2-1` run, then `plugin/meow-review.lua` is in that tree. Closed by: the commands and `find "$tree" -name meow-review.lua`.
3. Given the published rockspec, when it is read, then its version is `0.2.2-1` and its `source` names `v0.2.2`. Closed by: `luarocks download --rockspec meow.review.nvim 0.2.2-1` and `lua -e 'dofile("meow.review.nvim-0.2.2-1.rockspec"); print(version, source.url, source.dir)'`, printing `0.2.2-1`, a URL ending `/archive/v0.2.2.zip`, and `meow.review.nvim-0.2.2`.
4. Given `v0.2.2` published, when the workflow is re-run for it, then `check` fails at the duplicate search and the published rockspec is unchanged. Closed by: the re-run's failed status and the rockspec's `sha256sum` before and after it.
5. Given the key created, when the maintainer runs `git grep -cF -- "$KEY" $(git rev-list --all)` in a clean clone, then it finds nothing in any revision. Closed by: the command's exit status 1, recorded without the key.
6. Given the `v0.2.2` run, when BUG-0310 is read, then its `## Closed by` holds criterion 2's commands and output. Closed by: the diff to BUG-0310.
7. Given `v0.2.2` pushed, when `release.yml` runs, then `check` runs at the tagged commit and `publish` starts only after `check` succeeded (REQ-0601). Closed by: `needs: check` in `release.yml` and the run's job timings. Moved here from TSK-0020 criterion 3 on 2026-09-27, with the maintainer's approval.
8. Given `v0.2.2` pushed, when `check` runs, then it calls `scripts/check-unpublished.sh` with `0.2.2`. Closed by: the step's log line in the run. Moved here from TSK-0030 criterion 3 on 2026-09-28, with the maintainer's approval.

## What to do

Before tagging, check the secret exists with `gh secret list --repo meowshed/meow.review.nvim`, and stop if it doesn't, because without it `publish` fails and needs a manual re-run, which fails criterion 1; the version is not used up by that failure, so a revoked key is fixed by re-adding it and re-running `publish`. The release commit, merged
to `main` after TSK-0030 and TSK-0040, adds `## [0.2.2] - <date>` to
CHANGELOG.md with a `### Fixed` entry saying the rock now installs `plugin/`
and `doc/` (BUG-0310). The maintainer pushes `v0.2.2` on that commit; a tag
on the wrong commit burns 0.2.2 for good, because REQ-0605 forbids
republishing it. After the run, write criterion 2's commands and output into BUG-0310's `## Closed by`, and record the `check` step's log lines from the first run (the search passing for `0.2.2`) and from criterion 4's re-run (the search failing on `0.2.2-1`) as TSK-0030's evidence.

## Depends on

TSK-0030 and TSK-0040, because the release exercises the whole workflow. The `LUAROCKS_API_KEY` repository secret, which the maintainer creates and stores.

## Evidence

Not yet.

## Left alone

The published 0.1.0 to 0.2.1 rocks stay as they are (REQ-0605). `meow.review.nvim-0.1.0-1`, `0.2.0-1` and `0.2.1-1.rockspec` stay in the repository (ADR-0010).
