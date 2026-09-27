---
id: SPC-0100
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: []
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Health check

## Scope

This covers `:checkhealth meow.review`: what it checks and what it reports. It
doesn't change anything it checks.

## Boundary

- `:checkhealth meow.review` runs `require("meow.review.health").check()`
  (from doc/meow-review.txt, high).
- It reports in seven sections: Neovim version, Dependencies, Configuration,
  Exporters, Store, Troubleshooting Information and Summary (from
  lua/meow/review/health.lua, high).

## Behaviour

- Neovim version: ok at 0.11.0 or later, an error below it (from
  lua/meow/review/health.lua, high).
- Dependencies: an error when `nui.input` or `nui.popup` can't be loaded, a
  warning when `nui.menu` can't, and information for nvim-treesitter,
  gitsigns.nvim and snacks.nvim, which are optional (from
  lua/meow/review/health.lua, high).
- Configuration: ok with `context_lines`, `disabled_exporters` and the start
  of `prompt_preamble` when the configuration is valid, an error with the
  message otherwise, and whether `vim.g.meow_review` is set (from
  lua/meow/review/health.lua, high).
- Exporters: each registered exporter, and a warning when none is registered
  because `setup()` hasn't run (from lua/meow/review/health.lua, high).
- Store: the detected project root, the number of annotations loaded, and
  whether the store file exists at its resolved path (from
  lua/meow/review/health.lua, high).
- Summary: ok when the dependencies and the configuration pass, an error
  otherwise (from lua/meow/review/health.lua, high).

## Failure paths

- A module that can't be loaded is reported as an error in its section, and
  the other sections still run (from lua/meow/review/health.lua, high).
- Some messages don't match the code: the treesitter line says
  nvim-treesitter enables symbol context, while the plugin uses the built-in
  `vim.treesitter`; the nui.menu warning says the picker falls back to
  Snacks only, while it also tries telescope.nvim and fzf-lua; and the
  troubleshooting line gives the export output as `.review.md` and the
  clipboard whatever the configuration says (from lua/meow/review/health.lua
  and lua/meow/review/ui.lua, high).
- doc/meow-review.txt says the check reports `.meow-review.json` presence;
  it reports the configured store path (from doc/meow-review.txt and
  lua/meow/review/health.lua, high).

## Open review findings

- No requirement backs this document; no document states an obligation for
  the health check.
