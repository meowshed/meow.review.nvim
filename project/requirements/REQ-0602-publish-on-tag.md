---
id: REQ-0602
artifact: requirement
topic: release
class: functional
status: approved
revised: 2026-09-27
elaborates: RES-0010
verification: behavioural
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0602

When a release tag `vX.Y.Z` is pushed, the release, built from the commit the tag points to, MUST be published to luarocks.org with no manual step, unless the check REQ-0601 requires fails or the version already exists as REQ-0605 describes.

Publishing from the tag builds the release from the tagged commit, and no release depends on one maintainer's machine (RES-0010, conclusion 3). An approval gate before the publishing job runs is not a manual step in this sense; that is a default chosen here. A real publish can't be repeated, because REQ-0605 forbids republishing a version, so the check is the first tagged release after the change, watched end to end, with the parts before the upload exercised on pull requests. Publishing from CI was asked for by the maintainer on 2026-09-27.

## Open review findings

- The reviewer found that this requirement settles what RES-0010 left to
  the design step, whether to publish from CI at all. Kept: the maintainer
  asked for CI publishing on 2026-09-27, which the requirements step records
  as an outside instruction (Q6), so the design step chooses how, not
  whether. The instruction was given in the working session that produced
  this record and is recorded here and in REQ-0604; no separate record holds
  it.
