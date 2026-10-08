# Assessment 2 — Task 1: Agile Backlog Refinement

**Standards covered:** AG.SK2, AG.SK3, AG.SK5
**Author:** Carl Lewis · i.c.stars Milwaukee · Molson Cycle 21
**Date:** 2026-10-08

## Standard → evidence map

| Standard | What it asks for | Where it lives |
| --- | --- | --- |
| AG.SK2 | Break down user stories into tasks | [`refined-backlog.md`](refined-backlog.md) — Tasks tables under each story |
| AG.SK3 | Add estimates to tasks | [`refined-backlog.md`](refined-backlog.md) — Points + Hours columns, sprint capacity check |
| AG.SK5 | Refine backlog into sprint-ready items | [`refined-backlog.md`](refined-backlog.md) — Definition of Ready gate, acceptance criteria, owners |

## Files in this folder

| File | Purpose |
| --- | --- |
| `rough-user-stories.md` | The **input** — the unrefined stories handed to the team |
| `refined-backlog.md` | The **artifact** — 2 stories rewritten in role/goal/reason format, with acceptance criteria, 6 tasks, estimates, and owners |
| `sprint-1-backlog.csv` | Same backlog in flat form for import into GitHub Projects / Jira / Sheets |
| `create-issues.sh` | Optional: creates the stories and tasks as real GitHub issues via `gh` CLI |

## Refinement workflow used

1. **Pull** the two highest-value rough stories from the raw list.
2. **Rewrite** each as `As a [role], I want [goal], so that [reason]` — the *reason* clause is what makes the story testable for value, not just function.
3. **Add acceptance criteria** in Given / When / Then so QA can write tests before code exists.
4. **Decompose** into tasks that are each ≤ 1 day of work and independently verifiable.
5. **Estimate** in story points at the story level, hours at the task level.
6. **Assign an owner** per task — one name, not a team, so there is a single person accountable.
7. **Gate** against the Definition of Ready before the story enters the sprint.

## Running the GitHub side

```bash
# from the repo root, with the gh CLI authenticated
gh auth status
bash assessment-2/task-1/create-issues.sh
```

The script is dry-run by default — it prints the `gh issue create` commands without executing them. Set `APPLY=1` to actually create the issues:

```bash
APPLY=1 bash assessment-2/task-1/create-issues.sh
```

Issue templates for future stories and tasks live in [`.github/ISSUE_TEMPLATE/`](../../.github/ISSUE_TEMPLATE) at the repo root.

> **Note on owner names:** the owners in this backlog are placeholder squad members. Swap them for the real Cycle 21 team before using this as a live sprint plan.
