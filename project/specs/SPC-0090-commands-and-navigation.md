---
id: SPC-0090
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: [REQ-0102, REQ-0105]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Commands, mappings, navigation and status

## Scope

This covers the user-facing entry points: the `:MeowReview` command, the
`<Plug>` mappings, the Lua API functions they call, navigation between
annotations, reload and the statusline string. What each action does inside
its window is in the document for the modals and picker, and export is in its
own document.

## Boundary

- `:MeowReview <subcommand> [arg]` takes a range and completes subcommand
  names, and exporter names after `export`, `export_and_clear` and
  `export_file` (from plugin/meow-review.lua, high).
- Each subcommand has a `<Plug>` mapping and a Lua function (REQ-0105; from
  README.md and doc/meow-review.txt, high):

  | Subcommand | `<Plug>(MeowReview…)` | Lua function |
  | ---------- | --------------------- | ------------ |
  | `add` | `Add` (n, v) | `add_comment(is_visual)` |
  | `delete` | `Delete` (n, v) | `delete_comment()` |
  | `edit` | `Edit` | `edit_comment()` |
  | `view` | `View` | `view_comment()` |
  | `export [name]` | `Export` | `export_review(name)` |
  | `export_and_clear [name]` | `ExportAndClear` | `export_and_clear(name)` |
  | `export_file [name]` | `ExportFile` | `export_current_file(name)` |
  | `clear` | `Clear` | `clear_all()` |
  | `goto` | `Goto` | `goto_comment()` |
  | `goto_file` | `GotoFile` | `goto_comment_in_file()` |
  | `goto_type [type]` | `GotoType` | `goto_comment_by_type(type)` |
  | `resolve` | `Resolve` | `resolve_comment()` |
  | `resolve_all` | `ResolveAll` | `resolve_all_comments()` |
  | `reload` | `Reload` | `reload()` |
  | `validate` | `Validate` | `validate()` |
  | `next` | `Next` | `next_comment()` |
  | `prev` | `Prev` | `prev_comment()` |

- The plugin maps no key of its own outside its popup windows (REQ-0102;
  from README.md, high).
- `require("meow.review").status()` returns a string for a statusline (from
  doc/meow-review.txt, high).

## Behaviour

- `:MeowReview add` with a range annotates the range; without one it
  annotates as in normal mode (from plugin/meow-review.lua, high).
- `next` and `prev` sync positions, then jump to the next or previous
  unresolved annotation after the cursor in file-then-line order, wrapping
  around and crossing files, opening the file if needed (from
  lua/meow/review/init.lua and doc/meow-review.txt, high).
- `reload` reloads the store for the current buffer's root, redraws every
  buffer's signs and reports "MeowReview: Reloaded N comment(s)." (from
  lua/meow/review/init.lua, high).
- `status()` returns `""` when the store is empty. Otherwise it returns an
  icon, the count of all annotations, and, when more than one type is
  present among the unresolved ones, a breakdown such as `(3 ISSUE, 2 NOTE)`
  (from doc/meow-review.txt and lua/meow/review/init.lua, high).

## Failure paths

- `:MeowReview` with no subcommand prints a usage line, and an unknown
  subcommand reports "MeowReview: Unknown command: <name>" (from
  plugin/meow-review.lua, high). The usage line lists 11 of the 17
  subcommands (from plugin/meow-review.lua, high).
- Arguments after the first are ignored (from plugin/meow-review.lua, high).
- `next` and `prev` with no unresolved annotations report "MeowReview: No
  annotations." (from lua/meow/review/init.lua, high).
- A jump to an annotation whose file no longer exists reports "MeowReview:
  File no longer exists: <file>" and stays put (from lua/meow/review/init.lua,
  high).
- `status()` counts resolved annotations in its total but leaves them out of
  the breakdown, so the total can exceed the sum of the breakdown (from
  lua/meow/review/init.lua, high).
