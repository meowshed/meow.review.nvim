---
id: SPC-0070
artifact: spec
status: live
revised: 2026-09-27
checked-at:
states: [REQ-0104]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Annotation types

## Scope

This covers the annotation types: the built-in set, how a user's
`annotation_types` replaces it, the order the modal cycles through, and the
highlight groups. It doesn't cover where signs are drawn.

## Boundary

- `annotation_types` is a table keyed by type name, each entry with optional
  `icon`, `hl`, `label` and `sign_name` (from README.md, high).
- `annotation_type_order` is a list of type names (from README.md, high).
- The module `meow.review.types` offers `setup(types, order)`, `get(name)`,
  `next(name)` and `setup_highlights()`, and holds the active `types` and
  `order` (from lua/meow/review/types.lua, high).

## Behaviour

- Three types are built in: `ISSUE` (`DiagnosticError`), `SUGGESTION`
  (`DiagnosticWarn`) and `NOTE` (`DiagnosticInfo`), cycled in that order
  (from README.md and lua/meow/review/types.lua, high).
- A non-empty `annotation_types` makes its keys the only active types
  (REQ-0104; from doc/meow-review.txt, high). An entry's missing field is
  taken from the built-in type with the same key, and otherwise defaults to
  an empty icon, `Normal`, the key as its label, and `MeowReview<key>` as its
  sign name (from lua/meow/review/types.lua, high).
- A nil or empty `annotation_types` restores the built-in set and order (from
  doc/meow-review.txt and lua/meow/review/types.lua, high).
- The cycling order is `annotation_type_order` when it is non-empty, and
  otherwise the active keys sorted alphabetically (from
  lua/meow/review/types.lua, high).
- `next(name)` returns the type after `name` in the order, wrapping to the
  first; for a name not in the order it returns the first (from
  lua/meow/review/types.lua, high).
- `setup_highlights()` links `MeowReviewResolved` to `Comment` and
  `MeowReviewStale` to `DiagnosticWarn`, as defaults a colour scheme can
  override (from lua/meow/review/types.lua, high).
- `sign_name` is not used since signs became extmarks (from
  doc/meow-review.txt, high).

## Failure paths

- An order naming a type that isn't active is used as given; `next` then
  steps through names `get` doesn't know (from lua/meow/review/types.lua,
  medium: read, not run).
- An annotation whose type isn't active, for example after the types
  changed, has no definition from `get` (from lua/meow/review/types.lua,
  high).
- `annotation_types` and `annotation_type_order` are never validated, so a
  wrong shape fails where it is used (from
  lua/meow/review/config/internal.lua, high).
