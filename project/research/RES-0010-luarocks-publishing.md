---
id: RES-0010
artifact: research
status: approved
revised: 2026-09-27
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# CI can publish to LuaRocks on a pushed tag, but only a rock that ships `plugin/` and is checked for it is worth publishing

## Summary

CI can publish each release to luarocks.org when its tag is pushed, and the
comparison leans to the `luarocks-tag-release` action. The larger finding is
that the rock published today is incomplete: building the 0.2.1 rockspec
installs `lua/`, `doc/` and `tests/` but not `plugin/meow-review.lua`, which
defines `:MeowReview` and every `<Plug>` mapping, and the CI job that already
builds the rock passed with that defect. So automating the upload alone would
ship the defect faster; the rock must copy `plugin/`, and something must check
that it does. This covers publishing to luarocks.org. It doesn't cover how
versions and tags are chosen, or the GitHub release page.

## The question

Can CI publish meow.review.nvim to LuaRocks when a release is made, and what
must hold for that publish to be correct?

The assumption behind the question is that the manual publish works and only
its effort is the problem. It doesn't hold: the rock the current rockspec
builds lacks `plugin/` (Finding 2), so a user who installs through rocks.nvim
gets the Lua modules but no command and no mapping (Finding 3). Whatever CI
does, it has to publish a rock that includes the plugin directory, and it has
to check that before the rock reaches users.

A second assumption is that LuaRocks matters to this plugin's users at all.
README.md documents three install paths, and only rocks.nvim goes through
LuaRocks (Finding 10). Automating the publish serves one of three documented
audiences, so doing nothing is an option this document weighs.

## Method

- Read `meow.review.nvim-0.2.1-1.rockspec`, `.github/workflows/ci.yml`,
  `Makefile`, README.md, CHANGELOG.md and CLAUDE.md, and listed the
  repository root, at commit `d684401`.
- Ran `make build` (`luarocks make` of the newest rockspec into `build/`)
  and listed what it installed.
- Ran `luarocks search meow.review.nvim` and `luarocks help upload`
  (LuaRocks 3.13.0).
- Read the READMEs of `lumen-oss/luarocks-tag-release` and
  `lumen-oss/rocks.nvim` from their default branches, and the action's
  repository and latest release through the GitHub API.
- Ran `gh secret list --repo meowshed/meow.review.nvim`. The organisation's
  secrets couldn't be listed: the token lacks the `admin:org` scope.
- Read `lua/luarocks-tag-release.lua` in `lumen-oss/luarocks-tag-release` on
  its `main` branch, to see what its install test runs.

## Findings

### 1. Releases are published by hand today

Each release is a `release: vX.Y.Z` commit adding a rockspec and a pushed
tag (CHANGELOG.md, CLAUDE.md), and `.src.rock` files for 0.2.0 and 0.2.1 sit
in the repository root, which shows the upload was made from a local machine
(repository root, read 2026-09-27). `luarocks search` lists 0.2.1 as a
rockspec and a source rock on luarocks.org (run 2026-09-27). No workflow
publishes (`.github/workflows/ci.yml`, read 2026-09-27).

### 2. The rock installs no `plugin/` directory

The 0.2.1 rockspec's `build` is `{ type = "builtin" }` with no
`copy_directories`. `make build` installed `share/lua/5.1/meow/review/…`
and, under the rock's directory, `doc/` and `tests/`, and no `plugin/`
(run 2026-09-27). `plugin/meow-review.lua` defines the `:MeowReview`
command and the `<Plug>` mappings (plugin/meow-review.lua).

### 3. rocks.nvim loads a rock's runtime directories, including `plugin`

rocks.nvim installs a rock's runtime directories separately from its Lua
modules, and a plugin's `plugin` scripts come from there (rocks.nvim README,
read 2026-09-27). A rock without `plugin/` therefore gives a rocks.nvim user
no `:MeowReview`.

### 4. Installing the rock doesn't detect the missing directory

The CI `build` job runs `make build`, which installs the rock, on every push
and pull request (`.github/workflows/ci.yml`, read 2026-09-27), and it passed
on `d684401` with the rock lacking `plugin/`. An install succeeds whether or
not `plugin/` is copied.

### 5. The luarocks-tag-release action copies the plugin directories by default

Its `copy_directories` input defaults to `{{ neovim.plugin.dirs }}`, which
expands to the Neovim runtime directories including `plugin` and `doc`, and
it warns against copying `lua` (luarocks-tag-release README, read
2026-09-27).

### 6. The action publishes on a pushed tag and tests the install

On a pushed tag it generates a rockspec, tests a local install, uploads with
the `LUAROCKS_API_KEY` secret, and tests the install of the uploaded package;
on a pull request it only tests the local install (luarocks-tag-release
README, read 2026-09-27). A `v` prefix is stripped from the tag to form the
version. By default an existing version is skipped silently; with
`fail_on_duplicate` the workflow fails instead.

### 7. The action can use a rockspec kept in the repository as its template

It generates the rockspec from a built-in template unless `template` names
one, and a single `<package>-scm-1.rockspec` can serve as both the
development rockspec and the release template (luarocks-tag-release README,
read 2026-09-27). With either, no per-release rockspec is committed, which
changes the release form CLAUDE.md records (CLAUDE.md, read 2026-09-27).

### 8. The action is maintained and versioned

`lumen-oss/luarocks-tag-release` was last pushed on 2026-09-27, released
`v7.3.0` on 2026-09-23, and is not archived; its README pins `@v7` for
non-breaking updates (GitHub API, read 2026-09-27).

### 9. `luarocks upload` publishes a committed rockspec with an API key

`luarocks upload <rockspec>` packs a source rock and uploads both; `--temp-key`
passes the key for one invocation without storing it; `--force` replaces an
existing revision (luarocks help upload, 3.13.0, run 2026-09-27). It doesn't
install the rock.

### 10. Only one of three documented install paths uses LuaRocks

README.md documents lazy.nvim, packer.nvim and rocks.nvim; only rocks.nvim
installs through LuaRocks (README.md, read 2026-09-27).

### 11. The action's install test only installs and removes the rock

Its local test runs `luarocks install --tree <temporary directory>` on the
generated rockspec and then `luarocks remove`; after uploading it runs
`luarocks install` of the published package. It neither loads the plugin nor
inspects the installed files (`lua/luarocks-tag-release.lua`, read
2026-09-27). The local test and the upload run in one step on a pushed tag,
so a content check has to run in an earlier job or on the pull request,
building from the same rockspec: that is possible when the rockspec is a
template kept in the repository (Finding 7), not when the action generates it
from its built-in template.

### 12. The action takes dependencies as an input

Dependencies such as `nui.nvim` are passed in the `dependencies` input or
written in a repository template (luarocks-tag-release README, read
2026-09-27); the built-in template knows none of them.

### 13. No publishing secret exists yet

`gh secret list --repo meowshed/meow.review.nvim` returned no secrets (run
2026-09-27), and the organisation's secrets couldn't be read.

## Options

| Option | Better at | Case against |
| ------ | --------- | ------------ |
| Publish on tag with `luarocks-tag-release` | Copies `plugin/` and `doc/` by default, so the rock is complete without editing a rockspec (Finding 5); publishes from the tag with no manual step (Finding 6); no rockspec to write per release (Finding 7) | Its install test only installs and removes the rock, so like the existing CI build it doesn't show `plugin/` was copied (Findings 4, 11); a content check needs a repository template the check can build (Findings 7, 11); an existing version is skipped silently unless `fail_on_duplicate` is set (Finding 6); `nui.nvim` must be passed as a dependency (Finding 12); replaces the committed-rockspec release form (Finding 7); adds a third-party action to the release path (Finding 8); the generated rockspec is seen only as CI output, not in a pull request |
| Run `luarocks upload` on the committed rockspec in a tag workflow | Keeps the release commit and rockspec CLAUDE.md records, reviewed like any change; no third-party action; the rockspec in git is exactly what is published (Finding 9) | Each rockspec needs `copy_directories` added by hand, and nothing checks it was (Findings 2, 4); the rockspec's version and the tag can disagree; the committed rockspecs still point `source.url` and `homepage` at `retran/meow.review.nvim` |
| Do nothing: keep publishing by hand | No secret to manage (Finding 13); nothing new in CI; serves the one of three install paths that needs it (Finding 10) | Leaves the incomplete rock in place until a rockspec is fixed by hand (Finding 2); keeps a manual step, done from one machine, in every release (Finding 1) |

Abandoning LuaRocks entirely is better at nothing "do nothing" doesn't cover:
it drops the rocks.nvim path README.md documents without removing any cost,
so it is dropped.

None of the three, as described, detects a rock that lacks `plugin/` (Findings 4, 11); each needs a check of the installed rock's contents added, and for the action that check must build from a repository template before the tag's publish runs (Finding 11). With
that check, the comparison leans to `luarocks-tag-release`, because its
default makes the rock complete without a hand-edited rockspec (Finding 5).
Whether to publish from CI at all, and which option, is left to the design
step.

## Conclusions

1. The published rock must install `plugin/` and `doc/` along with `lua/`,
   so that a rocks.nvim user gets `:MeowReview` and `:help meow-review`
   (Findings 2, 3, 5).
2. The installed rock must be checked for `plugin/meow-review.lua` before it
   is published, because installing it succeeds whether or not the directory
   was copied (Findings 2, 4).
3. If publishing is automated, a release must be published when its tag is
   pushed, so that the published version is the one the tag names and no
   step depends on one machine (Findings 1, 6).
4. The published version must match the release tag without its `v` prefix,
   so that a user can find the release notes and the source for the version
   they installed (Findings 1, 6).
5. The LuaRocks API key must reach the publishing workflow only as a secret,
   never in the repository, because anyone holding it can publish as the
   maintainer (Findings 9, 13).
6. Publishing a version that already exists must fail visibly and never
   replace it, so that users who installed a version keep the exact files
   they installed, and a skipped publish isn't mistaken for a successful one
   (Findings 6, 9).

## Sources

- [luarocks-tag-release README](https://github.com/lumen-oss/luarocks-tag-release), read 2026-09-27 - Findings 5, 6, 7, 8, 12.
- `lua/luarocks-tag-release.lua` in `lumen-oss/luarocks-tag-release`, branch `main`, read 2026-09-27 - Finding 11.
- [rocks.nvim README](https://github.com/lumen-oss/rocks.nvim), read 2026-09-27 - Finding 3.
- GitHub API, `repos/lumen-oss/luarocks-tag-release` and its latest release, read 2026-09-27 - Finding 8.
- `luarocks help upload`, LuaRocks 3.13.0, run 2026-09-27 - Finding 9.
- `luarocks search meow.review.nvim`, run 2026-09-27 - Finding 1.
- `meow.review.nvim-0.2.1-1.rockspec` and `make build`, at `d684401`, run 2026-09-27 - Finding 2.
- `plugin/meow-review.lua` at `d684401`, read 2026-09-27 - Finding 2.
- `.github/workflows/ci.yml`, README.md, CHANGELOG.md and CLAUDE.md at `d684401`, and the repository root listing, read 2026-09-27 - Findings 1, 4, 7, 10.
- `gh secret list --repo meowshed/meow.review.nvim`, run 2026-09-27 - Finding 13.

## Open review findings

- The reviewer suggested wording the conclusions as what the findings show
  rather than as obligations. Kept as obligations, because the research
  template asks each conclusion to state what must now be true, and the
  requirements step builds from them.
