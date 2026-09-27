---
id: TSK-0020
artifact: task
status: approved
revised: 2026-09-27
epic: EPC-0010
closes: [REQ-0601]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Add the `check` job in `.github/workflows/release.yml`

A new workflow builds the rock from the scm rockspec at the commit under test and fails unless the installed rock includes `plugin/meow-review.lua`, on every pull request to `main` and every pushed `v*` tag.

## Acceptance criteria

1. Given a pull request that removes `plugin` from `copy_directories`, when the workflow runs, then `check` fails and names the missing file. Closed by: the failed run on a throwaway pull request, linked in the evidence.
2. Given the scm rockspec from TSK-0010, when `check` runs on a pull request, then it passes. Closed by: the passing run on this task's pull request.
3. Given a pushed `v*` tag, when the workflow runs, then `check` runs at the tagged commit and `publish` starts only after `check` succeeded. Closed by: `needs: check` in `release.yml`, which TSK-0040 writes, and the `v0.2.2` run in TSK-0050; this task stays `[>]` after merge until that run, and is marked done in TSK-0050's commit.

## What to do

Build from the checkout with `luarocks --lua-version 5.1 make --deps-mode none --tree <tmp> meow.review.nvim-scm-1.rockspec`,
not `luarocks build`, which would fetch the scm rockspec's git source at
`main` instead of the commit under test; `--deps-mode none` keeps the check
off the network. Then test for the installed file at the rock directory,
`$(luarocks --lua-version 5.1 --tree <tmp> show --rock-dir meow.review.nvim)/plugin/meow-review.lua`,
never at a path the source checkout would satisfy, and fail with a message
naming the missing file. Install LuaRocks the way the `build` job in `.github/workflows/ci.yml` does (apt `luarocks`, Lua 5.1), so both jobs build with the same LuaRocks. Trigger on `pull_request` to `main`, a default chosen here because `main` is the only branch (`master` in `ci.yml` is left out on purpose), and on
`push` of tags matching `v*`.

## Depends on

TSK-0010, because the job builds the template that task adds.

## Evidence

Collected at commit `7b07bc7`, tree `d81613dc3c06`.

- Seen failing first, locally: with `copy_directories = { "doc" }` in the
  scm rockspec, `scripts/check-rock.sh` exited 1 with "check-rock: the
  installed rock has no plugin/meow-review.lua (looked in
  …/rocks-5.1/meow.review.nvim/scm-1)"; with the real rockspec it exited 0.
- Criterion 1 (REQ-0601): throwaway pull request #3, which dropped `plugin`,
  failed the `check` job with the same message:
  https://github.com/meowshed/meow.review.nvim/actions/runs/36356649576/job/108725601832.
  The pull request was closed unmerged.
- Criterion 2: this task's pull request #2 passed the `check` job:
  https://github.com/meowshed/meow.review.nvim/actions/runs/36356646458/job/108725592305.
- Criterion 3: not yet; it needs `needs: check` from TSK-0040 and the
  `v0.2.2` run in TSK-0050.
- `meow-verbs evidence format lint check test build`, exit 0:
  format passed, record 5464b1b69c8f, current at tree d81613dc3c06;
  lint passed, record df9ae67c85aa, current at tree d81613dc3c06;
  check passed, record edead232499f, current at tree d81613dc3c06;
  test passed, record c43374e68750, current at tree d81613dc3c06;
  build passed, record 9ff39253515a, current at tree d81613dc3c06.

## Left alone

`ci.yml` stays as it is apart from TSK-0010's step name; the check lives in `release.yml`, as ADR-0010 decides.
