# Blank Test Case Template (setup)

Copy one block per test case. A case is not finished until every field is filled — an empty **Expected result** is the single most common reason a test case is unusable by anyone but its author.

---

## TC-000 — <short descriptive title>

| Field | Value |
| --- | --- |
| Test case ID | TC-000 |
| Traces to | REQ-00 / AC <n> |
| Type | Positive / Negative / Boundary / Security / Accessibility |
| Priority | High / Medium / Low |
| Author | <name> |
| Preconditions | <state the system must be in before the test starts> |
| Test data | <exact values used — not "a valid user"> |

**Given** <starting state, specific>
**When** <the single action under test>
**Then** <observable, checkable outcome>

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | | |
| 2 | | |
| 3 | | |

| Field | Value |
| --- | --- |
| Actual result | <what happened when executed> |
| Status | Not run / Pass / Fail / Blocked |
| Executed by / date | |
| Defect raised | <DEF-000 or none> |

---

## Checklist before you call a case done

- [ ] Traces to a specific requirement **and** a specific acceptance criterion
- [ ] Test data is literal values, not a description
- [ ] Exactly one behavior under test per case
- [ ] Expected result is observable by someone who did not write the test
- [ ] At least one negative case exists for every positive case
