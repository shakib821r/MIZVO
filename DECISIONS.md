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
