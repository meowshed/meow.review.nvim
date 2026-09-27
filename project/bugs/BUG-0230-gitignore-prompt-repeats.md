---
id: BUG-0230
artifact: bug
status: approved
severity: major
violates: REQ-0202
enters: implement
found: 2026-09-27
revised: 2026-09-27
issue:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# `auto_gitignore = "prompt"` asks again after every write

## Reproduction

Seen at commit `92e119c` on `main`, by reading the code and documents during onboarding (onboarding gap 23). The steps below have not been run yet.

1. Use a project whose `.gitignore` doesn't list the store.
2. Add an annotation and pick Dismiss.
3. Add another annotation.

## What the system does

The prompt appears again after every write, because a dismissal isn't remembered (SPC-0020).

## What it should do, and why

The plugin should ask once, as README.md and REQ-0202 say.

## Triage

Enters at implement, because it violates REQ-0202. Major, because it interrupts every change.

## Closed by

Not closed.
