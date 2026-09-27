---
id: onboarding
artifact: onboarding
status: approved
revised: 2026-09-27
---

<!-- Written to the writing standard meow-prose ships: lead with what was found, give each figure its source, and state a gap as plainly as a finding. -->

# Onboarding meow.review.nvim

This report states what meow.review.nvim already is, from its documentation,
its harness, its code and its GitHub history, and lists what I couldn't
determine. It records
the vision, six specifications and 15 draft requirements taken from the
documents. It records no decision, because no document, issue or pull request
records a choice together with the alternative it rejected.

## Verbs

All five verbs resolve, from `meow-verbs status` on 2026-09-27:

| Verb   | Command            | Source                  |
| ------ | ------------------ | ----------------------- |
| format | `make format-check` | `.meowpaw/profile.toml` |
| lint   | `make lint`         | `.meowpaw/profile.toml` |
| check  | `make check`        | `.meowpaw/profile.toml` |
| test   | `make test`         | `.meowpaw/profile.toml` |
| build  | `make build`        | `.meowpaw/profile.toml` |

All five passed on the working tree at commit `fb36434` (`meow-verbs
evidence`, exit 0, tree `8990fd271602`), and CI passed all six jobs on
`fb36434`.

## Conventions

Each of these is what the repository does now, offered as a decision to take:

- Commit subjects: 46 of 46 have the form `type(scope): summary`, and 46 of 46
  are 72 characters or fewer (`git log`). Both became true on 2026-09-27, when
  the history was rewritten: of the 40 commits it rewrote, 8 had longer
  subjects, and the merge from PR #1 had GitHub's default subject. The other 6
  commits came after the rewrite. Adopt both as rules?
- Types: `feat`, `fix`, `perf`, `refactor`, `docs`, `ci`, `chore` and
  `release` appear. `.meowpaw/profile.toml` declares `perf` as a patch and the
  others except `feat` and `fix` as no release, and those values were chosen
  at init, not taken from the history. Keep them?
- Signatures: 6 of 46 commits are signed, all from 2026-09-27; 40 are not
  (`git log --format=%G?`). `require_signatures` is false. Require them from
  now on?
- Branching: 44 of 46 commits were made on `main` directly, and 2 arrived
  through PR #1 (the contributor's commit and its merge). The meow-git
  plugin's hook, active on this machine since 2026-09-27, refuses commits on
  `main`; the 6 commits since then were made on a branch and fast-forwarded
  onto `main` at the maintainer's request. Keep the hook and require pull
  requests?
- Licence headers: 23 of 23 Lua files carry the MIT header and the `@file:`
  and `@brief:` tags, 10 of them since 2026-09-27. Keep it as a rule?
- Releases: 2 of 2 tags (`v0.2.0`, `v0.2.1`) point at a `release: vX.Y.Z`
  commit that adds a rockspec. Version 0.1.0 has a rockspec but no tag and no
  release commit. Keep the release form?
- Changelog: `CHANGELOG.md` follows Keep a Changelog and records all three
  releases. Keep it as the release notes?

## Documents

| Document | Outcome | Where, or why |
| -------- | ------- | ------------- |
| `README.md` | cited | The user guide; the vision, SPC-0010 to SPC-0060 and the requirements cite it, and it stays the user-facing document |
| `doc/meow-review.txt` | cited | The Neovim help file, which the plugin ships; the specifications and requirements cite it |
| `CHANGELOG.md` | cited | Release notes the plugin publishes; the specifications cite it |
| `CLAUDE.md` | cited | The constitution, written at init; onboarding leaves it as it is |
| `LICENSE` | cited | The licence, which the package needs |
| `meow.review.nvim-0.1.0-1.rockspec` | cited | The package for 0.1.0, which LuaRocks may still serve |
| `meow.review.nvim-0.2.0-1.rockspec` | cited | The package for 0.2.0 |
| `meow.review.nvim-0.2.1-1.rockspec` | cited | The package for 0.2.1, which `make build` builds |
| `.cache/meow-review/annotations.json` | cited | Review data the plugin wrote, not a document; held until gap 12 is answered, and this row changes to match the answer before `paw onboarding remove` runs |

## Gaps

Each is a question for the maintainer.

1. Commits cite issues #1 to #14, and `meow-github history` finds no issue in
   `retran/meow.review.nvim`, only PR #1 (a different change). Where do those
   issues live, for example `retran/meow`, and should they be read for
   requirements and decisions?
2. What does meow.review.nvim replace or compete with, and why wasn't that
   enough? No document names an alternative, so the vision can't say.
3. What does a reviewer do today without the plugin? The vision's audience
   table needs it.
4. Which quality goals matter, and in what order? None is stated.
5. What won't the plugin do? No document states a non-goal.
6. Which dependencies between the parts are permitted? The code routes
   everything through `init.lua`, but nothing states it as a rule.
7. What is the default of `export_filename`? `doc/meow-review.txt` says
   `.cache/meow-review/review.md`; README.md and
   `lua/meow/review/config/internal.lua` say `.review.md`.
8. Is the store still `.meow-review.json` anywhere?
   `doc/meow-review.txt:54`, `doc/meow-review.txt:713`,
   `lua/meow/review/init.lua:458` and `plugin/meow-review.lua:329` name it,
   while the default has been `.cache/meow-review/annotations.json` since
   0.2.0 (CHANGELOG.md).
9. What counts as a failed export for REQ-0301? Today `export_and_clear`
   clears the store when `file_prompt` opens its prompt, so cancelling loses
   every annotation, and when `file` or `file_prompt` can't open its path, or
   the `json` formatter can't encode, so those errors lose them too
   (SPC-0030). If a cancel and a write error count as
   failures, both are defects against REQ-0301; if not, REQ-0301 needs to say
   so.
10. Should `export_and_clear` clear resolved annotations, which the export
    leaves out? It clears everything today.
11. When the store file has an unknown version, should the next change
    overwrite it? It loads as empty with a warning, and the next save
    replaces the file.
12. Should `.cache/meow-review/annotations.json` be in the repository? It was
    committed in `2d724d1`, while the plugin's `auto_gitignore` exists to keep
    it out.
13. Was the move of the store from `.meow-review.json` to `.cache/meow-review/`
    a decision with a rejected alternative? CHANGELOG.md records the change,
    not the reason.
14. Was replacing `rhysd/action-setup-vim` in `226852f` and restoring it in
    `4211651` a decision to record? Only the commit subjects state it.
15. The picker tries snacks.nvim, then telescope.nvim, then fzf-lua, then
    nui.menu. Is that order a decision, and what did it reject?
16. The licence headers say "Copyright (c) 2025", while the first commit is
    dated 2026-04-12. Which year is right?
17. Should `0.1.0` get a tag, so every rockspec's `source.tag` resolves?
18. `paw check` reports the index of each research, epic and defect as
    missing or out of date: specifications, epics and defects share one index
    block in `project/README.md`, and `paw index --write` writes each kind
    into the same block. Is that a defect in `paw`?
19. Why does each requirement hold? No document gives a reason for any of
    REQ-0100 to REQ-0501, and each carries the question under
    `## Open review findings`.
20. Should lines added above an annotation mark it stale? `snippet_start`
    doesn't move with edits while `lnum` does, so they can (SPC-0050).
21. What does a repeat `setup()` call do with options the first call set?
    The deep merge unions `annotation_types`, against REQ-0104, combines
    lists index by index, and leaves an exporter registered after it is
    added to `disabled_exporters` (SPC-0010).
22. Does REQ-0200 cover a killed Neovim as well as a clean exit?
23. What is "ask once" in REQ-0202 counted over: per store file, per session
    or for ever? The plugin asks after every write today (SPC-0020).
24. Should export pass through the store's `include_resolved` opt-in?
    README.md says resolved annotations are left out "by default", and
    export offers no way to include them.
25. What exact heading grammar does REQ-0302 promise: the location forms,
    the optional symbol, and whether ` — ` may appear in a path?
26. What does "snippet no longer matches" mean in REQ-0501: the whole snippet
    or its first line? Is the empty-line exemption intended? Must an
    annotation meeting no condition stay not stale? Should `validate()`
    exempt hunk annotations as sign drawing does (SPC-0050)?
27. Should a store write be atomic? A write that fails after the file opens
    leaves it empty or partial and reports nothing (SPC-0020).
28. Should resolve at the cursor offer a picker when several annotations
    share the line, as REQ-0400 asks of edit, delete and view? It acts on
    the first today (SPC-0040).
29. Should context capture carry a requirement? No document states one, so
    SPC-0060 rests on none.
30. Where is the plugin going? The vision's direction is not stated.

## Adoption

The steps that bring the repository into the method, each leaving it working:

1. Approve or amend the vision, the six specifications and the 15 draft
   requirements. Once approved, the specifications rest on requirements in
   force, and `paw check coverage` stops reporting them.
2. Answer the gaps. Gaps 2 to 5 and 30 amend the vision. Gaps 19, 21 to 26 and 28
   amend the requirements they name, and gap 29 adds one. Gaps 7 to 12, 16, 17, 20 and 27 become
   defect records here where the answer confirms a defect. Gaps 6 and 13 to 15
   become decisions where the answer names a rejected alternative. Gap 1
   decides whether another repository's issues are read. Gap 18 is filed
   against `paw`, not here.
3. Set the `.cache/meow-review/annotations.json` row to match the answer to
   gap 12, approve this report, and run `paw onboarding remove`. Every other
   document is marked cited, so nothing else is removed, and the record
   becomes the place new requirements and decisions go.
4. Take the next change through `/meow-flow:run`, starting from a defect
   record, so the first epic proves the method on a small fix.

## Open review findings

- Rejected: the reviewer read `doc/meow-review.txt:221` as a second default
  for `export_filename`. That line is inside an example configuration, so
  gap 7 cites only line 180.
- Rejected: the reviewer asked for a `held` outcome on the
  `.cache/meow-review/annotations.json` row. The report allows only
  migrated, cited, superseded or discarded, so the row stays cited, and
  adoption step 3 changes it to match gap 12 before anything is removed.
- Rejected: the reviewer asked to delete the comment under the front matter.
  The onboarding template puts it there.
