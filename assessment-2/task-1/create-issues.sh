#!/usr/bin/env bash
# Assessment 2 / Task 1 — load the refined backlog into GitHub as real issues.
#
# Dry run (default):  bash assessment-2/task-1/create-issues.sh
# Actually create:    APPLY=1 bash assessment-2/task-1/create-issues.sh
#
# Requires the gh CLI, authenticated against icstars-milwaukee.

set -euo pipefail

APPLY="${APPLY:-0}"

run() {
  if [[ "$APPLY" == "1" ]]; then
    "$@"
  else
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n\n'
  fi
}

if [[ "$APPLY" == "1" ]]; then
  gh auth status >/dev/null || { echo "gh is not authenticated. Run: gh auth login" >&2; exit 1; }
  echo "APPLY=1 — creating issues for real."
else
  echo "Dry run. Set APPLY=1 to create these issues."
fi
echo

# --- Labels -----------------------------------------------------------------
run gh label create "user story"    --color 0E8A16 --description "Sprint-ready user story"      --force
run gh label create "task"          --color 1D76DB --description "Task broken out from a story" --force
run gh label create "epic:auth"     --color 5319E7 --description "Authentication epic"          --force
run gh label create "sprint-1"      --color FBCA04 --description "Committed to Sprint 1"        --force
run gh label create "needs-refinement" --color D93F0B --description "Not sprint-ready"          --force

# --- STORY-101 --------------------------------------------------------------
run gh issue create \
  --title "STORY-101: Returning customer login (5 pts)" \
  --label "user story,epic:auth,sprint-1" \
  --body "$(cat <<'EOF'
**As a** returning customer,
**I want** to log in with my email address and password,
**so that** I can reach my saved order history and addresses without re-entering my details every visit.

**Estimate:** 5 story points · **Story owner:** A. Rivera

### Acceptance criteria
1. Given a registered, verified customer, when correct credentials are submitted, then the account dashboard loads with the customer's name in the header.
2. Given the login form, when credentials do not match a record, then "Email or password is incorrect" is shown without revealing whether the email exists.
3. Given the login form, when a field is blank, then that field shows "This field is required" and no network request is sent.
4. Given a successful login, when the tab is closed and reopened within 7 days, then the session is still valid.
5. Given 5 failed attempts for one email in 15 minutes, when a 6th is attempted, then it is blocked for 15 minutes.
6. The form is keyboard-operable, every input has an associated label, and errors are announced via `aria-live="polite"`.

### Tasks
- [ ] T-101.1 Login form UI — C. Lewis — 4 h
- [ ] T-101.2 `POST /api/auth/login` + session cookie — A. Rivera — 6 h
- [ ] T-101.3 Rate limiting + lockout — A. Rivera — 3 h
EOF
)"

run gh issue create --title "T-101.1: Build the login form UI (4 h)" --label "task,epic:auth,sprint-1" \
  --body "Parent: STORY-101 · Owner: C. Lewis · Estimate: 4 h

Email and password inputs with associated labels, submit button, inline required-field validation, and an \`aria-live\` error region.

**Done when:** renders correctly at 320 px and 1440 px, fully keyboard-operable, axe scan returns 0 violations. Covers AC 3 and AC 6."

run gh issue create --title "T-101.2: Implement POST /api/auth/login (6 h)" --label "task,epic:auth,sprint-1" \
  --body "Parent: STORY-101 · Owner: A. Rivera · Estimate: 6 h

Verify submitted credentials against the stored password hash and return a 7-day signed session cookie (\`HttpOnly\`, \`Secure\`, \`SameSite=Lax\`).

**Done when:** unit tests cover valid, invalid-password, and unknown-email cases, and the last two return an identical generic error body. Covers AC 1, 2, 4."

run gh issue create --title "T-101.3: Add login rate limiting and lockout (3 h)" --label "task,epic:auth,sprint-1" \
  --body "Parent: STORY-101 · Owner: A. Rivera · Estimate: 3 h

Per-email and per-IP throttling with a 15-minute lockout after 5 failures, plus a logged security event.

**Done when:** an integration test proves the 6th attempt returns HTTP 429 and the lockout expires on its own. Covers AC 5."

# --- STORY-102 --------------------------------------------------------------
run gh issue create \
  --title "STORY-102: Self-service password reset (3 pts)" \
  --label "user story,epic:auth,sprint-1" \
  --body "$(cat <<'EOF'
**As a** customer who has forgotten my password,
**I want** to request a secure reset link by email and set a new password myself,
**so that** I can get back into my account in minutes without waiting on a support ticket.

**Estimate:** 3 story points · **Story owner:** C. Lewis

### Acceptance criteria
1. Given the forgot-password page, when a registered email is submitted, then "If that email is registered, a reset link is on the way" is shown and the email arrives within 2 minutes.
2. Given an unregistered email, when it is submitted, then the same confirmation message is shown and no email is sent.
3. Given a valid reset link, when a new policy-compliant password (12+ chars, not one of the last 3) is confirmed, then it is saved and the user is redirected to login.
4. Given a token older than 60 minutes or already used, when the link is opened, then "This reset link has expired" is shown with a re-request button.
5. Given a completed reset, when the change is saved, then all existing sessions for that account are signed out.

### Tasks
- [ ] T-102.1 Forgot-password + set-new-password pages — C. Lewis — 4 h
- [ ] T-102.2 Single-use reset tokens — A. Rivera — 5 h
- [ ] T-102.3 Reset email + session invalidation — J. Chen — 3 h
EOF
)"

run gh issue create --title "T-102.1: Build forgot-password and set-new-password pages (4 h)" --label "task,epic:auth,sprint-1" \
  --body "Parent: STORY-102 · Owner: C. Lewis · Estimate: 4 h

Both pages including the password-policy hint and the confirmation-match check.

**Done when:** both pages are keyboard-accessible and the confirmation copy is byte-identical for known and unknown emails. Covers AC 1, 2, 3."

run gh issue create --title "T-102.2: Implement single-use reset tokens (5 h)" --label "task,epic:auth,sprint-1" \
  --body "Parent: STORY-102 · Owner: A. Rivera · Estimate: 5 h

Generate reset tokens, store only their hash, expire after 60 minutes, consume on first use.

**Done when:** unit tests cover valid, expired, and already-consumed tokens, and the raw token is never stored or logged. Covers AC 3, 4."

run gh issue create --title "T-102.3: Wire reset email and invalidate sessions (3 h)" --label "task,epic:auth,sprint-1" \
  --body "Parent: STORY-102 · Owner: J. Chen · Estimate: 3 h

Send the reset template through the transactional email provider and sign out every existing session on a successful reset.

**Done when:** the email renders in Gmail, Outlook, and Apple Mail, and an end-to-end test proves a pre-reset session cookie is rejected afterward. Covers AC 1, 5."

# --- Not-ready backlog items ------------------------------------------------
run gh issue create --title "RAW-3: Fix signup — needs refinement" --label "needs-refinement" \
  --body "Blocking question: what is the actual defect, and which users hit it? Needs a reproduction case before it can be sized."

run gh issue create --title "RAW-4: Dashboard — needs refinement" --label "needs-refinement" \
  --body "Blocking question: which three things does a user most need to see on first load? Needs a product decision."

run gh issue create --title "RAW-5: Email stuff — needs refinement" --label "needs-refinement" \
  --body "Blocking question: which emails, triggered by what? Likely an epic rather than a story."

echo "Done."
