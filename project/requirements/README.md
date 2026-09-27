# Requirements

<!-- meow-flow index -->

21 requirements in all: 21 approved.

| Identifier | What it requires | Status |
| --- | --- | --- |
| [REQ-0100](REQ-0100-neovim-0-11.md) | The plugin MUST run on Neovim 0.11.0 or later. | approved |
| [REQ-0101](REQ-0101-nui-only-dependency.md) | The plugin MUST load and run its commands with nui.nvim as its only other plugin installed. | approved |
| [REQ-0102](REQ-0102-no-default-mappings.md) | The plugin MUST leave every key mapping outside its own popup windows to the user. | approved |
| [REQ-0103](REQ-0103-setup-repeatable.md) | Calling `setup()` a second time MUST leave the plugin in the state one call with both calls' options merged would give. | approved |
| [REQ-0104](REQ-0104-annotation-types-replace.md) | When the user gives a non-empty `annotation_types`, its keys MUST be the only active annotation types. | approved |
| [REQ-0105](REQ-0105-plug-mapping-per-action.md) | For every `:MeowReview` subcommand, the plugin MUST offer a `<Plug>(MeowReview…)` mapping that does the same thing. | approved |
| [REQ-0200](REQ-0200-survive-restart.md) | Annotations MUST survive a restart of Neovim. | approved |
| [REQ-0201](REQ-0201-store-path-resolution.md) | The store MUST resolve a relative `store_path` against the project root and use an absolute one as given. | approved |
| [REQ-0202](REQ-0202-gitignore-prompt.md) | When `auto_gitignore` is `"prompt"`, the plugin MUST ask the user once before it adds the store file to `.gitignore`. | approved |
| [REQ-0300](REQ-0300-export-omits-resolved.md) | Export MUST leave resolved annotations out. | approved |
| [REQ-0301](REQ-0301-export-and-clear-keeps-store.md) | `export_and_clear` MUST leave the store unchanged when the export fails. | approved |
| [REQ-0302](REQ-0302-parseable-heading.md) | The Markdown export MUST head each annotation `[TYPE] file — location — symbol`, so an AI agent can parse it. | approved |
| [REQ-0400](REQ-0400-pick-overlapping.md) | When several annotations cover the cursor, edit, delete and view MUST let the user pick which one to act on. | approved |
| [REQ-0500](REQ-0500-follow-edits.md) | When lines are inserted or deleted above an annotation, its whole range MUST move with the text it was left on, for its sign and for every operation that finds an annotation by position: goto, next, prev, edit, delete, view and resolve. | approved |
| [REQ-0501](REQ-0501-stale-detection.md) | `validate()` MUST mark an annotation stale when its file is gone, its line is past the end of the file, or its snippet no longer matches the file. | approved |
| [REQ-0600](REQ-0600-rock-ships-runtime-dirs.md) | Every rock built for release MUST install `plugin/` and `doc/` along with the Lua modules. | approved |
| [REQ-0601](REQ-0601-check-rock-before-publish.md) | A rock MUST be published only after a rock built at the commit the release tag names, from the rockspec that is published or the template it is generated from, has been installed and its installed files checked to include `plugin/meow-review.lua`. | approved |
| [REQ-0602](REQ-0602-publish-on-tag.md) | When a release tag `vX.Y.Z` is pushed, the release, built from the commit the tag points to, MUST be published to luarocks.org with no manual step, unless the check REQ-0601 requires fails or the version already exists as REQ-0605 describes. | approved |
| [REQ-0603](REQ-0603-version-matches-tag.md) | The version part of the rock published to luarocks.org for a tag `vX.Y.Z` MUST be `X.Y.Z`. | approved |
| [REQ-0604](REQ-0604-api-key-as-secret.md) | The LuaRocks API key MUST appear in the repository, including the publishing workflow, only as a reference to a CI secret. | approved |
| [REQ-0605](REQ-0605-no-republish.md) | When any rockspec revision of the version `X.Y.Z` being published already exists on luarocks.org, the publishing workflow run MUST fail and leave the published files unchanged. | approved |
<!-- /meow-flow index -->
