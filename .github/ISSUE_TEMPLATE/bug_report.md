---
name: Bug report / defect
about: Log a defect with every field the defect log requires
title: "DEF-000: <what is wrong, stated as a fact>"
labels: ["bug"]
---

| Field | Value |
| --- | --- |
| Severity | 1 Critical / 2 Major / 3 Minor / 4 Trivial — *impact if it ships* |
| Priority | P1 / P2 / P3 — *how soon we fix it* |
| Status | New |
| Reported by | |
| Date found | |
| Owner | |
| Environment | OS, browser + version, device |
| Build / commit | |
| Linked requirement | REQ-00 / AC <n> |
| Linked test case | TC-000 |
| Linked story | STORY-000 |
| Reproducibility | Always / Intermittent (n of 10) / Once |

### Steps to reproduce

<!-- Numbered, with literal test data. Someone who has never seen this bug must be able to follow them. -->

1.
2.
3.

### Expected result

<!-- Quote the acceptance criterion it violates. -->

### Actual result

<!-- What actually happened, including status codes and observable state. -->

### Evidence

<!-- Screenshot, log excerpt, request/response pair, or failing test output. -->

### Root cause

<!-- Leave blank until investigated. Mark it clearly if it is still a hypothesis. -->

### Regression guard

<!-- The automated test that will fail on the broken build and pass on the fix. Required before this can be closed. -->

---

- [ ] Title states the defect as a fact, not a question
- [ ] Steps reproduce on a clean environment
- [ ] Expected **and** actual both filled in
- [ ] Severity and priority both set, and distinct
- [ ] Linked to a requirement and a test case
