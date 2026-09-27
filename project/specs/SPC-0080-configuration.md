---
id: SPC-0080
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: []
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Configuration

## Scope

This covers how the plugin reads, merges and validates its configuration. What
each key does is stated in the document for the part that uses it.

## Boundary

- The keys, their types and their defaults:

  | Key | Type | Default |
  | --- | ---- | ------- |
  | `context_lines` | number | `3` |
  | `disabled_exporters` | list | `{}` |
  | `default_exporter` | string | `"clipboard"` |
  | `default_formatter` | string | `"markdown"` |
  | `export_filename` | string | `".review.md"` |
  | `store_path` | string | `".cache/meow-review/annotations.json"` |
  | `modal_width` | number | `64` |
  | `modal_height` | number | `6` |
  | `modal_cycle_key` | string | `"<C-t>"` |
  | `auto_gitignore` | `"always"`, `"prompt"` or `false` | `"prompt"` |
  | `prompt_preamble` | string | the preamble README.md shows |
  | `export_summary` | boolean | `true` |
  | `annotation_types` | table | nil |
  | `annotation_type_order` | list | nil |

  (from README.md and lua/meow/review/config/internal.lua, high)
- The module `meow.review.config.internal` offers `get()` and
  `validate(cfg)` (from lua/meow/review/config/internal.lua, high).

## Behaviour

- `get()` reads `vim.g.meow_review`, calling it first when it is a function,
  and deep-merges it over the defaults on every call (from
  lua/meow/review/config/internal.lua, high).
- `setup(opts)` deep-merges `opts` into `vim.g.meow_review`, so options set
  before the plugin loads and options passed to `setup()` combine (from
  lua/meow/review/init.lua, high).
- `validate` checks the type of every key except `annotation_types` and
  `annotation_type_order`, and checks that `auto_gitignore` is a string or a
  boolean (from lua/meow/review/config/internal.lua, high).
- `auto_gitignore` accepts any string; only `"always"` and `"prompt"` do
  anything (from lua/meow/review/config/internal.lua and
  lua/meow/review/store.lua, high).

## Failure paths

- When any key fails validation, `get()` reports
  "MeowReview configuration error: vim.g.meow_review.<key>…" and returns the
  defaults, discarding every user setting, on every call until the value is
  fixed (from lua/meow/review/config/internal.lua, high).
- `setup()` raises an error when `vim.g.meow_review` is a function (from
  lua/meow/review/init.lua, high: reproduced by a reviewer in headless
  Neovim).

## Open review findings

- No requirement backs this document; no document states an obligation for
  how configuration is merged or validated beyond REQ-0103.
