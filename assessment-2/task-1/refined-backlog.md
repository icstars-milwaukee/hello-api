# Artifact: Refined Sprint-Ready Backlog

**Sprint:** Sprint 1 (2026-10-12 → 2026-10-23, 2 weeks)
**Team velocity (3-sprint rolling average):** 13 points
**Committed this sprint:** 8 points across 2 stories / 6 tasks
**Refined by:** Carl Lewis · 2026-10-08

---

## STORY-101 — Returning customer login

> **As a** returning customer,
> **I want** to log in with my email address and password,
> **so that** I can reach my saved order history and addresses without re-entering my details every visit.

| Field | Value |
| --- | --- |
| Epic | Authentication |
| Priority | Must have (blocks all logged-in features) |
| Estimate | **5 story points** |
| Story owner | A. Rivera |
| Status | Ready for Sprint 1 |

### Acceptance criteria

1. **Happy path** — *Given* I am a registered customer with a verified email, *when* I submit my correct email and password on the login form, *then* I land on my account dashboard and my name appears in the header.
2. **Wrong credentials** — *Given* I am on the login form, *when* I submit an email/password pair that does not match a record, *then* I see the message "Email or password is incorrect" and stay on the login page, and the message does **not** reveal whether the email exists.
3. **Empty fields** — *Given* I am on the login form, *when* I submit with either field blank, *then* the blank field is outlined in red with inline text "This field is required" and no network request is sent.
4. **Session persistence** — *Given* I logged in successfully, *when* I close the tab and reopen the site within 7 days, *then* I am still logged in.
5. **Rate limiting** — *Given* 5 failed attempts for the same email within 15 minutes, *when* I attempt a 6th, *then* I am blocked for 15 minutes and shown "Too many attempts. Try again in 15 minutes."
6. **Accessibility** — The form is fully operable by keyboard, every input has a programmatically associated label, and error text is announced by screen readers (`aria-live="polite"`).

### Tasks

| Task ID | Task | Owner | Estimate | Definition of done |
| --- | --- | --- | --- | --- |
| T-101.1 | Build the login form UI — email + password inputs, labels, submit button, inline validation and error region | C. Lewis | **4 h** | Renders at 320 px and 1440 px; keyboard-operable; axe scan returns 0 violations; covers AC 3 and AC 6 |
| T-101.2 | Implement `POST /api/auth/login` — verify credentials against hashed password, return a 7-day signed session cookie (`HttpOnly`, `Secure`, `SameSite=Lax`) | A. Rivera | **6 h** | Unit tests for valid, invalid, and unknown-email cases; identical generic error body for the last two; covers AC 1, 2, 4 |
| T-101.3 | Add per-email + per-IP rate limiting with a 15-minute lockout and a logged security event | A. Rivera | **3 h** | Integration test proves the 6th attempt returns HTTP 429; lockout expires on its own; covers AC 5 |

**Story total: 13 h / 5 points**

---

## STORY-102 — Self-service password reset

> **As a** customer who has forgotten my password,
> **I want** to request a secure reset link by email and set a new password myself,
> **so that** I can get back into my account in minutes without waiting on a support ticket.

| Field | Value |
| --- | --- |
| Epic | Authentication |
| Priority | Must have (top driver of support volume) |
| Estimate | **3 story points** |
| Story owner | C. Lewis |
| Status | Ready for Sprint 1 |

### Acceptance criteria

1. **Request a link** — *Given* I am on the "Forgot password" page, *when* I enter my registered email and submit, *then* I see "If that email is registered, a reset link is on the way" and receive the email within 2 minutes.
2. **Unregistered email** — *Given* I enter an email with no account, *when* I submit, *then* I see the **same** confirmation message and no email is sent — the response must not disclose which addresses are registered.
3. **Set a new password** — *Given* I open a valid reset link, *when* I enter a new password meeting the policy (12+ characters, not one of my last 3) and confirm it, *then* the password is updated and I am redirected to login with "Password updated — please sign in."
4. **Expired or reused token** — *Given* a token older than 60 minutes or already used once, *when* I open the link, *then* I see "This reset link has expired" and a button to request a new one.
5. **Sessions invalidated** — *Given* I complete a reset, *when* the change is saved, *then* every existing session for my account is signed out.

### Tasks

| Task ID | Task | Owner | Estimate | Definition of done |
| --- | --- | --- | --- | --- |
| T-102.1 | Build the "Forgot password" request page and the "Set new password" page, including the password-policy hint and confirmation-match check | C. Lewis | **4 h** | Both pages keyboard-accessible; identical confirmation copy for known and unknown emails; covers AC 1, 2, 3 |
| T-102.2 | Implement single-use reset tokens — generate, hash at rest, expire after 60 minutes, consume on use | A. Rivera | **5 h** | Unit tests for valid, expired, and already-consumed tokens; raw token never stored or logged; covers AC 3, 4 |
| T-102.3 | Wire the reset email template through the transactional email provider and invalidate all sessions on successful reset | J. Chen | **3 h** | Email renders in Gmail, Outlook, and Apple Mail; end-to-end test proves an old session cookie is rejected after reset; covers AC 1, 5 |

**Story total: 12 h / 3 points**

---

## Sprint capacity check (AG.SK3)

| | Hours | Points |
| --- | --- | --- |
| STORY-101 | 13 | 5 |
| STORY-102 | 12 | 3 |
| **Committed total** | **25 h** | **8** |
| Team capacity this sprint | 32 h | 13 |
| Buffer remaining | 7 h | 5 |

The 7-hour buffer is deliberately unallocated to absorb code-review rework and the two ceremonies that fall inside the sprint. We commit 8 of 13 points rather than filling to velocity because this is the team's first sprint on the authentication epic and the estimates carry more uncertainty than usual.

## Definition of Ready (the gate every story cleared)

- [x] Written in `As a [role], I want [goal], so that [reason]` form
- [x] Acceptance criteria written as testable Given / When / Then statements
- [x] Broken into tasks that are each ≤ 1 day of work
- [x] Every task carries an hour estimate and exactly one named owner
- [x] Story carries a point estimate agreed in planning poker
- [x] No unresolved external dependency blocking the start of work

## Definition of Done (applies to every task above)

Code merged to `main` behind review · unit and integration tests passing in CI · accessibility scan clean · acceptance criteria demoed to the product owner · docs or README updated where behavior changed.

## Backlog health — items deliberately left Not Ready

| ID | Raw item | Blocking question before it can be estimated |
| --- | --- | --- |
| RAW-3 | "Fix signup" | What is the actual defect, and which users hit it? Needs a reproduction case before it can be sized. |
| RAW-4 | "Dashboard" | Which three things does a user most need to see on first load? Needs a product decision. |
| RAW-5 | "Email stuff" | Which emails, triggered by what? Too broad — likely an epic, not a story. |

Leaving these visible but explicitly unready is the point of refinement: the backlog shows both what is sprint-ready and what still needs a conversation.

## Common errors this artifact avoids

| Common error | How it was avoided here |
| --- | --- |
| Stories left vague ("Fix login") | Both stories name a specific role, a specific goal, and the reason the goal matters |
| Missing acceptance criteria | 6 criteria on STORY-101 and 5 on STORY-102, all in testable Given / When / Then form, including negative and security cases |
| No estimates | Hours at the task level, points at the story level, reconciled against team capacity with a stated buffer |
| Tasks with no accountable owner | One named owner per task — never a team name, never "TBD" |
| Tasks too large to finish in a sprint | Every task is ≤ 6 hours, so progress is visible on the board daily |
