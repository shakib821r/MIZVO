# MIZVO — Technical Decisions

## D-001 — Static frontend on GitHub Pages + Supabase
- Reason: free (৳0 budget), simple to maintain from an Android phone, Supabase provides Auth and database without a server of our own.
- Trade-off: no server-side code; all security must come from Supabase Auth and Row Level Security.

## D-002 — Only the publishable key in frontend code
- Reason: the publishable key is designed for browsers. service_role / secret keys must never appear in frontend code.

## D-003 — Login is the default mode on auth.html (2026-11-07)
- Reason: returning users (for example after logout) were landing on Create Account and could not log in.

## D-004 — Session check on both pages (2026-11-07)
- `index.html` sends logged-out visitors to `auth.html`; `auth.html` sends logged-in visitors to `index.html`.
- Both pages read the same Supabase session, so they stay consistent.

## D-005 — Do not reveal whether an email is already registered (2026-11-07)
- The signup message gives a neutral hint instead of saying "this email exists". Prevents account enumeration.

## D-006 — No paid services without the founder's approval
- Any custom SMTP or other service must be free-tier and explicitly approved first.

## D-007 — Password reset design (2026-11-07, approved by the founder)
- Separate page `reset.html`; the reset email links to it through the Supabase Redirect URL list.
- Same neutral message for every valid email address (no account enumeration). Invalid email format is still reported.
- Minimum password length 6, same as signup. Stronger rules can be set later in Supabase settings.
- The page shows the new-password form only when Supabase confirms a recovery link; tokens are removed from the address bar; after success the user is signed out and sent to the login page.

## D-008 — Verify uploads on GitHub (2026-11-07)
- After each upload, check for duplicate "(1)" files and the line count of the changed file.
