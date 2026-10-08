# Blank Defect Log Template (setup)

## Summary table — one row per defect

| ID | Title | Severity | Priority | Status | Found in | Reported by | Owner | Date found | Linked test case |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DEF-000 | | | | | | | | | |

## Detail block — one per defect

### DEF-000 — <title: what is wrong, stated as a fact>

| Field | Value |
| --- | --- |
| Severity | 1 Critical / 2 Major / 3 Minor / 4 Trivial — *impact if it ships* |
| Priority | P1 / P2 / P3 — *how soon we fix it* |
| Status | New → Triaged → In Progress → Fixed → Verified → Closed (or Reopened / Won't Fix / Duplicate) |
| Reported by | |
| Date found | |
| Owner | |
| Environment | OS, browser + version, device |
| Build / commit | |
| Linked requirement | REQ-00 / AC <n> |
| Linked test case | TC-000 |
| Linked story | STORY-000 |

**Steps to reproduce** — numbered, with literal test data, reproducible by someone who has never seen the bug:
1.
2.
3.

**Expected result:**
**Actual result:**
**Reproducibility:** Always / Intermittent (n of 10) / Once
**Evidence:** screenshot, log excerpt, request/response, test output
**Root cause:**
**Fix:**
**Verification:** who retested, when, on which build, and the result
**Regression guard:** the automated test added so this cannot silently return

---

## Severity vs. priority — they are not the same field

| | Meaning | Who decides |
| --- | --- | --- |
| **Severity** | How bad the impact is if it reaches users | QA |
| **Priority** | How soon it gets fixed relative to other work | Product owner |

A typo in the footer is Severity 4 but could be Priority 1 if it is on a press release. A crash in an unreleased admin tool is Severity 1 but may be Priority 3.

## Checklist before you file

- [ ] Title states the defect as a fact, not a guess ("Login accepts wrong password", not "login seems broken?")
- [ ] Steps reproduce it on a clean environment
- [ ] Expected **and** actual results both present
- [ ] Severity and priority both set, and distinct
- [ ] Environment and build recorded
- [ ] Linked to the requirement and test case that caught it
- [ ] Evidence attached
