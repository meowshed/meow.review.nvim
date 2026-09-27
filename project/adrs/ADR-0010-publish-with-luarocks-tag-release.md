---
id: ADR-0010
artifact: adr
status: draft
revised: 2026-09-27
addresses: [REQ-0600, REQ-0601, REQ-0602, REQ-0603, REQ-0604, REQ-0605]
supersedes: []
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# 0010. Publish each tagged release to LuaRocks with luarocks-tag-release, from a committed scm rockspec, behind a content check

## Decision

A workflow, `.github/workflows/release.yml`, publishes meow.review.nvim to
luarocks.org when a tag `vX.Y.Z` is pushed. It has two jobs, and the second
runs only if the first passes.

1. `check` builds the rock at the tagged commit from the committed
   `meow.review.nvim-scm-1.rockspec`, installs it into a temporary tree, and
   fails unless the installed files include `plugin/meow-review.lua`
   (REQ-0601). It then runs `luarocks search meow.review.nvim X.Y.Z` and
   fails if any revision of `X.Y.Z` is already on luarocks.org (REQ-0605).
   The same job, without the search, runs on every pull request through a
   `pull_request` trigger in `release.yml`, so a rockspec change that drops
   `plugin/` fails before it is merged.
2. `publish` runs only on a pushed `v*` tag, and runs
   `lumen-oss/luarocks-tag-release` pinned to the commit
   `4aa641e8e4befe0617fa3d7db40dbda832ddd27b` (release `v7.3.0`, named in a
   comment), because a tag can be moved and a commit can't, so the action's
   code changes only when the pin is moved in a reviewed change, with
   `template: meow.review.nvim-scm-1.rockspec`, `fail_on_duplicate: true`,
   and `LUAROCKS_API_KEY` from the repository secret of that name (REQ-0604).
   The action strips the `v` from the tag to form the version (REQ-0603),
   publishes rockspec revision `1`, and builds from the tagged commit
   (REQ-0602).

The committed `meow.review.nvim-scm-1.rockspec` is a dual-purpose template:
loaded directly it is a development rockspec, and filled in by the action it
is the release rockspec. It declares `nui.nvim` as a dependency and
`copy_directories = { "plugin", "doc" }`, so every rock built from it
installs both (REQ-0600). `make build` builds this rockspec instead of the newest versioned one, so
the CI `build` job and local builds exercise the same template the action
publishes on every push.

Releases stop committing a versioned rockspec. The release commit changes
`CHANGELOG.md` only, and the tag triggers the publish. The three existing
versioned rockspecs stay in the repository as the record of what was
published.

Rockspec revisions are always `1`. A packaging fix, such as the one BUG-0310
needs, ships as a new patch version, `v0.2.2`, because REQ-0605 refuses a
second revision of a published version.

Once this is accepted and implemented, pushing a `vX.Y.Z` tag publishes a
rock that includes `plugin/` and `doc/`, and the release after it closes
BUG-0310 for new installs. What still doesn't work: versions 0.1.0 to 0.2.1
stay broken on luarocks.org, because REQ-0605 forbids replacing them; a
rocks.nvim user has to upgrade to get the fix.

## Why

- The action copies `plugin/` and `doc/` when told to, and a committed
  template makes that part of the reviewed source rather than CI output
  (RES-0010, Findings 5, 7).
- The action's own test only installs and removes the rock (RES-0010,
  Finding 11), so the content check has to be a job of our own, and it can
  only build the same rockspec the action publishes if that rockspec is a
  template in the repository (RES-0010, Finding 11).
- `fail_on_duplicate` fails only on the server's "already exists" error for
  the same version and revision (`lua/luarocks-tag-release.lua`, read
  2026-09-27), so REQ-0605's "any revision" needs the explicit search.
- Publishing from the tag builds from the tagged commit and needs no
  maintainer's machine (RES-0010, Finding 6).

## Alternatives

| Option | Better at | Why it lost |
| ------ | --------- | ----------- |
| Do nothing: publish by hand | No secret to manage and nothing new in CI (RES-0010, Finding 13) | Breaks REQ-0602, which requires a publish with no manual step; leaves the next release as broken as 0.2.1 unless someone remembers `copy_directories` |
| `luarocks upload` of a committed versioned rockspec in a tag workflow | Keeps the release form CLAUDE.md records; no third-party action; the published rockspec is exactly the reviewed file (RES-0010, Finding 9) | It avoids the chosen option's two risks: no third-party action in the release path, and no template filled in by CI that nobody reviewed. The content check and a one-line version check would cover its errors as well, so what remains is one hand-written rockspec per release against a pinned third-party action. It lost on that preference, because the chosen option derives the version and the directories from the tag and one reviewed template; see What would reverse it. |
| luarocks-tag-release with its built-in template | Least to maintain: no rockspec in the repository at all (RES-0010, Finding 7) | The rockspec is generated inside the publish step, so no earlier job can build and check it, which REQ-0601 requires (RES-0010, Finding 11); `nui.nvim` would live in workflow inputs |

## What it costs

- A third-party action, pinned to a commit, sits in the release path; an
  outage stops releases. The maintainer moves the pin, prompted by a
  Dependabot pull request for the `github-actions` ecosystem, which this
  decision adds in `.github/dependabot.yml`; without that prompt the pin
  would never move.
- The release form in CLAUDE.md changes: no rockspec per release. The
  maintainer keeps the scm rockspec correct, and the `check` job on every pull
  request tells them when it isn't.
- A LuaRocks API key has to be created and stored as a repository secret by
  the maintainer before the first tagged release; until then the publish job
  fails on every tag.
- Users on 0.1.0 to 0.2.1 through rocks.nvim keep a broken rock until they
  upgrade.

The maintainer does one more thing when the key is revoked or lost
(re-adding it) and one less thing per release (writing and uploading a
rockspec).
If nobody attends to a failed publish for a month, the tag stays unpublished
and nothing else breaks; the failure is the workflow run's red status on the
tag, seen by whoever pushed it.

## What would reverse it

- `luarocks-tag-release` stops accepting a repository template, or is
  archived without a maintained successor.
- rocks.nvim stops reading a rock's `plugin/` directory, so `copy_directories`
  no longer matters to users.
- The maintainer drops rocks.nvim as a documented install path.
- A tagged release fails, or the pin has to move for a breaking change,
  because of the action more than once in a year; then a committed
  rockspec with `luarocks upload` is the cheaper option.

## Consequences

- New files: `.github/workflows/release.yml`, `.github/dependabot.yml` and
  `meow.review.nvim-scm-1.rockspec`. Changed: `Makefile` (`build` uses the
  scm rockspec) and `CLAUDE.md` (the release principle). README.md doesn't
  describe releasing and doesn't change. The `.src.rock` files in the
  repository root are ignored by git and not part of the repository.
- A new repository secret, `LUAROCKS_API_KEY`, set by the maintainer.
- BUG-0310 is fixed for the next release, `v0.2.2`, which the implementation
  work should end with.
- The epic for this decision realises it and ends with the first release.

## How I will know it was realised

1. A pull request that removes `plugin` from `copy_directories` in the scm
   rockspec fails the `check` job.
2. Pushing `v0.2.2` publishes `meow.review.nvim 0.2.2-1` to luarocks.org, and
   `luarocks install meow.review.nvim 0.2.2-1` into an empty tree installs
   `plugin/meow-review.lua`.
3. Re-running the workflow for `v0.2.2` fails at the duplicate search and
   leaves `0.2.2-1` unchanged.
4. No file in the repository contains the API key's value; the workflows
   name only `secrets.LUAROCKS_API_KEY`.
5. The published `meow.review.nvim-0.2.2-1.rockspec` names `v0.2.2` in its
   `source`, not the `main` branch.

## What this does not settle

- How versions and tags are chosen, and whether a release is automated
  beyond pushing the tag.
- The GitHub release page and release notes.
- Whether the published 0.1.0 to 0.2.1 rocks should be marked or announced as
  broken.
- Whether the key should also be removed from the maintainer's machine, or
  job logs checked for it (REQ-0604's open findings).
- A protected environment with required approval for the publish job;
  REQ-0602 allows one, and this decision doesn't add it.

## The strongest objection

The duplicate search and the upload are two steps, so two runs for the same
version at once could both pass the search and race to upload. It can happen when a tag is deleted and pushed again, or an old run is re-run alongside a new one. The server still refuses the second
upload of the same revision, and `fail_on_duplicate` fails that run, so the
worst case is one red run, not a replaced rock.

## Premortem

It is six months later and the publish failed. Someone moved the action's
pin to a newer release that changed how `$is_release` templates are filled;
the release rockspec kept the scm source URL, and the rock installed the
`main` branch. The content check still passed, because `plugin/` was there.
The pin makes that change a reviewed one, and realisation check 5 catches it
at the first release after the move; a check job that fills the template
itself would catch it before the upload, and is the next guard to add if the
pin moves often.
