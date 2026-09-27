---
id: constitution
artifact: constitution
status: live
revised: 2026-09-27
---

# CLAUDE.md

<role>
The root policy for this repository. `.meowpaw/profile.toml` outranks it for
the verification commands, the commit types and the trunk.
</role>

<project>
meow.review.nvim is a Neovim plugin for reviewing AI-generated code: you leave
typed annotations (ISSUE, SUGGESTION, NOTE) on lines, the plugin stores them as
JSON and exports them as Markdown or JSON for an AI agent. The code is Lua
under `lua/meow/review/`, with the entry point in `plugin/meow-review.lua` and
the help file in `doc/meow-review.txt`.
</project>

<principles>

<principle name="neovim_0_11_and_nui_only">
Target Neovim 0.11.0 or later and keep `nui.nvim` as the only required
dependency, because the README, the rockspec and `:checkhealth meow.review` all
promise exactly that. Treesitter, gitsigns, Snacks, Telescope, fzf-lua,
avante.nvim and codecompanion.nvim stay optional: detect each one at run time
and fall back when it's missing.
</principle>

<principle name="stylua_and_luacheck_clean">
Keep every Lua file under `lua/`, `plugin/`, `tests/` and `scripts/` clean for
`stylua --check` and `luacheck`, with 4-space indents and 120 columns as
`.stylua.toml` and `.luacheckrc` set them, because CI fails the push on either.
Run `make format` to fix formatting in place.
</principle>

<principle name="source_file_headers">
Start every Lua file with the MIT licence header and the `@file:`, `@brief:`,
`@author:` and `@license:` tags, and annotate public functions in `lua/` with
LuaLS annotations (`---@param`, `---@return`, `---@class`), because the README
names both as the code style and every Lua file carries the header.
</principle>

<principle name="conventional_commits">
Write each commit subject as `type(scope): summary` in 72 characters or fewer,
with a type from `[commits.types]` in `.meowpaw/profile.toml`, the scope
optional and the issue number in parentheses where one exists, for example
`feat(store): stale annotation detection with validate.lua (#4)`. Merge
commits follow the same form, `chore: merge pull request #N from <branch>`.
Check a message with `meow-scm check-message` before you use it, because every
commit in the history passes that check.
</principle>

<principle name="changelog_and_tag_per_release">
Record each user-visible change under `## [Unreleased]` in `CHANGELOG.md`,
which follows Keep a Changelog and Semantic Versioning. A release is one
`release: vX.Y.Z` commit that dates the changelog section, and a pushed tag
`vX.Y.Z` on it; `.github/workflows/release.yml` then publishes it to
luarocks.org from `meow.review.nvim-scm-1.rockspec`, and no versioned rockspec
is committed (ADR-0010). Because the published version can't be replaced, a
fix after publishing ships as a new patch version, and the tag goes on the
merged release commit on `main` only.
</principle>

</principles>

<gate>
CI (`.github/workflows/ci.yml`) runs on every push and pull request to `main`,
and each job runs one `make` target that you can run locally too:

- `make test` runs the busted suite through nlua on Neovim stable and nightly,
  and fails on any failing spec.
- `make lint` runs luacheck and fails on any warning.
- `stylua --check lua/ plugin/ tests/ scripts/` (`make format-check` locally)
  fails on any file stylua would change.
- `make check` runs lua-language-server on `lua/`, `plugin/`, `tests/` and
  `scripts/` against Neovim's runtime, and fails on any diagnostic at warning level or above.
- `make build` builds `meow.review.nvim-scm-1.rockspec`, the template every
  release is published from, into `build/`, and fails if LuaRocks can't
  install it.

`make deps` installs busted and nlua into `~/.luarocks` for Lua 5.1, and the
test runner clones `nui.nvim` into `deps/` on first run.
</gate>
