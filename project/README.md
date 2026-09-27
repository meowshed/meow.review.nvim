# Record

The record of meow.review.nvim: its vision, specifications, epics and defects. Requirements and decisions keep their own indexes in `requirements/` and `adrs/`.

<!-- meow-flow index -->

11 specifications in all: 11 live.

| Identifier | What it concluded | Status |
| --- | --- | --- |
| [SPC-0010](specs/SPC-0010-plugin.md) | The plugin as a whole | live |
| [SPC-0020](specs/SPC-0020-annotation-store.md) | The annotation store | live |
| [SPC-0030](specs/SPC-0030-export.md) | Export | live |
| [SPC-0040](specs/SPC-0040-modals-and-picker.md) | Modals, view popup and picker | live |
| [SPC-0050](specs/SPC-0050-signs-and-staleness.md) | Signs, position tracking and stale detection | live |
| [SPC-0060](specs/SPC-0060-context-capture.md) | Context capture | live |
| [SPC-0070](specs/SPC-0070-annotation-types.md) | Annotation types | live |
| [SPC-0080](specs/SPC-0080-configuration.md) | Configuration | live |
| [SPC-0090](specs/SPC-0090-commands-and-navigation.md) | Commands, mappings, navigation and status | live |
| [SPC-0100](specs/SPC-0100-health-check.md) | Health check | live |
| [SPC-0110](specs/SPC-0110-release-and-publishing.md) | Release and publishing | live |
<!-- /meow-flow index -->










## Defects

Written by hand from `paw index defect`, because `paw index --write` writes every kind into the one generated block above (BUG-0180).


| Identifier | What it concluded | Status |
| --- | --- | --- |
| [BUG-0010](bugs/BUG-0010-missing-cited-issues.md) | Commits cite issues #1 to #14 that don't exist in this repository | approved |
| [BUG-0020](bugs/BUG-0020-vision-no-alternative.md) | The vision doesn't say what the plugin replaces or competes with | approved |
| [BUG-0030](bugs/BUG-0030-vision-no-current-practice.md) | The vision doesn't say what reviewers do today without the plugin | approved |
| [BUG-0040](bugs/BUG-0040-no-quality-goals.md) | No quality goals are stated | approved |
| [BUG-0050](bugs/BUG-0050-no-non-goals.md) | No non-goals are stated | approved |
| [BUG-0060](bugs/BUG-0060-module-dependencies-unstated.md) | The permitted dependencies between modules are unstated, and the store and signs call each other | approved |
| [BUG-0070](bugs/BUG-0070-vimdoc-export-filename-default.md) | doc/meow-review.txt gives the wrong default for `export_filename` | approved |
| [BUG-0080](bugs/BUG-0080-old-store-name-in-docs.md) | Documentation and comments still name the old store file `.meow-review.json` | approved |
| [BUG-0090](bugs/BUG-0090-export-and-clear-loses-annotations.md) | `export_and_clear` clears the store when the export wrote nothing | approved |
| [BUG-0100](bugs/BUG-0100-export-and-clear-drops-resolved.md) | `export_and_clear` clears resolved annotations that the export left out | approved |
| [BUG-0110](bugs/BUG-0110-unreadable-store-overwritten.md) | A store file that can't be read is overwritten by the next change | approved |
| [BUG-0120](bugs/BUG-0120-own-store-committed.md) | The plugin's own review store is committed to the repository | approved |
| [BUG-0130](bugs/BUG-0130-store-move-reason-unrecorded.md) | The move of the store to `.cache/meow-review/` has no recorded reason | approved |
| [BUG-0140](bugs/BUG-0140-ci-setup-vim-reason-unrecorded.md) | Replacing and restoring `rhysd/action-setup-vim` in CI has no recorded reason | approved |
| [BUG-0150](bugs/BUG-0150-picker-order-reason-unrecorded.md) | The picker fallback order has no recorded reason | approved |
| [BUG-0160](bugs/BUG-0160-licence-year.md) | The licence headers say 2025 while the project began in 2026 | approved |
| [BUG-0170](bugs/BUG-0170-missing-v0-1-0-tag.md) | The 0.1.0 rockspec names a tag that doesn't exist | approved |
| [BUG-0180](bugs/BUG-0180-paw-shared-index-block.md) | `paw index` writes every kind into the one index block of `project/README.md` | approved |
| [BUG-0190](bugs/BUG-0190-requirements-without-reasons.md) | No requirement states its reason | approved |
| [BUG-0200](bugs/BUG-0200-false-stale-after-edits.md) | Lines added above an annotation can mark it stale although its text is unchanged | approved |
| [BUG-0210](bugs/BUG-0210-repeat-setup-merge.md) | A second `setup()` call doesn't give the state one merged call would | approved |
| [BUG-0220](bugs/BUG-0220-restart-kind-unstated.md) | REQ-0200 doesn't say whether a killed Neovim counts as a restart | approved |
| [BUG-0230](bugs/BUG-0230-gitignore-prompt-repeats.md) | `auto_gitignore = "prompt"` asks again after every write | approved |
| [BUG-0240](bugs/BUG-0240-export-cannot-include-resolved.md) | Export can't include resolved annotations although the docs say they are left out only by default | approved |
| [BUG-0250](bugs/BUG-0250-heading-grammar-unstated.md) | REQ-0302 doesn't state the exact heading grammar it promises | approved |
| [BUG-0260](bugs/BUG-0260-stale-check-narrower-than-documented.md) | `validate()` checks less than the help file promises | approved |
| [BUG-0270](bugs/BUG-0270-store-write-not-atomic.md) | A failed store write leaves the file empty or partial and reports nothing | approved |
| [BUG-0280](bugs/BUG-0280-resolve-without-picker.md) | Resolve acts on the first annotation on the line without a picker | approved |
| [BUG-0290](bugs/BUG-0290-context-capture-no-requirement.md) | Context capture rests on no requirement | approved |
| [BUG-0300](bugs/BUG-0300-vision-no-direction.md) | The vision doesn't say where the plugin is going | approved |
| [BUG-0310](bugs/BUG-0310-rock-missing-plugin-dir.md) | The published rock doesn't install `plugin/meow-review.lua`, so rocks.nvim users likely get no commands or mappings | approved |

## Epics

Written by hand from `paw index epic`, for the same reason.


| Identifier | What it concluded | Status |
| --- | --- | --- |
| [EPC-0010](epics/EPC-0010-publish-to-luarocks-from-ci.md) | Publish each tagged release to LuaRocks from CI, with a rock that ships `plugin/` | draft |
