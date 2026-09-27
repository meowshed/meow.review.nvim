---
id: BUG-0310
artifact: bug
status: approved
severity: major
violates: REQ-0600
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The published rock doesn't install `plugin/meow-review.lua`, so rocks.nvim users likely get no commands or mappings

## Reproduction

Reproduced on 2026-09-27 on macOS with LuaRocks 3.13.0 and Lua 5.1 (mise),
against meow.review.nvim 0.2.1-1 as published on luarocks.org, and against
the 0.2.1 rockspec at commit `d684401`.

1. Run `luarocks --lua-version 5.1 install --tree /tmp/lr --deps-mode none meow.review.nvim 0.2.1-1`.
2. Run `find /tmp/lr -name meow-review.lua`.
3. List `/tmp/lr/lib/luarocks/rocks-5.1/meow.review.nvim/0.2.1-1/`.

`make build`, which installs the newest rockspec from the working tree, gives
the same result.

## What the system does

The install succeeds. The rock's directory holds `doc/` and `tests/`, the Lua
modules are under `share/lua/5.1/meow/review/`, and `find` returns nothing:
`plugin/meow-review.lua` is not installed. The 0.2.1 rockspec's `build` is
`{ type = "builtin" }` with no `copy_directories`, so only the Lua modules and
the directories LuaRocks copies by itself are installed (RES-0010, Finding 2).

rocks.nvim loads a plugin's `plugin` scripts from the rock's runtime
directories (RES-0010, Finding 3), so a user who installs through rocks.nvim
likely gets the Lua API but no `:MeowReview` command and no
`<Plug>(MeowReview…)` mapping. That is inferred from rocks.nvim's README, not
observed in a rocks.nvim install.

## What it should do, and why

The installed rock should include `plugin/meow-review.lua`, as REQ-0600
requires, so that rocks.nvim users get `:MeowReview` and every `<Plug>`
mapping (REQ-0105), as users who clone the repository do. `doc/` is already
installed.

## Triage

Enters at implement, because it violates REQ-0600. Major: the plugin is
unusable from the keyboard for rocks.nvim users, one of the three install
paths README.md documents, though the Lua API still works. The rockspecs for 0.1.0-1, 0.2.0-1 and 0.2.1-1 all
use `type = "builtin"` with no `copy_directories`, so every published
version is likely affected; only 0.2.1 was reproduced. The missing commands
under rocks.nvim are inferred from rocks.nvim's README (RES-0010, Finding 3),
not observed in a rocks.nvim install. The CI `build` job installs the
rock on every push and passed with the defect, because an install succeeds
whether or not the directory is copied (RES-0010, Finding 4); REQ-0601
tracks the content check that would catch it, separately from the rockspec
fix.

## Closed by

Closed for new installs by `meow.review.nvim 0.2.2-1`, published on
2026-09-28 by `release.yml` from `meow.review.nvim-scm-1.rockspec`
(ADR-0010, EPC-0010, run https://github.com/meowshed/meow.review.nvim/actions/runs/36359482130). The reproduction, run against it:

```text
tree=$(mktemp -d)
luarocks --lua-version 5.1 install --tree "$tree" --deps-mode none meow.review.nvim 0.2.2-1
find "$tree" -name meow-review.lua
…/lib/luarocks/rocks-5.1/meow.review.nvim/0.2.2-1/plugin/meow-review.lua
```

The regression check is `scripts/check-rock.sh`, run by the `check` job of
`release.yml` on every pull request and tag (REQ-0601). Versions 0.1.0 to
0.2.1 on luarocks.org stay without `plugin/`, because REQ-0605 forbids
replacing them.
