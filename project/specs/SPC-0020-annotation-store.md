---
id: SPC-0020
artifact: spec
status: live
revised: 2026-09-28
checked-at:
states: [REQ-0200, REQ-0201, REQ-0202]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# The annotation store

## Scope

This covers the annotations held in memory, the JSON file they persist to,
and the `.gitignore` entry for that file. It doesn't cover how annotations are
shown or exported.

## Boundary

- The store file is at `store_path`, `.cache/meow-review/annotations.json`
  by default, resolved against the project root when relative and used as
  given when absolute (REQ-0201; from README.md, high). A path counts as
  absolute only when it is already in canonical form, so `~/a.json` and
  `/tmp/../a.json` are joined to the root (from lua/meow/review/utils.lua,
  high: reproduced by the reviewer in headless Neovim).
- The file holds `{ "version": 1, "annotations": [...] }` (from
  lua/meow/review/store.lua, high).
- Each annotation carries `id`, `file` (relative to the project root),
  `lnum`, `end_lnum`, `type`, `text`, `context`, `snippet`, `snippet_start`,
  `hunk_head`, `hunk_start`, `hunk_end`, `timestamp` and `resolved` (from
  lua/meow/review/config/meta.lua, high).
- `stale`, `extmark_id` and `bufnr` are set at run time and never saved (from
  lua/meow/review/config/meta.lua, high).
- The store module offers `add`, `update`, `delete`, `resolve`,
  `resolve_all`, `clear`, `load`, `save`, `sync_extmark_positions`, the
  queries `all`, `count`, `sorted`, `has_file`, `current_file`,
  `get_at_line`, `get_at_cursor`, `find_next` and `find_prev`, and the root
  functions `get_project_root`, `current_root`, `set_project_root` and
  `get_store_path` (from lua/meow/review/store.lua, high).

## Behaviour

- Annotations survive a restart of Neovim (REQ-0200; from README.md, high).
- Every change (add, update, delete, resolve, resolve all, clear) rewrites
  the whole file; an update, delete or resolve whose ID matches nothing
  writes nothing (from lua/meow/review/store.lua, high).
- Before writing, the store copies each annotation's line from its extmark in
  open buffers and moves its end line by the same amount, so the saved range
  follows edits (from lua/meow/review/store.lua, high).
- The parent directories of the store file are created on every write if
  missing (from lua/meow/review/store.lua, high).
- An annotation's ID is `vim.uv.hrtime()` in nanoseconds, an underscore and a
  random six-digit number; the nanosecond clock keeps IDs apart, and the
  random part guards against two equal clock readings without guaranteeing it
  (from lua/meow/review/store.lua, high).
- An entry saved without `resolved` loads as not resolved (from
  lua/meow/review/store.lua, high).
- `sorted()` orders annotations by file, then line, and leaves resolved ones
  out unless `include_resolved = true` (from lua/meow/review/store.lua, high).
- `find_next` and `find_prev` go through `sorted()`, so they skip resolved
  annotations; they wrap around and cross file boundaries (from
  doc/meow-review.txt and lua/meow/review/store.lua, high).
- After each write, `auto_gitignore` decides the entry in
  `<project root>/.gitignore`: `"always"` appends it, `"prompt"` asks the
  user, and `false` does nothing (REQ-0202; from README.md, high). The entry
  is `/<store path relative to the root>`, or `/<file name>` when the store is
  outside the root, which ignores a file of that name at the root and not the
  store (from lua/meow/review/store.lua, high).
- Nothing is asked or appended when `<project root>/.gitignore` has a line
  equal to that entry. A broader rule such as `.cache/`, a nested
  `.gitignore`, `.git/info/exclude` and the global excludes file don't count
  (from lua/meow/review/store.lua, high).
- With `"prompt"`, a dismissed prompt is not remembered, so the user is asked
  again after the next write, although README.md and the `auto_gitignore`
  comment in lua/meow/review/config/meta.lua say "once" (from
  lua/meow/review/store.lua, high). This breaks REQ-0202 as written.

## Failure paths

- A missing store file loads as no annotations (from
  lua/meow/review/store.lua, high).
- A file that isn't valid JSON, has a version other than 1, or has an
  `annotations` value that isn't a list loads as no annotations with a
  warning, and every later save refuses to overwrite it and says so, until a
  load reads it cleanly (BUG-0110; lua/meow/review/store.lua).
- An entry missing `id`, `file`, `lnum`, `type` or `text` is skipped on load,
  and the next change removes it from the file (from
  lua/meow/review/store.lua, high).

- When encoding fails or the file can't be opened, the error is reported and
  the file is left as it was (from lua/meow/review/store.lua, high).
- Opening the file truncates it, and the write itself isn't checked, so a
  write that fails after the open leaves the file empty or partial and reports
  nothing (from lua/meow/review/store.lua, high).
