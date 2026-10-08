# Assessment 2 — i.c.stars Milwaukee, Molson Cycle 21

**Author:** Carl Lewis · **Date:** 2026-10-08
**Repo:** [`icstars-milwaukee/icstars-rfp-molson-cycle21-carl-`](https://github.com/icstars-milwaukee/icstars-rfp-molson-cycle21-carl-)

| Task | Standards | Artifact | Folder |
| --- | --- | --- | --- |
| **Task 1** — Agile Backlog Refinement | AG.SK2, AG.SK3, AG.SK5 | Refined backlog: 2 sprint-ready stories, 6 tasks, estimates, owners | [`task-1/`](task-1) |
| **Task 2** — SDLC Diagram | SD.KU1, SD.SK1, SD.SK2 | Annotated swimlane diagrams: Waterfall vs. Agile, 6 phases, project connection | [`task-2/`](task-2) |
| **Task 3** — Test Plan + Defect Log | QA.SK1, QA.SK2 | Test plan with 5 Given/When/Then cases + defect log with DEF-001 | [`task-3/`](task-3) |

## The three tasks are one continuous thread

They are deliberately not independent exercises — each one consumes the output of the last, which is what an actual sprint looks like:

```
Task 1                     Task 3                      Task 2
rough stories      →       acceptance criteria   →     the whole loop,
refined into               become executable           diagrammed and
STORY-101 with             test cases; TC-002          compared against
acceptance criteria        catches DEF-001             Waterfall
```

- `STORY-101` is refined in **Task 1**.
- Its acceptance criteria become `TC-001`–`TC-005` in **Task 3**, and `TC-002` catches `DEF-001`, a Severity-1 authentication bypass.
- **Task 2** maps that same sequence onto the SDLC and shows why finding `DEF-001` inside the sprint — rather than in a Waterfall testing phase months later — is the point of working this way.

## Supporting GitHub scaffolding

| Path | Purpose |
| --- | --- |
| [`../.github/ISSUE_TEMPLATE/user-story.md`](../.github/ISSUE_TEMPLATE/user-story.md) | Enforces role/goal/reason, acceptance criteria, and the Definition of Ready on every new story |
| [`../.github/ISSUE_TEMPLATE/task.md`](../.github/ISSUE_TEMPLATE/task.md) | Enforces one owner and an hour estimate on every task |
| [`../.github/ISSUE_TEMPLATE/bug_report.md`](../.github/ISSUE_TEMPLATE/bug_report.md) | Enforces the defect-log fields so no defect is filed missing severity, steps, or expected vs. actual |
| [`task-1/create-issues.sh`](task-1/create-issues.sh) | Loads the refined backlog into GitHub as labeled issues (dry-run by default) |

The templates exist because the assessment's listed common errors — vague stories, missing acceptance criteria, no estimates, defects missing critical fields — are all preventable at the point of filing rather than caught in review.
