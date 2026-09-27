---
id: SPC-0040
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: [REQ-0400]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Modals, view popup and picker

## Scope

This covers the windows the user works in, the add and edit modals, the view
popup and the picker, and what the commands that open them do. The commands
themselves are listed in the document for the plugin as a whole. It doesn't
cover the signs in the sign column.

## Boundary

- The add modal annotates the visual selection when called from visual mode,
  otherwise the whole hunk when the cursor is in one, otherwise the cursor
  line, and opens centred in the editor (from lua/meow/review/init.lua and
  lua/meow/review/ui.lua, high).
- The edit modal opens pre-filled with the annotation's text and type (from
  doc/meow-review.txt, high).
- Modal keys: `modal_cycle_key` (`<C-t>` by default) cycles the type in
  insert mode; `<C-s>` saves in insert and normal mode; `<CR>` saves in normal
  mode; `<Esc>` leaves insert mode; `<Esc>` or `q` cancels in normal mode; and
  `<C-c>` cancels in insert mode (from README.md, high).
- The view popup closes on `q`, `<Esc>` or leaving its window (from
  lua/meow/review/ui.lua, high).
- `modal_width` (64) and `modal_height` (6) size the modal (from README.md,
  high).
- The picker lists annotations for `goto`, `goto_file` and `goto_type`, and
  for edit, delete and view when several annotations cover the cursor (from
  README.md and lua/meow/review/init.lua, high).

## Behaviour

- The add modal's top border reads `Add Review Comment`, then the line, the
  range or `Hunk:` with the hunk header, then the symbol (from
  lua/meow/review/ui.lua, high).
- The edit modal's top border reads `Edit`, then `file:line`,
  `file:start–end` or `Hunk:` with the hunk header, then the symbol (from
  CHANGELOG.md and lua/meow/review/ui.lua, high).
- The bottom border of both modals shows the current type and the save, type
  and cancel keys (from doc/meow-review.txt and lua/meow/review/ui.lua,
  high).
- The view popup shows a `✓ RESOLVED` or `~ STALE` badge when one applies,
  the line, range or hunk, the symbol, the text and the time the annotation
  was made (from lua/meow/review/ui.lua, high).
- When several annotations cover the cursor, edit, delete and view let the
  user pick one (REQ-0400; from doc/meow-review.txt, high).
- Resolve at the cursor matches by line, and acts on the first annotation on
  the line without a picker (from lua/meow/review/init.lua, high).
- The picker uses the first of snacks.nvim, telescope.nvim and fzf-lua that
  is installed, and nui.menu otherwise (from CHANGELOG.md, high).
- Selecting an annotation in a `goto` picker opens its file if needed and
  jumps to its line; in the edit, delete and view pickers it opens the edit
  modal, deletes the annotation or opens the view popup (from
  doc/meow-review.txt and lua/meow/review/init.lua, high).
- `goto_type` with no type name asks for one through `vim.ui.select` first
  (from lua/meow/review/init.lua, high).
- Clearing or resolving all annotations asks for confirmation through
  `vim.ui.select` (from doc/meow-review.txt, high).

## Failure paths

- Edit, delete and view with no annotation at the cursor report
  "MeowReview: No comment at cursor." and open nothing (from
  lua/meow/review/init.lua, high).
- Resolve reports "MeowReview: No file at cursor." in a buffer with no file,
  and "MeowReview: No annotation at cursor." when the line has none (from
  lua/meow/review/init.lua, high).
- `goto` with no annotations reports "MeowReview: No annotations."; `goto_file`
  reports "MeowReview: No file open." or "MeowReview: No annotations in
  current file."; and `goto_type` reports "MeowReview: No annotations of type
  X." (from lua/meow/review/init.lua, high).
- Clearing an empty store reports "MeowReview: No annotations." and resolving
  all with none reports "MeowReview: No annotations to resolve.", neither
  asking for confirmation (from lua/meow/review/init.lua, high).
- Leaving the modal window cancels it and discards the typed text (from
  lua/meow/review/ui.lua, high).
- Saving a comment that is only whitespace closes the modal and saves
  nothing (from lua/meow/review/ui.lua, high).
- Dismissing a modal runs `stopinsert`, so the editor returns to normal mode
  (from lua/meow/review/ui.lua, high).

## Open review findings

- The reviewer found that most behaviour statements here trace to no
  requirement. Onboarding recovers requirements only from documents, and the
  documents state only REQ-0400 for these windows, so the others stay
  untraced until a person writes requirements for them.
- The reviewer asked whether resolve should offer a picker like edit, delete
  and view. That is a question for REQ-0400 and is asked as onboarding gap 28.
- Rejected: the reviewer asked for tables in Boundary and Failure paths. The
  record's specification template doesn't require them, and `paw check`
  reports no shape finding.
