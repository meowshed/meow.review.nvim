---
id: EPC-0010
artifact: epic
status: approved
revised: 2026-09-27
realises: ADR-0010
checked-at:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Publish each tagged release to LuaRocks from CI, with a rock that ships `plugin/`

Realises ADR-0010, and ends with `v0.2.2` published by the new workflow,
which also closes BUG-0310 for new installs.

## Acceptance criteria

1. A pull request that removes `plugin` from `copy_directories` in the scm
   rockspec fails the `check` job.
2. Pushing `v0.2.2` publishes `meow.review.nvim 0.2.2-1` to luarocks.org, and
   `luarocks install meow.review.nvim 0.2.2-1` into an empty tree installs
   `plugin/meow-review.lua`.
3. Re-running the workflow for `v0.2.2` fails at the duplicate search and
   leaves `0.2.2-1` unchanged.
4. No file in the repository contains the API key's value; the workflows
   name the key only as `${{ secrets.LUAROCKS_API_KEY }}`.
5. The published `meow.review.nvim-0.2.2-1.rockspec` names `v0.2.2` in its
   `source`, not the `main` branch.
6. REQ-0600 to REQ-0605 each land in exactly one closed task.

## Marks

```text
[ ] not started   [>] in progress   [x] done, with evidence
[~] dropped, with the reason        [+] added after approval, with why
```

A task is marked in the commit that advances it, never in a later pass, so
the history shows the evidence and the change together; after a squash merge,
the squashed commit is that commit. A task that can run in parallel with its
neighbours carries `[P]` after its number, so whoever dispatches the tasks
knows which can run at once without conflicting edits.

## Tasks

- [x] T-001 TSK-0010 Add `meow.review.nvim-scm-1.rockspec` and build it with `make build`
      closes: REQ-0600
      evidence: `c578038`, `make build` installs `scm-1/plugin/meow-review.lua`; verbs passed at tree b5d327573a9f
- [ ] T-002 TSK-0020 Add the `check` job in `.github/workflows/release.yml`
      closes: REQ-0601
      depends: TSK-0010 - the check builds the template this task adds
- [ ] T-003 TSK-0030 Refuse a version already on luarocks.org in `check`
      closes: REQ-0605
      depends: TSK-0020 - the search is a step of the `check` job
- [ ] T-004 TSK-0040 Add the `publish` job, Dependabot and the new release principle
      closes: REQ-0604
      depends: TSK-0030 - both edit `release.yml`, and `publish` lands after `check` is complete
- [ ] T-005 TSK-0050 Release `v0.2.2` through the new workflow
      closes: REQ-0602, REQ-0603
      depends: TSK-0030, TSK-0040 - the release exercises the whole workflow; also the `LUAROCKS_API_KEY` secret

## Coverage

REQ-0600 lands in TSK-0010, REQ-0601 in TSK-0020, REQ-0605 in TSK-0030,
REQ-0604 in TSK-0040, and REQ-0602 and REQ-0603 in TSK-0050, whose check is
the first real release, as REQ-0602 says. No task runs in parallel: every
task after TSK-0010 edits `release.yml` or depends on one that does.
TSK-0050 also fills in BUG-0310's Closed by. The smallest set that tests the
decision is TSK-0010 and TSK-0020: once both are merged, `make build`
installs `plugin/meow-review.lua` and a pull request that drops it fails,
which is measurable before anything is published.

## Not covered

- The published 0.1.0 to 0.2.1 rocks stay broken, because REQ-0605 forbids
  replacing them; ADR-0010 leaves announcing that open.
- A protected environment with required approval for `publish`; REQ-0602
  allows one and ADR-0010 doesn't add it.
- The LuaRocks API key itself: the maintainer creates it and stores it as the
  `LUAROCKS_API_KEY` repository secret before TSK-0050. The project ships the
  workflow that reads it and depends on the maintainer for the key.
- luarocks.org accepting uploads and answering `luarocks search`, which
  criteria 2 and 3 depend on; the project doesn't control it.
- The key copy on the maintainer's machine and the key in job logs, which
  ADR-0010 leaves unsettled (REQ-0604's open findings); criterion 4 covers
  only the repository.
