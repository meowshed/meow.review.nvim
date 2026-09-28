---
id: SPC-0030
artifact: spec
status: live
revised: 2026-09-28
checked-at:
states: [REQ-0300, REQ-0301, REQ-0302]
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Export

## Scope

This covers turning annotations into text (formatters) and sending that text
somewhere (exporters). It doesn't cover which annotations exist, which the
store holds.

## Boundary

- An exporter is `fun(content: string, root: string)`, registered by name
  with `register_exporter` and removed with `unregister_exporter` (from
  doc/meow-review.txt, high).
- An exporter signals failure by raising an error; a normal return counts as
  success. An exporter that finishes later returns `export.DEFERRED` and calls
  the `done` function it gets as its third argument once, with `true` on
  success (BUG-0090; lua/meow/review/export.lua).
- `export(name, formatter, filter, on_done)` calls `on_done(ok)` exactly
  once, when the export has finished (lua/meow/review/export.lua).
- A formatter is `fun(annotations: meow.review.Annotation[]): string`,
  registered with `register_formatter` and removed with
  `unregister_formatter` (from doc/meow-review.txt and
  lua/meow/review/init.lua, high).
- The formatter is chosen only by `default_formatter` (`markdown` by
  default); no entry point takes a formatter name (from
  lua/meow/review/init.lua and plugin/meow-review.lua, high).
- The exporter is the one named, or `default_exporter` (`clipboard` by
  default) when none is named (from lua/meow/review/export.lua, high).
- Built-in exporters: `clipboard` (the `+` register), `file` (writes
  `export_filename` under the project root) and `file_prompt` (asks for a
  filename, then writes) (from README.md, high).
- `avante` and `codecompanion` exporters are registered when those plugins
  load (from README.md, high).
- `disabled_exporters` keeps named built-ins from being registered (from
  README.md, high).
- Built-in formatters: `markdown` and `json` (from doc/meow-review.txt,
  high).
- Entry points: `export_review(name)`, `export_and_clear(name)` and
  `export_current_file(name)`, and the matching `:MeowReview` subcommands
  (from doc/meow-review.txt, high).

## Behaviour

- Export takes the store's annotations sorted by file, then line, without
  resolved ones: it calls `store.sorted()` with no options, so no export
  entry point can include them (REQ-0300; from lua/meow/review/export.lua and
  lua/meow/review/store.lua, high).
- `export_current_file` exports only the current buffer's file (from
  doc/meow-review.txt, high).
- The Markdown opens with `# Code Review — <date>`, then the
  `prompt_preamble`, then a `## Summary` block unless `export_summary` is
  false, then one `## @<file>` section per file (from doc/meow-review.txt and
  lua/meow/review/export.lua, high).
- Each annotation is headed `### [TYPE] <file> — <location>`, followed by
  `` — `<symbol>` `` when the annotation has a symbol (REQ-0302; from
  doc/meow-review.txt, high). The location is `line N`, `lines N–M` or
  `hunk <header>` (from lua/meow/review/export.lua, high).
- When the annotation has a snippet, the heading is followed by a fenced
  snippet with line numbers and a language taken from the file extension;
  the comment comes last (from doc/meow-review.txt and
  lua/meow/review/export.lua, high).
- `export_and_clear` clears the store only once the export has finished and
  succeeded (REQ-0301; lua/meow/review/init.lua).

## Failure paths

- An unknown exporter or formatter name is reported as a warning, nothing is
  exported, and `export_and_clear` keeps the store (from
  lua/meow/review/export.lua, high).
- With no annotations to export, the plugin reports "No annotations",
  exports nothing, and `export_and_clear` keeps the store (from
  lua/meow/review/export.lua, high).
- `export_current_file` in a buffer with no file warns "No file in current
  buffer." and exports nothing (from lua/meow/review/init.lua, high).
- An exporter that raises an error is reported with its name, the export
  counts as failed, and `export_and_clear` keeps the store (from
  lua/meow/review/export.lua, high).
- A formatter that raises an error is reported with its name, and the export
  fails (lua/meow/review/export.lua).
- When the `json` formatter can't encode, it raises, and the export fails
  (lua/meow/review/export.lua).
- When `file` or `file_prompt` can't open its path, the export fails and
  `export_and_clear` keeps the store (lua/meow/review/export.lua).
- `file_prompt` defers until its prompt is answered; cancelling it fails the
  export, and `export_and_clear` keeps the store (lua/meow/review/export.lua).
- A second argument to `:MeowReview export` is ignored, although
  doc/meow-review.txt shows `:MeowReview export clipboard xml` choosing a
  formatter (from plugin/meow-review.lua, high).

## Open review findings

- Rejected: the reviewer asked to set this document to `draft` while its
  requirements are drafts. The record's layout allows only `live` for a
  specification.
