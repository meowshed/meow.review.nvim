---
id: TSK-0030
artifact: task
status: approved
revised: 2026-09-27
epic: EPC-0010
closes: [REQ-0605]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Refuse a version already on luarocks.org in `check`

On a pushed tag `vX.Y.Z`, `check` fails if any revision of `X.Y.Z` is already on luarocks.org, so `publish` never runs for a published version.

## Acceptance criteria

1. Given version `0.2.1`, whose `0.2.1-1` is on luarocks.org, when `scripts/check-unpublished.sh 0.2.1` runs, then it exits non-zero and names `0.2.1-1`. Closed by: the command and its output.
2. Given version `9.9.9`, which has no revision on luarocks.org, when `scripts/check-unpublished.sh 9.9.9` runs, then it exits 0. Closed by: the command and its output.
3. Moved to TSK-0050 criterion 8 on 2026-09-28, with the maintainer's approval, because kept here it made TSK-0030 wait on TSK-0050, which depends on it through TSK-0040.
4. Given no network, when `scripts/check-unpublished.sh 0.2.2` runs, then it exits non-zero and says the search failed. Closed by: the command run with networking off, and its output.
5. Moved to TSK-0050 on 2026-09-28, with the maintainer's approval, for the same reason; TSK-0050 criterion 4 already checks it.

## What to do

Add `scripts/check-unpublished.sh <version>`, which runs `luarocks search
meow.review.nvim <version>` (ADR-0010) and fails when the output lists any
`<version>-N` revision, matched exactly, with the dots escaped and anchored at
the start of the field, so `0.2.1` never matches `10.2.1-1`. Decide from the
output, not the exit status alone, because `luarocks search` may exit 0 when
nothing matches; and fail when the search itself fails, a non-zero exit or no
result header in its output, so a search that couldn't reach luarocks.org
refuses the publish rather than allowing it. In the `check` job, call it only
for tags, with the version taken from the tag without its `v`, because a
pull request run has no version to search.

## Depends on

TSK-0020, because the search is a step of the `check` job.

## Evidence

Collected at commit `1fef804`, tree `052c2e85126a`.

- Seen failing first: `luarocks search meow.review.nvim 0.2.1` exits 0 with
  `0.2.1-1` listed, and exits 0 with nothing listed for `9.9.9`, so a check
  on the exit status would let a published version through; against an
  unreachable server it also exits 0, printing only `Warning: Failed
  searching manifest` on stderr.
- Criterion 1 (REQ-0605): `scripts/check-unpublished.sh 0.2.1` exited 1 with
  "check-unpublished: meow.review.nvim 0.2.1 is already on
  https://luarocks.org as 0.2.1-1".
- Criterion 2: `scripts/check-unpublished.sh 9.9.9` exited 0 with "no
  revision of meow.review.nvim 9.9.9 is on https://luarocks.org". `0.2` and
  `10.2.1` also exited 0, so neither matched `0.2.1-1`.
- Criterion 4: networking off was simulated with an unreachable server,
  `LUAROCKS_SERVER=https://nonexistent.invalid scripts/check-unpublished.sh
  0.2.2`, which exited 1 with "the search couldn't reach
  https://nonexistent.invalid" and the LuaRocks warning.
- Criteria 3 and 5: moved to TSK-0050.
- `shellcheck` 0.11.0 on both scripts exited 0.
- `meow-verbs evidence format lint check test build`, exit 0:
  format passed, record fa0eafcef1a8, current at tree 052c2e85126a;
  lint passed, record 5cb9f1b50ea2, current at tree 052c2e85126a;
  check passed, record 36b1bfb9816a, current at tree 052c2e85126a;
  test passed, record d9b00fa21b6d, current at tree 052c2e85126a;
  build passed, record e66b8a853696, current at tree 052c2e85126a.

## Left alone

`fail_on_duplicate` in `publish` stays as the second guard; this task doesn't depend on it.
