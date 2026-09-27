---
id: TSK-0010
artifact: task
status: draft
revised: 2026-09-27
epic: EPC-0010
closes: [REQ-0600]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Add `meow.review.nvim-scm-1.rockspec` and build it with `make build`

The repository gets one rockspec that installs `plugin/` and `doc/` with the Lua modules, and `make build` installs from it, so every build, local or in CI, produces a rock that ships the plugin directory.

## Acceptance criteria

1. Given a clean checkout, when `make build` runs, then both `plugin/meow-review.lua` and `doc/meow-review.txt` are installed under the rock's directory in `build/`. Closed by: `make build` followed by `find build -path '*/meow.review.nvim/scm-1/*' \( -name meow-review.lua -o -name meow-review.txt \)`, whose output lists both files under `…/meow.review.nvim/scm-1/`. The `build` table sits outside the `is_release` branch, so this scm build stands for every release rock.
2. Given the scm rockspec loaded directly, when LuaRocks reads it, then it declares version `scm-1`, depends on `nui.nvim`, and lists `plugin` and `doc` under `copy_directories`. Closed by: `luarocks lint meow.review.nvim-scm-1.rockspec` exiting 0 and the file in the pull request.

## What to do

Write the rockspec as a dual-purpose template, in the form the
`luarocks-tag-release` README at the pinned commit describes:

- `$is_release` chooses the branch. The placeholders `$is_release`,
  `$git_ref`, `$modrev`, `$specrev` and `$repo_name` may appear only in the `is_release` branch, or in a top-level `local` consumed there, because loading the rockspec directly leaves them unfilled and any other field would carry the literal placeholder into the scm rock; every other
  field (`package`, `dependencies`, `build`, `description`, `license`) is
  written out as a literal value.
- Release branch: version `modrev .. '-' .. '$specrev'`, `source.url` the tag
  archive `https://github.com/meowshed/meow.review.nvim/archive/` ..
  `git_ref` .. `.zip`, and `source.dir = 'meow.review.nvim-' .. modrev`,
  because GitHub names the archive directory without the tag's `v`.
- Scm branch: version `scm-1`, `source.url =
  "git+https://github.com/meowshed/meow.review.nvim.git"`; the README's
  `git://` form doesn't work on GitHub.
- `description.homepage` is `https://github.com/meowshed/meow.review.nvim`.
- `build = { type = "builtin", copy_directories = { "plugin", "doc" } }`, outside both branches;
  don't copy the README example's `build` table, which lists `lua`, a
  directory the same README forbids copying.

Set the Makefile's `ROCKSPEC := meow.review.nvim-scm-1.rockspec` directly, and
update the comments on the `ROCKSPEC` variable and the `build` target, the CI
step name "Build the newest rockspec" in `.github/workflows/ci.yml`, and the
line in CLAUDE.md's gate that says `make build` builds the newest rockspec.

## Depends on

None.

## Evidence

Not yet.

## Left alone

The three versioned rockspecs stay, as ADR-0010 decides. The CI `build` job keeps running `make build`; only its step name changes.
