---
id: TSK-0100
artifact: task
status: approved
revised: 2026-09-28
bug: BUG-0110
closes: [REQ-0200]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Refuse to overwrite a store file the plugin couldn't read

Restores REQ-0200: a store file that isn't valid JSON, has an unknown version, or has an `annotations` value that isn't a list keeps its contents, because saves refuse to overwrite it until it loads cleanly.

## Acceptance criteria

1. Given a store file with version 2, when the plugin loads it and an annotation is added, then the file's bytes are unchanged. Closed by: the test "doesn't overwrite a store with an unknown version on the next change".
2. Given a store file that isn't valid JSON, or whose `annotations` isn't a list, when an annotation is added, then the file is unchanged and nothing raises. Closed by: the tests "doesn't overwrite a store that isn't valid JSON on the next change" and "doesn't crash or overwrite when annotations isn't a list".
3. Given a store that loads cleanly, when an annotation is added, then it is saved. Closed by: the test "saves again once the store loads cleanly".

## What to do

In `lua/meow/review/store.lua`, record the path `load()` couldn't read and have `save()` refuse to write that path, with an error naming it and telling the user to fix or move the file and run `:MeowReview reload`; a clean load clears the record.

## Depends on

None.

## Evidence

Collected at commit `10b188b`, tree `23e80df9b87e`.

- Seen failing first: with the new tests and the old code, both overwrite tests failed; the file held `{"version":1,"annotations":[{…"text":"new"…}]}` in place of its original contents.
- After the fix, all 114 tests pass.
- `meow-verbs evidence format lint check test build`, exit 0:
  format passed, record 6e5adeb13c41, current at tree 23e80df9b87e;
  lint passed, record 0030fc1c0682, current at tree 23e80df9b87e;
  check passed, record d6c2c7e596f7, current at tree 23e80df9b87e;
  test passed, record 42aa354b7277, current at tree 23e80df9b87e;
  build passed, record 3213a94f2cd8, current at tree 23e80df9b87e.
- Two earlier `make test` runs piped into `grep` hung with `nvim` asleep; with stdin from `/dev/null` every run finishes, so tests are now run that way.

## Left alone

The plugin doesn't back up or migrate the unreadable file; the user decides what to do with it. BUG-0270, a write that fails partway, is a separate defect.
