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

## D-012 — Extend the existing profiles table instead of recreating it (2026-11-07)
- The table already existed with 3 real rows, 2 policies and a signup trigger. Dropping it could lose data, so it was extended with `ALTER TABLE`.
- Columns now: id (links to the auth user, deleted with the user), username (unique, 3–20 characters of a–z, 0–9, `_`, empty allowed), display_name (max 50), status (max 140), avatar_url, created_at, updated_at.
- Row Level Security: signed-in users can read all profiles (approved by the founder, needed to find people and open chats); users can update only their own row; nobody can delete; visitors who are not signed in have no access.
- The profiles table never stores the email address; a QR code will contain only a username-based profile link.
- The profile row is created by the database trigger on signup, so the frontend does not create it.

## D-013 — Profile screen wiring is done in the redesign (2026-11-07)
- `index.html` does not read the profile yet. The Profile screen will be rewritten in the approved new design, so wiring it now would be thrown away.

## D-014 — Test security rules inside a rolled-back SQL block (2026-11-07)
- Row Level Security is tested in the SQL Editor by acting as a user and finishing with an intentional error, so no data changes. The founder-approved result is recorded in PROJECT_CONTEXT.md.

## D-015 — Cut display names to 50 characters inside the signup trigger (2026-11-07)
- Reason: the 50-character rule on `display_name` must never make account creation fail (BUG-008). The check lives in the database so it cannot be bypassed from the browser.

## D-016 — Staged redesign with founder approval at each stage (2026-11-07)
- The brand identity and UI/UX redesign follows the founder's master prompt: audit, three creative directions, five design signatures and design system, screen designs, implementation, testing, documentation. No design is final without the founder's approval.
- Messaging (Step C) is built after the redesign so the chat screens are made once, in the new design.

## D-017 — Brand direction B "Halves" and five Design Signatures (2026-11-08, approved by the founder)
- Direction B: two offset semicircles; Deep Teal #0F3D3E and Mint #8FE3C8; fonts Sora (headings) and Manrope (text); English only.
- Signatures: The Halves, The Meeting Point (mint only where a connection is happening), Pill Geometry, Quiet Surface (no gradients, no glow), Slide Together (motion). Light-mode logo uses the deeper mint #35B894.
- Not verified: global uniqueness of the design or the name. A trademark search for "MIZVO" is the founder's to do.

## D-018 — Design tokens and theme (2026-11-08)
- All colors, fonts and shapes are CSS variables in `mizvo.css`; dark mode redefines them. `mizvo-theme.js` sets Light / Dark / System (default System) and stores the choice in the browser, so it survives logout. Syncing the choice across devices can come later through `profiles`.

## D-019 — Honest interface, no fake features (2026-11-08)
- Navigation shows only real areas: Chats and Profile now, Contacts next. Stories and Calls were removed until they exist.
- Chats shows an honest empty state until messaging exists. Notifications and Delete account are shown as "later", not as switches, because they need messaging, push support or a server function.

## D-020 — Password minimum stays 6 characters (2026-11-08, founder's choice)
- Longer passwords are allowed. A higher minimum can be set later in the UI and in Supabase.

## D-021 — Terms and Privacy wording (2026-11-08, founder's request)
- The pages contain plain policy language only: no vendor names, no explanation of how the app is built. They still say that information is shared with trusted service providers and what other users can see, because a privacy policy should disclose that. They remain drafts until a lawyer reviews them.
