---
id: SPC-0110
artifact: spec
status: live
revised: 2026-09-28
checked-at:
states: [REQ-0600, REQ-0601, REQ-0602, REQ-0603, REQ-0604, REQ-0605]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Release and publishing

## Scope

This covers how a release reaches luarocks.org: the rockspec the rock is
built from, the check it passes, and the workflow that publishes it. It
doesn't cover how versions are chosen, the changelog, or the GitHub release
page.

## Boundary

- `meow.review.nvim-scm-1.rockspec` in the repository root is both the
  development rockspec and the template every release rockspec is generated
  from (ADR-0010).
- `.github/workflows/release.yml` has two jobs: `check`, on every pull
  request and on every pushed `v*` tag, and `publish`, on a pushed `v*` tag
  only, after `check` passes (ADR-0010).
- The publishing workflow reads the LuaRocks API key from the repository
  secret `LUAROCKS_API_KEY`, and the repository names only the secret
  (REQ-0604).
- `make build` builds and installs the scm rockspec into `build/`, so local
  builds exercise the template that gets published (ADR-0010).
- Release commits add no versioned rockspec; the three existing ones stay as
  the record of what was published (ADR-0010).
- Renovate proposes moving the publishing action's pin, as it does for every
  action the workflows use (ADR-0020).

## Behaviour

- Every rock built for release installs `plugin/` and `doc/` along with the
  Lua modules, because the template lists both under `copy_directories`
  (REQ-0600).
- `check` builds the rock at the commit under test from the template,
  installs it into a temporary tree, and fails unless the installed files
  include `plugin/meow-review.lua`; `publish` runs only after that passes
  (REQ-0601).
- When a tag `vX.Y.Z` is pushed, `publish` generates the release rockspec
  from the template at the tagged commit and uploads it to luarocks.org, with
  no manual step; the published rockspec's `source` names the tag `vX.Y.Z`,
  not a branch (REQ-0602; ADR-0010).
- The published version is `X.Y.Z` with rockspec revision `1` (REQ-0603;
  ADR-0010).
- On a tag, `check` also searches luarocks.org for any revision of `X.Y.Z`
  and fails if one exists (REQ-0605).
- The publishing action is pinned to a commit, because a tag can be moved and a commit can't, so the action's code changes only when a reviewed change moves the pin (ADR-0010).

## Failure paths

- A template that stops copying `plugin/` fails `check` on the pull request
  that changes it, and on the tag, before anything is uploaded (REQ-0601).
- A tag whose version already has any revision on luarocks.org fails `check`,
  and nothing is uploaded (REQ-0605). If two runs race past the search, the
  server refuses the second upload of the same revision, and
  `fail_on_duplicate` fails that run.
- Without the `LUAROCKS_API_KEY` secret, `publish` fails on the upload, and
  nothing is published (REQ-0604; ADR-0010).
- A failed run is shown as the workflow's failed status on the tag. When the version was uploaded, or already existed, the fix ships as a new patch version (REQ-0605).

## Open review findings

- After a failure before the upload for a version that isn't yet on
  luarocks.org, whether to reuse the version by moving its tag or to cut a new
  patch is open; neither REQ-0605 nor ADR-0010 settles it, and moving a tag
  has a cost for anyone who fetched it.
