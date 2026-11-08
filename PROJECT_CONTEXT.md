# MIZVO — Project Context

Last updated: 2026-11-08

## Identity
- Name: MIZVO — a worldwide messaging app (goal; messaging is not built yet)
- Founder / decision-maker: Md Nazmus Shakib (GitHub: shakib821r)
- Repository: https://github.com/shakib821r/MIZVO (public)
- Live site: https://shakib821r.github.io/MIZVO/ (GitHub Pages, main branch, root)
- Stack: HTML, CSS, JavaScript, Supabase (Auth, Postgres database), supabase-js v2
- Budget: strictly ৳0 — free tools and free tiers only; no paid service without the founder's approval
- App language: English only

## Files in the repository
- `index.html` — main app (new design): bottom navigation (Chats, Contacts, Profile), Chats empty state, Contacts (find a person by exact @username), Choose/Change @username screen, Profile (name, email, @username and status when set, Light/Dark/System, About, Log out), About MIZVO. Reads and updates the user's row in `profiles`.
- `auth.html` — new design: Sign in (default), Create account (confirm password, Terms checkbox), Forgot password. One Show/Hide button controls both password fields. Redirects to `index.html` after sign-in or when a session exists.
- `reset.html` — new design: set a new password from the emailed link.
- `terms.html`, `privacy.html` — plain-language DRAFTS, not reviewed by a lawyer.
- `mizvo.css` — design tokens (light and dark) and shared components. `mizvo-theme.js` — Light / Dark / System theme.
- `founder.jpg` — founder portrait (re-encoded, no EXIF data). `README.md`.
- Documentation: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md

## Redesign status (master prompt, staged, founder approves each stage)
- Stage 1 audit: done. Stage 2: founder chose concept B "Halves". Stage 3: five Design Signatures and design system approved (with a deeper mint for the light-mode logo). Stage 4: screen designs approved with the founder's answers (see DECISIONS D-017 to D-021).
- Stage 5 implementation, one screen at a time. Done and tested by the founder (2026-11-08): foundation, Sign in / Create account / Forgot password, Terms and Privacy drafts, Reset password, app shell with Chats and Profile and About, then Contacts and the choose-@username step (7 tests OK).
- Still to build: Edit profile (name, status), QR profile code, Settings screen, Conversation (needs messaging).
- Stage 6 testing and Stage 7 documentation continue after each step.

## Progress log

### Completed and tested (reported by the founder)
- Signup with a new email, verification email, login, logout, session persistence, Forgot Password (8 tests), About MIZVO (5 tests), Gmail SMTP delivery (email reached an outside address but landed in Spam).
- Database Step B (2026-11-07): `profiles` extended with `username`, `status`, `updated_at`; security rules tested; signup trigger cuts the name to 50 characters.
- Redesign Stage 5 (2026-11-08): auth screens (6 tests), Show/Hide for both password fields, plain Terms and Privacy text, reset.html (4 tests), app shell (6 tests), Contacts and choose/change @username (7 tests) — all reported OK.

### Pending (order agreed with the founder)
1. Stage 5 next steps: Edit profile and Settings screen, then the QR profile code
2. Step C: one-to-one messaging with Supabase Realtime, built in the new design (the founder decides the encryption approach first)
- Optional: improve email templates in the Supabase dashboard; domain-based email sending (needs a purchased domain and the founder's approval)

### Open risks
- Auth emails can land in Spam (BUG-007); Gmail is a personal mail service with a daily cap (about 500 per day per a third-party source, not verified).
- Supabase free projects pause after about one week of inactivity (BUG-009), per third-party pricing guides.
- Terms and Privacy are drafts and make statements the founder must be able to keep (account deletion by email on request, not for children under 13, no selling of personal data). A lawyer review is advised before real users.
- Fonts are loaded from Google Fonts, so each visit makes a request to Google. Self-hosting the fonts is possible later.
- Supabase free Realtime limits (relevant to Step C), per third-party guides: about 200 concurrent connections and 2 million messages per month.

## Public information shown in the app
- Founder name "Md Nazmus Shakib", title "Founder & CEO", portrait photo (approved by the founder to be public).
- Contact email: mizvo.official@gmail.com. The founder's phone number is intentionally NOT published.
- Vision and Mission text is exactly as written by the founder.

## Supabase configuration (set and checked by the founder in the dashboard)
- Custom SMTP: ON — Gmail, sender and username mizvo.official@gmail.com, sender name MIZVO. The Gmail App Password is stored only in the Supabase dashboard and must never be shared or committed.
- Site URL: https://shakib821r.github.io/MIZVO/. Redirect URLs: the site root and https://shakib821r.github.io/MIZVO/reset.html
- Database: `public.profiles` (see ARCHITECTURE.md), including a rule that blocks reserved usernames (admin, support, official, anything starting with "mizvo", and similar) for app users. The founder can set his own through the SQL Editor (role: postgres).
- Only the publishable key is used in frontend code. service_role / secret keys must never be placed in frontend code.

## Working method (Android phone)
- Files are uploaded to GitHub with Add file → Upload files.
- Lesson: Android may rename a downloaded file to "name (1).html" when an older copy exists; GitHub then keeps both and the live site keeps using the old one. Delete old copies from Downloads first and check the file list and line count after uploading (BUG-006).
- Database changes: inspect first with read-only queries, never drop existing data, report exact error messages.

## Not verified
- Exact root cause of the earlier "cannot login after logout" bug (fix confirmed working).
- Why the verification email went to Spam (BUG-007).
- A real signup with a name longer than 50 characters (BUG-008): verified only by reading the function source.
- The "username already taken" message and two-account behavior: not tested yet (needs a second account of the founder's own).
- Display on devices other than the founder's phone; no automated tests exist.
