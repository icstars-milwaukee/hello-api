# Artifact: Test Plan — REQ-01 Login

**Project:** `icstars-rfp-molson-cycle21-carl-` · Molson Cycle 21 RFP
**Requirement under test:** **REQ-01** — *A user can log in with email + password and see the dashboard.*
**Linked story:** [`STORY-101`](../task-1/refined-backlog.md#story-101--returning-customer-login)
**Test lead:** J. Chen · **Author:** Carl Lewis · **Date:** 2026-10-08
**Build under test:** `df0b998` · Sprint 1

---

## 1. Scope

### In scope
Email + password authentication for existing verified accounts: the login form, credential validation, the redirect to the dashboard, error handling on failure, required-field validation, and brute-force lockout.

### Out of scope
Account registration, email verification, password reset (covered separately under `STORY-102`), social sign-in, and multi-factor authentication. None of these are in Sprint 1.

### Approach
Manual execution for Sprint 1, with each case promoted to an automated test as part of its parent task's Definition of Done. Negative and security cases are weighted equally with the happy path — a login form that works is not the same as a login form that is safe.

### Environment

| Item | Value |
| --- | --- |
| Environment | Staging — `staging.molson-cycle21.local` |
| Browsers | Chrome 141, Firefox 135, Safari 18.4 |
| Devices | Desktop 1440 px, mobile 320 px |
| Database state | Reset to the seed fixture before each run |

### Test data

| Field | Value |
| --- | --- |
| Valid email | `carl.test@example.com` |
| Valid password | `Correct-Horse-9281` |
| Wrong password | `Wrong-Password-0001` |
| Unregistered email | `nobody.here@example.com` |

### Entry / exit criteria

- **Entry:** build deployed to staging, seed data loaded, `T-101.1` and `T-101.2` merged.
- **Exit:** all High-priority cases pass, zero open Severity-1 defects, every defect either Verified/Closed or explicitly deferred by the product owner with a reason recorded.

---

## 2. Test cases (QA.SK1)

### TC-001 — Valid credentials load the dashboard

| Field | Value |
| --- | --- |
| Test case ID | TC-001 |
| Traces to | REQ-01 / AC 1 |
| Type | Positive |
| Priority | High |
| Author | Carl Lewis |
| Preconditions | `carl.test@example.com` exists, is verified, and is not locked out; no active session |
| Test data | `carl.test@example.com` / `Correct-Horse-9281` |

**Given** I am a registered, verified user with no active session,
**When** I submit my correct email and password on the login form,
**Then** I am taken to the dashboard and my name appears in the header.

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Navigate to `/login` | Login form renders with Email and Password fields and an enabled Sign in button |
| 2 | Enter `carl.test@example.com` in Email | Value accepted, no validation error |
| 3 | Enter `Correct-Horse-9281` in Password | Value masked |
| 4 | Click Sign in | HTTP 200; browser redirects to `/dashboard` within 2 seconds |
| 5 | Observe the page | Dashboard renders; header shows "Carl"; a `session` cookie is set with `HttpOnly`, `Secure`, `SameSite=Lax` |

| Field | Value |
| --- | --- |
| Actual result | Redirected to `/dashboard`, header showed "Carl", cookie flags correct |
| Status | **Pass** |
| Executed by / date | J. Chen · 2026-10-08 |
| Defect raised | None |

---

### TC-002 — Wrong password is rejected

| Field | Value |
| --- | --- |
| Test case ID | TC-002 |
| Traces to | REQ-01 / AC 2 |
| Type | Negative — security |
| Priority | High |
| Author | Carl Lewis |
| Preconditions | `carl.test@example.com` exists and is verified; fewer than 5 prior failed attempts |
| Test data | `carl.test@example.com` / `Wrong-Password-0001` |

**Given** I am on the login form with a registered email address,
**When** I submit that email with an incorrect password,
**Then** I remain on the login page, I see "Email or password is incorrect", and no session is created.

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Navigate to `/login` | Login form renders |
| 2 | Enter `carl.test@example.com` in Email | Value accepted |
| 3 | Enter `Wrong-Password-0001` in Password | Value masked |
| 4 | Click Sign in | HTTP 401; URL stays `/login`; no redirect occurs |
| 5 | Observe the error | "Email or password is incorrect" shown; message is identical to the unregistered-email case, so it does not disclose whether the account exists |
| 6 | Inspect cookies and `/dashboard` | No `session` cookie set; navigating directly to `/dashboard` redirects back to `/login` |

| Field | Value |
| --- | --- |
| Actual result | **HTTP 200. Redirected to `/dashboard` and a valid session cookie was set.** The wrong password was accepted. |
| Status | **Fail** |
| Executed by / date | J. Chen · 2026-10-08 |
| Defect raised | **[DEF-001](defect-log.md#def-001--login-accepts-wrong-password)** |

---

### TC-003 — Blank fields are caught before submission

| Field | Value |
| --- | --- |
| Test case ID | TC-003 |
| Traces to | REQ-01 / AC 3 |
| Type | Negative — validation |
| Priority | Medium |
| Author | Carl Lewis |
| Preconditions | No active session |
| Test data | Email `carl.test@example.com`, Password left empty |

**Given** I am on the login form,
**When** I click Sign in with the password field empty,
**Then** the password field is flagged "This field is required" and no network request is sent.

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Navigate to `/login` and open the browser network tab | Network tab is recording |
| 2 | Enter `carl.test@example.com` in Email, leave Password empty | No error yet |
| 3 | Click Sign in | Password field outlined in red with inline text "This field is required" |
| 4 | Check the network tab | **Zero** requests to `/api/auth/login` |
| 5 | Check focus | Focus moves to the password field; the error is announced via the `aria-live` region |

| Field | Value |
| --- | --- |
| Actual result | Error shown and focus moved correctly, but one `POST /api/auth/login` request was sent before client validation ran |
| Status | **Fail** |
| Executed by / date | J. Chen · 2026-10-08 |
| Defect raised | **[DEF-002](defect-log.md#def-002--login-form-sends-a-request-before-client-side-validation-runs)** |

---

### TC-004 — Session survives closing the browser tab

| Field | Value |
| --- | --- |
| Test case ID | TC-004 |
| Traces to | REQ-01 / AC 4 |
| Type | Positive — boundary |
| Priority | Medium |
| Author | Carl Lewis |
| Preconditions | Successful login via TC-001 |
| Test data | Session cookie issued at login |

**Given** I have logged in successfully,
**When** I close the tab and return to the site within 7 days,
**Then** I am still signed in and land on the dashboard without re-entering credentials.

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Complete TC-001 | Dashboard loads |
| 2 | Close the tab, reopen the browser, navigate to `/` | Redirected to `/dashboard`, still signed in |
| 3 | Inspect the session cookie expiry | Expiry is 7 days from issue, not a session cookie |
| 4 | Advance the clock past 7 days (test harness) and reload | Redirected to `/login`; the expired session is rejected |

| Field | Value |
| --- | --- |
| Actual result | Session persisted across restart; expiry correct at 7 days; expired token rejected |
| Status | **Pass** |
| Executed by / date | J. Chen · 2026-10-08 |
| Defect raised | None |

---

### TC-005 — Sixth failed attempt is locked out

| Field | Value |
| --- | --- |
| Test case ID | TC-005 |
| Traces to | REQ-01 / AC 5 |
| Type | Negative — security |
| Priority | High |
| Author | Carl Lewis |
| Preconditions | Rate-limit counter reset for `carl.test@example.com` |
| Test data | `carl.test@example.com` / `Wrong-Password-0001` × 6 |

**Given** 5 failed login attempts have been made for one email within 15 minutes,
**When** a 6th attempt is made,
**Then** it is blocked with "Too many attempts. Try again in 15 minutes." even if the password is correct.

| Step | Action | Expected result |
| --- | --- | --- |
| 1 | Submit the wrong password 5 times in a row | Each returns HTTP 401 with the generic error |
| 2 | Submit a 6th time | HTTP 429; message "Too many attempts. Try again in 15 minutes." |
| 3 | Submit the **correct** password immediately | Still HTTP 429 — the lockout is not bypassable with valid credentials |
| 4 | Wait out the 15-minute window, submit the correct password | HTTP 200; login succeeds; lockout cleared automatically |
| 5 | Check the security log | 5 failure events plus 1 lockout event recorded for that email |

| Field | Value |
| --- | --- |
| Actual result | Not executed — blocked by DEF-001. Rate limiting cannot be meaningfully tested while wrong passwords are accepted on the first attempt. |
| Status | **Blocked** |
| Executed by / date | J. Chen · 2026-10-08 |
| Defect raised | Blocked by DEF-001 |

---

## 3. Execution summary

| Status | Count | Cases |
| --- | --- | --- |
| Pass | 2 | TC-001, TC-004 |
| Fail | 2 | TC-002, TC-003 |
| Blocked | 1 | TC-005 |
| **Total** | **5** | |

**Pass rate:** 2/5 (40%) · **Open defects:** 1 Severity-1, 1 Severity-3

**Exit criteria not met.** REQ-01 cannot be accepted this sprint. DEF-001 is a Severity-1 authentication bypass, and TC-005 cannot be executed until it is fixed. Recommendation to the product owner: hold `STORY-101` out of the sprint review demo, fix DEF-001 today, then re-run TC-002, TC-003, and TC-005 on the fix build.

---

## 4. Traceability matrix (QA.SK1)

Every acceptance criterion on REQ-01 has at least one test case, and every test case points back to a criterion. A gap in either direction is a hole in the plan.

| Requirement / AC | Criterion | Test case(s) | Status | Defect |
| --- | --- | --- | --- | --- |
| REQ-01 / AC 1 | Valid credentials load the dashboard | TC-001 | Pass | — |
| REQ-01 / AC 2 | Invalid credentials rejected, no account disclosure | TC-002 | **Fail** | DEF-001 |
| REQ-01 / AC 3 | Blank fields validated client-side | TC-003 | **Fail** | DEF-002 |
| REQ-01 / AC 4 | Session persists 7 days | TC-004 | Pass | — |
| REQ-01 / AC 5 | Lockout after 5 failures | TC-005 | **Blocked** | blocked by DEF-001 |
| REQ-01 / AC 6 | Keyboard + screen-reader accessible | TC-003 step 5 (partial) | Partial | Full accessibility pass scheduled with `T-101.1` sign-off |

**Coverage:** 6 of 6 criteria have test coverage; AC 6 is only partially covered and is flagged rather than quietly dropped.
