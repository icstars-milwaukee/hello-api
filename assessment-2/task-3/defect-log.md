# Artifact: Defect Log — Sprint 1

**Project:** `icstars-rfp-molson-cycle21-carl-` · Molson Cycle 21 RFP
**Sprint:** Sprint 1 (2026-10-12 → 2026-10-23) · **Build under test:** `df0b998`
**Log owner:** J. Chen (QA) · **Date:** 2026-10-08

---

## Summary table

| ID | Title | Severity | Priority | Status | Found in | Reported by | Owner | Date found | Linked test case |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| DEF-001 | Login accepts wrong password | **1 — Critical** | **P1** | Fixed — pending verification | `df0b998` / staging | J. Chen | A. Rivera | 2026-10-08 | [TC-002](test-plan.md#tc-002--wrong-password-is-rejected) |
| DEF-002 | Login form sends a request before client-side validation runs | 3 — Minor | P3 | Triaged | `df0b998` / staging | J. Chen | C. Lewis | 2026-10-08 | [TC-003](test-plan.md#tc-003--blank-fields-are-caught-before-submission) |

**Open:** 2 · **Severity-1 open:** 1 · **Blocking the sprint demo:** DEF-001

---

## DEF-001 — Login accepts wrong password

| Field | Value |
| --- | --- |
| Defect ID | **DEF-001** |
| Title | Login accepts wrong password — any non-empty password authenticates a registered email |
| Severity | **1 — Critical.** This is a complete authentication bypass. Anyone who knows a customer's email address can sign in as that customer and read saved orders and addresses. |
| Priority | **P1 — fix today, before the sprint review.** No other Sprint 1 work ships ahead of this. |
| Status | **Fixed — pending verification** (New → Triaged → In Progress → Fixed → *awaiting Verified*) |
| Reported by | J. Chen (QA) |
| Date found | 2026-10-08, 09:42 CT |
| Owner | A. Rivera (back end) |
| Environment | Windows 11 · Chrome 141.0.7390.54 · desktop 1440 px · also reproduced on Firefox 135 and Safari 18.4 |
| Build / commit | `df0b998` on `main`, deployed to `staging.molson-cycle21.local` |
| Linked requirement | REQ-01 / AC 2 |
| Linked test case | [TC-002](test-plan.md#tc-002--wrong-password-is-rejected) |
| Linked story / task | [`STORY-101`](../task-1/refined-backlog.md#story-101--returning-customer-login) / `T-101.2` |
| Reproducibility | **Always — 10 of 10 attempts** |

### Steps to reproduce

1. Navigate to `https://staging.molson-cycle21.local/login`.
2. In **Email**, enter `carl.test@example.com` — a registered, verified account.
3. In **Password**, enter `Wrong-Password-0001`, which is **not** this account's password.
4. Click **Sign in**.
5. Observe the resulting page, the HTTP response, and the cookies set.

### Expected result

Per REQ-01 / AC 2: HTTP 401, the user stays on `/login`, the message "Email or password is incorrect" is displayed, and **no** session cookie is issued.

### Actual result

HTTP **200**. The browser redirects to `/dashboard`, a valid 7-day `session` cookie is issued, and the header renders "Carl". The account is fully accessible with an incorrect password. Confirmed further: an empty password string also authenticates; only a non-existent email is rejected.

### Evidence

```
POST /api/auth/login HTTP/1.1
Content-Type: application/json

{"email":"carl.test@example.com","password":"Wrong-Password-0001"}

HTTP/1.1 200 OK
Set-Cookie: session=eyJhbGciOi...; Max-Age=604800; HttpOnly; Secure; SameSite=Lax
{"ok":true,"redirect":"/dashboard","user":{"name":"Carl"}}
```

Attached in the GitHub issue: `def-001-network-tab.png`, `def-001-dashboard-loaded.png`, staging API log excerpt for 09:40–09:45 CT.

### Root cause

In the login handler the credential check was written as an assignment rather than a comparison, so the guard was never evaluated against the submitted password — the branch returned truthy for any user record that was successfully looked up. The lookup succeeding was effectively being treated as the authentication result.

### Fix

Compare the submitted password against the stored hash with the bcrypt verify function and return 401 on a false result. The same generic error body is returned for a bad password and an unknown email so the response cannot be used to enumerate registered accounts.

### Verification

| Field | Value |
| --- | --- |
| Retested by | J. Chen |
| Retest build | pending — fix branch `fix/def-001-password-verify`, not yet merged |
| Result | **Not yet verified.** Verification requires: TC-002 passes, TC-001 still passes, and TC-005 — currently Blocked — executes and passes. |
| Closure condition | All three cases green on the fix build, reviewed by the story owner. |

### Regression guard

Three automated tests added alongside the fix, so this cannot silently return:

1. Correct password → 200 with a session cookie.
2. Incorrect password → 401, no `Set-Cookie` header.
3. Empty password string → 401, no `Set-Cookie` header.

Test 2 is the direct regression test for this defect and fails against build `df0b998`.

### Process note

This defect is why TC-002 exists. A test plan with only the happy path — TC-001 — would have passed cleanly and shipped an authentication bypass to production. The negative case is the one that earned its keep.

---

## DEF-002 — Login form sends a request before client-side validation runs

| Field | Value |
| --- | --- |
| Defect ID | **DEF-002** |
| Title | Submitting the login form with an empty password fires `POST /api/auth/login` before client-side validation blocks it |
| Severity | 3 — Minor. The error message and focus behavior are correct and the server rejects the request, so the user-visible outcome is right; the cost is one wasted request per empty submission and an avoidable entry in the rate-limit counter. |
| Priority | P3 — fix within the sprint, after DEF-001. |
| Status | **Triaged** (New → *Triaged* → …) |
| Reported by | J. Chen (QA) |
| Date found | 2026-10-08, 10:15 CT |
| Owner | C. Lewis (front end) |
| Environment | Windows 11 · Chrome 141 · desktop 1440 px |
| Build / commit | `df0b998`, staging |
| Linked requirement | REQ-01 / AC 3 |
| Linked test case | [TC-003](test-plan.md#tc-003--blank-fields-are-caught-before-submission) |
| Linked story / task | `STORY-101` / `T-101.1` |
| Reproducibility | Always — 10 of 10 |

### Steps to reproduce

1. Open `https://staging.molson-cycle21.local/login` with the browser network tab recording.
2. Enter `carl.test@example.com` in **Email** and leave **Password** empty.
3. Click **Sign in**.
4. Inspect the network tab.

### Expected result

Zero requests to `/api/auth/login`. Client-side validation blocks submission and displays "This field is required."

### Actual result

One `POST /api/auth/login` is sent with `"password":""` and returns 401. The required-field message then appears correctly, so the defect is invisible without the network tab open.

### Evidence

Network tab shows a single `POST /api/auth/login` with status 401 and request body `{"email":"carl.test@example.com","password":""}`. Screenshot `def-002-network-tab.png` attached in the issue.

### Root cause (hypothesis — not yet confirmed)

The submit handler most likely runs the fetch before the validation check, or does not call `preventDefault()` early enough on the native form submit. To be confirmed by the owner before the fix.

### Fix

Validate first and return early; only call the API once every required field passes. Keep the server-side rejection in place regardless — client validation is a convenience, never a security control.

### Verification

Re-run TC-003 and confirm zero network requests on an empty-field submission. Add a front-end test asserting the fetch is not called when validation fails.

---

## How this log is tracked (QA.SK2)

**Status flow.** Every defect moves through `New → Triaged → In Progress → Fixed → Verified → Closed`. Only QA moves a defect to **Verified**, and only after retesting on the actual fix build — a developer saying "fixed" moves it to Fixed, never past it. A defect that fails retest goes to **Reopened** with the retest build recorded, not silently back to In Progress.

**Daily review.** The log is reviewed at standup. Any open Severity-1 is read aloud and blocks the sprint demo until Verified.

**Severity vs. priority stay separate fields.** DEF-002 shows why: its user-visible behavior is correct, so it is Severity 3, but it is still worth fixing this sprint — Severity is QA's call about impact, Priority is the product owner's call about sequencing.

**Traceability in both directions.** Each defect links to its requirement, test case, story, and task; each test case in the [test plan](test-plan.md) links back to the defect it raised. That is what makes the sprint-review answer to "what is the state of REQ-01?" a two-second lookup instead of a conversation.

**Every fix gets a regression guard.** A defect is not Closed until an automated test exists that fails on the broken build and passes on the fix. Without that, the same defect returns in a later sprint and the log becomes a history book rather than a control.
