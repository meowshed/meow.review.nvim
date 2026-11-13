---
id: BUG-0320
artifact: bug
status: approved
severity: major
violates: REQ-0105
enters: implement
found: 2026-11-13
revised: 2026-11-13
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# `<Plug>(MeowReviewAdd)` in visual mode annotates the previous selection, not the current one

## Reproduction

Reproduced on 2026-11-13 with Neovim 0.12.6 at commit `5d25397`, in the
meowvim configuration, which maps `<leader>ra` to `<Plug>(MeowReviewAdd)` in
visual mode, and in the test "reads the selection while visual mode is still
active (BUG-0320)".

1. Open a file with five lines and put the cursor on line 2.
2. Press `Vjj` to select lines 2 to 4.
3. Press the key mapped to `<Plug>(MeowReviewAdd)`.

## What the system does

The add modal opens for the line range the `'<` and `'>` marks held before
step 2: the previous selection in this buffer, or the cursor line when there
was none. The mapping's callback runs while visual mode is still active, and
Neovim sets those marks only when visual mode ends, so `add_comment()` reads
stale marks. The comment above the mapping assumed the opposite.

## What it should do, and why

The modal should open for lines 2 to 4, because `:'<,'>MeowReview add` does,
and REQ-0105 requires each `<Plug>` mapping to do what its subcommand does.

## Triage

Enters at implement, because it violates REQ-0105. Major: annotating a range
from the keyboard is the main use of the visual mapping, and the wrong range
is saved silently. A configuration can work around it by leaving visual mode
before calling `add_comment(true)`, which meowvim does.

## Closed by

`add_comment()` reads the live selection from `line("v")` and `line(".")`
when visual mode is active, orders the two lines, and leaves visual mode
before it opens the modal. The `'<` and `'>` marks are still used when it's
called after visual mode ended. The tests "reads the selection while visual
mode is still active (BUG-0320)" and "orders the lines of a selection made
upwards" failed before the change and pass after it, with all 118 tests
passing.
