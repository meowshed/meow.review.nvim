---
id: TSK-0030
artifact: task
status: draft
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
3. Given a pushed `v*` tag, when `check` runs, then it calls the script with the tag's version. Closed by: the `v0.2.2` run in TSK-0050.
4. Given no network, when `scripts/check-unpublished.sh 0.2.2` runs, then it exits non-zero and says the search failed. Closed by: the command run with networking off, and its output.
5. Given `v0.2.2` published, when the workflow is re-run, then `check` fails at the search and `publish` doesn't run. Closed by: TSK-0050 criterion 4's re-run and checksums; this task stays `[>]` until then.

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

Not yet.

## Left alone

`fail_on_duplicate` in `publish` stays as the second guard; this task doesn't depend on it.
