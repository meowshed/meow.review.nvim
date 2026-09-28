---
id: TSK-0090
artifact: task
status: approved
revised: 2026-09-28
bug: BUG-0090
closes: [REQ-0301]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Make `export_and_clear` clear the store only after an export that wrote something

Restores REQ-0301: `export_and_clear` keeps the store whenever the export
fails, is cancelled or writes nothing, including when an exporter finishes
after it returns.

## Acceptance criteria

1. Given the `file` exporter and an unwritable path, when `export()` runs,
   then it returns false and reports false once. Closed by: the test "reports
   failure when the file exporter can't open its path".
2. Given a formatter that raises, or the `json` formatter with a value it
   can't encode, when `export()` runs, then it returns false. Closed by: the
   tests "reports failure when a formatter raises an error" and "reports
   failure when the json formatter can't encode".
3. Given `file_prompt`, when its prompt is cancelled, then the export
   reports false, and until it is answered the export is `DEFERRED`. Closed
   by: the two `file_prompt` tests.
4. Given a deferred export, when `export_and_clear` runs, then the store is
   cleared only after the exporter reports success. Closed by: the
   `export_and_clear()` tests in `tests/spec/init_spec.lua`.

## What to do

Give `export()` an `on_done(ok)` callback called exactly once, let an
exporter return `export.DEFERRED` and report through a `done` argument, make
the built-in `file`, `file_prompt` and `json` report failure by raising, and
have `export_and_clear` clear in `on_done`. Existing exporters that take two
arguments keep working.

## Depends on

None.

## Evidence

Collected at commit `7a74e9d`, tree `3ba0c62af590`.

- Seen failing first: with the new tests and the old code, `make test`
  failed them, for example "reports failure when the file exporter can't open
  its path" got `true` where `false` was expected, and the formatter test
  raised "boom".
- After the fix, all 110 tests pass, including the 7 new ones.
- `meow-verbs evidence format lint check test build`, exit 0:
  format passed, record 1c36f2d05a0f, current at tree 3ba0c62af590;
  lint passed, record ed1b9cade34b, current at tree 3ba0c62af590;
  check passed, record 9d9dbc930deb, current at tree 3ba0c62af590;
  test passed, record cd58bbd65791, current at tree 3ba0c62af590;
  build passed, record ad8d1a3e0edf, current at tree 3ba0c62af590.
- One `make test` run hung past 300 seconds before these runs and couldn't
  be reproduced; every later run finished in seconds.

## Left alone

The exporter signature stays compatible: a two-argument exporter that returns
normally still counts as success. BUG-0100, whether `export_and_clear` should
clear resolved annotations the export left out, is a separate defect.
