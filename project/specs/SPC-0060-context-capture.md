---
id: SPC-0060
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: []
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Context capture

## Scope

This covers what the plugin records about the code around a new annotation:
the range it covers, the source snippet, the enclosing symbol and the diff
hunk. It doesn't cover how that context is exported.

## Boundary

- `context_lines` (3 by default) sets how many lines above and below the
  range the snippet holds, and 0 or less turns the snippet off (from
  README.md and lua/meow/review/init.lua, high).
- The symbol is the name of the nearest enclosing Treesitter node of a
  listed kind, such as a function, method, class or Markdown heading, that
  has a name (from lua/meow/review/context.lua, high).
- The hunk is a unified-diff header with its start and end lines (from
  lua/meow/review/config/meta.lua, high).

## Behaviour

- The symbol and the hunk are looked up at the cursor, also when there is a
  visual selection, so a selection can be saved with a hunk it doesn't
  overlap (from lua/meow/review/init.lua, high).
- With a visual selection, the annotation covers the selected lines. Without
  one, it covers the hunk at the cursor when there is one, and the cursor
  line otherwise. When visual mode is asked for but the buffer has never had
  a selection, it covers the cursor line (from lua/meow/review/init.lua,
  high).
- The snippet holds the covered lines and `context_lines` around them, cut at
  the first and last lines of the buffer, each written `N: text` (from
  doc/meow-review.txt and lua/meow/review/init.lua, high).
- The symbol walks up from the node at the cursor and skips a listed node
  whose name can't be read, so an anonymous Lua function inside a named one
  gives the outer name (from lua/meow/review/context.lua, medium: read, not
  run).
- The hunk comes from gitsigns.nvim when it can be required and has a hunk
  at the cursor. Otherwise, when the tab page has at least two windows in
  diff mode, the plugin diffs the current buffer against the first diff
  window that isn't the current one (from lua/meow/review/context.lua, high).
- The plugin treats a pure deletion from gitsigns.nvim as a one-line hunk,
  and the diff fallback skips a pure deletion, so the cursor there gets no
  hunk (from lua/meow/review/context.lua, high).

## Failure paths

- Without a Treesitter parser, or with no enclosing node of a listed kind
  that has a name, the annotation has no symbol (from
  lua/meow/review/context.lua, high).
- Outside a hunk, or when the diff fails, the annotation has no hunk (from
  lua/meow/review/context.lua, high).

## Open review findings

- The reviewer found that no requirement backs this document. No document
  states an obligation for context capture, so onboarding recovers none; it
  is asked as onboarding gap 29.
