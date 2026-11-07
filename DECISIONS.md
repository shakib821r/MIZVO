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

## D-009 — About MIZVO and Founder card built together (2026-11-07, approved by the founder)
- Same screen and same file (`index.html`), so Priority 4 and 5 were delivered in one update.

## D-010 — Public information policy (2026-11-07, decided by the founder)
- The repository and site are public. The founder approved publishing his portrait, name and title.
- Contact is a dedicated email (mizvo.official@gmail.com); the phone number is not published (spam and scam risk, hard to remove from GitHub history).
- The photo is re-encoded without EXIF metadata before upload.
- Only content supplied by the founder is shown; nothing about the founder is invented.

## D-011 — Gmail SMTP for Supabase auth emails (2026-11-07, approved by the founder)
- Reason: the default Supabase email service only reaches team members and has a very low hourly limit. Gmail SMTP is free and needs no domain, which fits the ৳0 budget.
- Setup: sender and username mizvo.official@gmail.com, Google App Password (2-Step Verification on). The App Password lives only in the Supabase dashboard; never in code, GitHub or chat.
- Trade-offs: Supabase warns Gmail is a personal, not transactional, provider; test email landed in Spam; daily sending cap (about 500 per day per a third-party source, not verified).
- Revisit: move to a domain-based provider (for example Brevo) when a domain is affordable; this needs the founder's approval.
