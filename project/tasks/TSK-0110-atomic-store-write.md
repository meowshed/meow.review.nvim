---
id: TSK-0110
artifact: task
status: approved
revised: 2026-09-28
bug: BUG-0270
closes: [REQ-0200]
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Write the store atomically so a failed save keeps the old file

Restores REQ-0200: a save that fails partway, for example on a full disk, leaves the old store file whole and reports the failure.

## Acceptance criteria

1. Given a store file and a write that fails partway, when an annotation is added, then the store file keeps its old contents and nothing raises. Closed by: the test "keeps the old file when a write fails partway (BUG-0270)".
2. Given a working disk, when an annotation is added, then it is saved. Closed by: the test "saves again once the store loads cleanly".

## What to do

In `save()` in `lua/meow/review/store.lua`, write `<store>.tmp`, check the results of `write` and `close`, and rename it over the store file only when both succeed; on any failure remove the temporary file, keep the old one, and report the error.

## Depends on

None.

## Evidence

Collected at commit `380e32e`, tree `df88f37c0e45`.

- Seen failing first: with the new test and the old code, the store file was left as `''` after the failed write.
- After the fix, all 115 tests pass.
- `meow-verbs evidence format lint check test build`, exit 0:
  format passed, record 2037e287a3a3, current at tree df88f37c0e45;
  lint passed, record 3c7bd6ec55a1, current at tree df88f37c0e45;
  check passed, record e3cb5b66642b, current at tree df88f37c0e45;
  test passed, record d224c93e4cd1, current at tree df88f37c0e45;
  build passed, record 87e0024f3838, current at tree df88f37c0e45.

## Left alone

A crash between the write and the rename leaves a stray `<store>.tmp`, which the next save overwrites; the store file itself is never partial.
