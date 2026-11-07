# MIZVO — Bugs

## BUG-001 — Cannot log in again after logout
- Status: Fixed. Founder tested login, logout, session persistence and wrong password on 2026-11-07 and reported "All okay".
- Symptom: After Log out, logging in again did not work.
- Most likely cause (from code review, not proven by logs): `auth.html` always opened in "Create Account" mode, so pressing the button after logout sent a signup request (Supabase returns a generic success for an already-registered email and does not log in). Also, after a successful login the page only showed a message and did not open the app.
- Fix: `auth.html` now opens in Login mode, redirects to `index.html` after login, and skips itself when a session already exists.

## BUG-002 — Default email service limits (open risk)
- Status: Open (not yet fixed).
- Custom SMTP is OFF. Per Supabase documentation, the default email service delivers only to members of the project's organization and has a very low hourly email limit.
- Impact: real users outside the team may not receive verification or password-reset emails once the app has users.
- Planned fix: free custom SMTP provider (requires the founder's approval before any setup).

## BUG-003 — Signup with an already-verified email shows a generic success message
- Status: Mitigated (by design in Supabase).
- Supabase intentionally returns a success-like response and sends no email. This prevents revealing which emails are registered.
- Mitigation: the message now also says "Already registered? Use the Login link below."

## BUG-004 — Earlier auth.html problems (resend button unclickable, page reset, toggle stuck)
- Status: Resolved by the replacement auth.html; toggle and signup confirmed working in tests.

## BUG-005 — index.html shows demo data only (open, expected)
- Chats, stories and messages are static demo content. Real messaging is not implemented yet.
