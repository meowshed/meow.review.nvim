---
id: EPC-0020
artifact: epic
status: approved
revised: 2026-09-28
realises: ADR-0020
checked-at:
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# Renovate proposes every dependency update, and every action runs at a pinned commit

Realises ADR-0020.

## Acceptance criteria

1. The repository has `renovate.json` with the settings ADR-0020 names and
   no `.github/dependabot.yml`.
2. `grep -rn 'uses:' .github/workflows/` shows every action from another
   repository at a 40-character SHA with a `# vX.Y.Z` comment.
3. After TSK-0070 merges, Renovate's Dependency Dashboard issue exists, and
   the first release of an action after that is proposed as a pull request
   within seven days of the release.
4. The maintainer confirms Silent mode is off and "Require config file" is
   on in the Mend portal, and that Renovate is the tool across their
   accounts.
5. REQ-0700 to REQ-0703 each land in exactly one closed task.

## Marks

```text
[ ] not started   [>] in progress   [x] done, with evidence
[~] dropped, with the reason        [+] added after approval, with why
```

A task is marked in the commit that advances it, never in a later pass, so
the history shows the evidence and the change together; after a squash merge,
the squashed commit is that commit.

## Tasks

- [x] T-001 TSK-0060 Land `renovate.json` through pull request #10 and remove `.github/dependabot.yml`
      closes: REQ-0700, REQ-0703
      evidence: `df197cb` via #10; dashboard #11 created; the maintainer confirmed the Mend settings and REQ-0703
- [x] T-002 TSK-0070 Merge Renovate's digest-pinning pull request
      closes: REQ-0701
      evidence: `f977218` via #12; all 12 `uses:` lines at a SHA with `# vX.Y.Z`
      depends: TSK-0060 - Renovate proposes the pinning only once its config is on `main`
- [ ] T-003 TSK-0080 Show Renovate proposes an action release within seven days
      closes: REQ-0702
      depends: TSK-0070 - the proposal it waits for is a digest update to a pinned action

## Coverage

REQ-0700 and REQ-0703 land in TSK-0060, REQ-0701 in TSK-0070 and REQ-0702
in TSK-0080. The smallest set that tests the decision is TSK-0060 and
TSK-0070, which make Renovate the only tool and pin every action. TSK-0080
waits for the first release of an action after that, and stays open until
one happens, because a week with no release shows nothing about REQ-0702.

## Not covered

- A shared Renovate preset for the maintainer's repositories, which ADR-0020
  leaves open.
- Dependabot security updates, out of REQ-0700's scope.
