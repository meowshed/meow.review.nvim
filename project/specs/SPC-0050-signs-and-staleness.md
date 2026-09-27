---
id: SPC-0050
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: [REQ-0500, REQ-0501]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Signs, position tracking and stale detection

## Scope

This covers how annotations appear in the sign column, how they follow edits
and how the plugin decides that one is stale. It doesn't cover what the store
saves.

## Boundary

- Signs are extmarks in the namespace `meow_review` (from
  lua/meow/review/signs.lua, high).
- Each type has a sign icon and a highlight group, and resolved and stale
  annotations use `MeowReviewResolved` and `MeowReviewStale` (from
  CHANGELOG.md, high).
- `require("meow.review").validate()` checks every annotation and returns how
  many are stale; `:MeowReview validate` and `<Plug>(MeowReviewValidate)` run
  it (from doc/meow-review.txt and README.md, high).

## Behaviour

- An annotation's sign moves with its text while lines are edited above it
  (REQ-0500; from README.md, high). Before save, goto, next, prev, edit,
  delete and view, the plugin copies each extmark's line back into the
  annotation and moves the end line by the same amount (from CHANGELOG.md and
  lua/meow/review/store.lua, high).
- Signs appear in buffers already open when `setup()` loads the annotations
  (from CHANGELOG.md, high).
- Entering a buffer redraws its signs after a 50 ms debounce (from
  lua/meow/review/init.lua, high).
- `validate()` marks an annotation stale when its file is gone, its start
  line (`lnum`) is past the end of the file, or the first line of its
  snippet, with the `NNN: ` prefix removed and whitespace trimmed, differs
  from the file's line at `snippet_start` (REQ-0501; from doc/meow-review.txt
  and lua/meow/review/validate.lua, high). doc/meow-review.txt says the
  snippet must match, and the code compares only its first line.
- `validate()` reads the saved file on disk and uses the last-synced `lnum`,
  so unsaved edits don't count (from lua/meow/review/init.lua and
  lua/meow/review/validate.lua, high).
- Redrawing a buffer's signs also sets staleness, comparing the same first
  snippet line with the buffer's line at `snippet_start`, and never marks an
  annotation with a hunk stale (from lua/meow/review/signs.lua, high).
- `snippet_start` is set when the annotation is added and doesn't move with
  edits, while `lnum` does, so lines added above an annotation can mark it
  stale although its text is unchanged (onboarding gap 20; from
  lua/meow/review/store.lua and lua/meow/review/validate.lua, high).

## Failure paths

- A buffer that is no longer valid is skipped when the plugin syncs positions
  or draws signs (from lua/meow/review/store.lua and PR #1, high).
- Resolve at the cursor looks the annotation up by line before syncing
  positions, so after lines are edited above it, resolve can pick the wrong
  annotation or none (from lua/meow/review/init.lua, high).
- An annotation whose first snippet line or file line is empty is never
  marked stale by the snippet check (from lua/meow/review/validate.lua, high).
- `validate()` and the sign column can disagree: `validate()` doesn't exempt
  hunk annotations and reads the file on disk, while sign drawing exempts
  hunks and reads the buffer (from lua/meow/review/validate.lua and
  lua/meow/review/signs.lua, high).
- A stale highlight set by `validate()` lasts until the buffer's signs are
  next redrawn, which recomputes staleness by the sign-drawing rule (from
  lua/meow/review/validate.lua and lua/meow/review/signs.lua, high).

## Open review findings

- The reviewer found that the statements about signs in open buffers, the
  debounce and redraw staleness trace to no requirement. The documents state
  none for them, so they stay untraced until a person writes one.
- The reviewer asked for the reasons behind the empty-line exemption, the
  50 ms debounce and skipping invalid buffers. No document gives them; the
  exemption is asked as onboarding gap 26.
- Rejected: the reviewer asked for tables in Boundary and Failure paths. The
  record's specification template doesn't require them.
