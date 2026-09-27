---
id: REQ-0604
artifact: requirement
topic: release
class: functional
status: draft
revised: 2026-09-27
elaborates: RES-0010
verification: static
---

<!-- Written to the writing standard meow-prose ships: lead with the answer, give each rule its reason in the same sentence, and show the failing case. -->

# REQ-0604

The LuaRocks API key MUST appear in the repository, including the publishing workflow, only as a reference to a CI secret.

Anyone holding the key can publish as the maintainer, so the repository carries the secret's name and never its value (RES-0010, conclusion 5). Publishing from CI was asked for by the maintainer on 2026-09-27.

## Open review findings

- The reviewer noted that a copy of the key probably exists on the
  maintainer's machine, from the manual uploads, and that a key can still be
  printed in a job log. Neither is something this requirement's static check
  can see; if either should be required, it needs its own requirement.
