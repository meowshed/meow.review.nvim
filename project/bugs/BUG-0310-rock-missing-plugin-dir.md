---
id: BUG-0310
artifact: bug
status: draft
severity: major
violates: REQ-0105
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The published rock doesn't install `plugin/meow-review.lua`, so rocks.nvim users get no commands or mappings

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
gets the Lua API but no `:MeowReview` command and no `<Plug>(MeowReview…)`
mapping.

## What it should do, and why

The installed rock should include `plugin/meow-review.lua` and `doc/`, so
that every action is offered as a `<Plug>` mapping, as REQ-0105 requires, for
rocks.nvim users as for users who clone the repository.

## Triage

Enters at implement, because it violates REQ-0105. Major: the plugin is
unusable from the keyboard for rocks.nvim users, one of the three install
paths README.md documents, though the Lua API still works. Every published
version since 0.1.0 is likely affected, because no rockspec declares
`copy_directories`; only 0.2.1 was reproduced. The CI `build` job installs the
rock on every push and passed with the defect, because an install succeeds
whether or not the directory is copied (RES-0010, Finding 4).

## Closed by

Not closed.
