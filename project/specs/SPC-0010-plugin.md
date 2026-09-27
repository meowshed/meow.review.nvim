---
id: SPC-0010
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: [REQ-0100, REQ-0101, REQ-0102, REQ-0103, REQ-0104, REQ-0105]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The plugin as a whole

## Scope

This covers what is true of the whole plugin: its entry points, its
configuration, its dependencies and how its modules call one another. Each
part has its own document: the annotation store, export, the modals and
picker, signs and stale detection, context capture, annotation types,
configuration, commands and navigation, and the health check.

## Boundary

- The plugin loads from `plugin/meow-review.lua`, which guards against
  loading twice with `vim.g.loaded_meow_review`, defines the highlight groups
  `MeowReviewIssue`, `MeowReviewSuggestion`, `MeowReviewNote`,
  `MeowReviewStale` and `MeowReviewResolved` with `default = true`, and
  defines the `:MeowReview` command with 17 subcommands and 17
  `<Plug>(MeowReview…)` mappings (from README.md and plugin/meow-review.lua,
  high).
- Each action is offered as a `<Plug>` mapping (REQ-0105), and the plugin
  sets no key mapping outside its own popup windows (REQ-0102; from
  README.md, high).
- The Lua API is the module `require("meow.review")`, whose public functions
  doc/meow-review.txt lists under LUA API (from doc/meow-review.txt, high).
- `:checkhealth meow.review` reports the Neovim version, the dependencies,
  the configuration, the registered exporters and the store (from
  lua/meow/review/health.lua, high).
- Configuration comes from `setup(opts)` or from `vim.g.meow_review` set
  before the plugin loads (from doc/meow-review.txt, high). Without
  `setup()`, `vim.g.meow_review` may also be a function that returns the
  table (from lua/meow/review/config/internal.lua, high).
- The configuration keys and their defaults are the ones README.md lists
  under Default Configuration (from README.md, high), declared as the class
  `meow.review.Config` (from lua/meow/review/config/meta.lua, high).

## Behaviour

- The plugin runs on Neovim 0.11.0 or later (REQ-0100; from README.md, high).
- nui.nvim is the only plugin it requires (REQ-0101; from README.md, high).
  gitsigns.nvim, snacks.nvim, telescope.nvim, fzf-lua, avante.nvim and
  codecompanion.nvim are optional and detected with `pcall(require, …)` when
  needed (from README.md, high). Symbol context uses Neovim's built-in
  `vim.treesitter`, and only the health check looks for the nvim-treesitter
  plugin (from lua/meow/review/context.lua and lua/meow/review/health.lua,
  high).
- `setup()` deep-merges `opts` into `vim.g.meow_review`, so a second call
  keeps the keys it leaves out (REQ-0103; from lua/meow/review/init.lua,
  high). The merge combines list values index by index, and a second call
  never unregisters a built-in exporter it now disables (from
  lua/meow/review/init.lua and lua/meow/review/export.lua, high).
- Three annotation types are built in, ISSUE, SUGGESTION and NOTE, and a
  non-empty `annotation_types` replaces the whole set (REQ-0104; from
  README.md, high). Because `setup()` deep-merges, a second call with
  `annotation_types` adds to the first call's table (from
  lua/meow/review/init.lua, medium: read, not run).
- The plugin keeps one project root at a time: the output of
  `git rev-parse --show-toplevel` for the current buffer's directory, or the
  working directory outside git (from lua/meow/review/store.lua, high).
- `setup()` installs two handlers. `BufEnter` redraws a buffer's signs after
  a 50 ms debounce. `DirChanged` loads the annotations of a new root, taking
  the root from the current buffer's directory, so `:cd` into another
  repository while the buffer is in the first one keeps the first root (from
  lua/meow/review/init.lua and lua/meow/review/store.lua, high). Without
  `setup()`, neither handler exists.
- Module calls: `init.lua` calls the store, signs, UI, export, context and
  validate modules; the store and signs call each other; signs calls types;
  context loads no other plugin module; and most modules read the
  configuration (from the `require` calls in lua/meow/review/, high).

## Failure paths

- On a Neovim older than 0.11.0 the plugin reports an error and doesn't load
  (from plugin/meow-review.lua, high).
- Without nui.nvim, each command that checks for it reports that nui.nvim is
  required and does nothing. The `validate`, `next` and `prev` subcommands
  and the `Reload`, `Next` and `Prev` `<Plug>` mappings don't check and run
  without it; the `Validate` mapping does check (from plugin/meow-review.lua,
  high).
- When any configuration value fails validation, the error is reported and
  the whole configuration falls back to the defaults, discarding every user
  setting. `annotation_types` and `annotation_type_order` are not validated
  (from lua/meow/review/config/internal.lua, high).
- `setup()` raises an error when `vim.g.meow_review` is a function, because
  the deep merge expects a table (from lua/meow/review/init.lua, high:
  reproduced by the reviewer in headless Neovim).

## Open review findings

- The reviewer asked for the reason behind the Neovim version, the single
  dependency, the `<Plug>`-only mappings and the replacing type set. No
  document gives one; the requirements carry the question as onboarding gap
  19.
- Rejected: the reviewer asked to set this document to `draft` while its
  requirements are drafts. The record's layout allows only `live` for a
  specification, so the document stays live and `paw check` reports that it
  rests on drafts until they are approved.
