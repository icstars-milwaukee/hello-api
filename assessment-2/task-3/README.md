# Assessment 2 — Task 3: Test Plan + Defect Log

**Standards covered:** QA.SK1, QA.SK2
**Author:** Carl Lewis · i.c.stars Milwaukee · Molson Cycle 21
**Date:** 2026-10-08

## Standard → evidence map

| Standard | What it asks for | Where it lives |
| --- | --- | --- |
| QA.SK1 | Translate requirements into test cases | [`test-plan.md`](test-plan.md) — 5 Given/When/Then cases, each with a traceability row back to the requirement |
| QA.SK2 | Log and track defects systematically | [`defect-log.md`](defect-log.md) — `DEF-001` and `DEF-002` with full fields, severity/priority, status history, and verification |

## Requirement under test

> **REQ-01:** A user can log in with email + password and see the dashboard.

This is the same requirement as `STORY-101` in [Task 1's refined backlog](../task-1/refined-backlog.md) — the test cases here were written from those acceptance criteria, which is the point: criteria written in Given/When/Then convert into test cases almost mechanically.

## Files in this folder

| File | Purpose |
| --- | --- |
| `templates/test-case-template.md` | The **setup** — blank test case template |
| `templates/defect-log-template.md` | The **setup** — blank defect log template |
| `test-plan.md` | The **artifact** — scope, approach, environment, 5 test cases, execution summary, traceability matrix |
| `defect-log.md` | The **artifact** — the defect log, with `DEF-001` ("Login accepts wrong password") logged in full |
| `defect-log.csv` | Same log in flat form for import into a tracker |

A matching GitHub bug-report template lives at [`.github/ISSUE_TEMPLATE/bug_report.md`](../../.github/ISSUE_TEMPLATE/bug_report.md), so defects filed as issues carry the same required fields as the log.

## Proficiency check

- [x] **At least 3 test cases tied to the requirement** — 5 cases, each with an explicit `REQ-01 / AC` traceability reference
- [x] **One defect logged with details** — `DEF-001` with reproduction steps, expected vs. actual, severity, priority, environment, build, owner, evidence, and verification; `DEF-002` included to show the log tracking more than one item through different statuses
- [x] **Captured in the provided template** — both artifacts follow the blank templates in `templates/`
