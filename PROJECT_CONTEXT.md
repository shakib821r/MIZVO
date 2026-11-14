# MIZVO — Project Context

Last updated: 2026-11-13

## Identity
- Name: MIZVO — a worldwide messaging app (one-to-one text messaging works; not yet open to the public)
- Founder / decision-maker: Md Nazmus Shakib (GitHub: shakib821r)
- Repository: https://github.com/shakib821r/MIZVO (public)
- Live site: https://shakib821r.github.io/MIZVO/ (GitHub Pages, main branch, root)
- Stack: HTML, CSS, JavaScript, Supabase (Auth, Postgres database), supabase-js v2
- Budget: strictly ৳0 — free tools and free tiers only; no paid service without the founder's approval
- App language: English only

## Files in the repository
- `index.html` — main app (new design): bottom navigation (Chats, Contacts, Profile); real chat list with last message and unread badges; Conversation (one-to-one text, real-time, load older, Block/Unblock); Contacts (find by exact @username, Message button); Choose/Change @username; Profile with Edit profile, My QR code, Settings (theme, password, sign out of all devices, Blocked people) and About; scanned profile links (`?u=username`). Reads and writes `profiles`, `messages`, `blocks` and calls the chat functions.
- `auth.html` — new design: Sign in (default), Create account (confirm password, Terms checkbox), Forgot password. One Show/Hide button controls both password fields. Redirects to `index.html` after sign-in or when a session exists.
- `reset.html` — new design: set a new password from the emailed link.
- `terms.html`, `privacy.html` — plain-language DRAFTS, not reviewed by a lawyer.
- `mizvo.css` — design tokens (light and dark) and shared components. `mizvo-theme.js` — Light / Dark / System theme. `qrcode.js` — QR code generator (MIT licence, Kazuhiko Arase; licence notice kept in the file), hosted in the repository.
- `database.sql` — a record of every SQL script run on the database, in order (profiles, usernames, messaging, rate limits), so the database can be rebuilt. Do not run it again on the live database. (`database-messaging.sql`, if present in the repository, is an older partial copy.)
- `founder.jpg` — founder portrait (re-encoded, no EXIF data). `README.md`.
- Documentation: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md

## Redesign status (master prompt, staged, founder approves each stage)
- Stage 1 audit: done. Stage 2: founder chose concept B "Halves". Stage 3: five Design Signatures and design system approved (with a deeper mint for the light-mode logo). Stage 4: screen designs approved with the founder's answers (see DECISIONS D-017 to D-021).
- Stage 5 implementation, one screen at a time. Done and tested by the founder (2026-11-08): foundation, Sign in / Create account / Forgot password, Terms and Privacy drafts, Reset password, app shell with Chats and Profile and About, then Contacts and the choose-@username step (7 tests OK), then Edit profile, Settings and the QR profile code (reported working), then one-to-one messaging with Block (all tests reported OK, 2026-11-09).
- Still to build: the pre-launch items below (email templates, abuse reporting, backups, legal review).
- Stage 6 testing and Stage 7 documentation continue after each step.

## Progress log

### Completed and tested (reported by the founder)
- Signup with a new email, verification email, login, logout, session persistence, Forgot Password (8 tests), About MIZVO (5 tests), Gmail SMTP delivery (email reached an outside address but landed in Spam).
- Database Step B (2026-11-07): `profiles` extended with `username`, `status`, `updated_at`; security rules tested; signup trigger cuts the name to 50 characters.
- Message and new-chat rate limits (2026-11-13): 10 messages per 10 seconds, 600 per hour, 20 new chats per hour per person. Rolled-back database test passed (burst blocked after 10, chat limit blocked); the app shows friendly messages (reported uploaded by the founder).
- Redesign Stage 5 (2026-11-08): auth screens (6 tests), Show/Hide for both password fields, plain Terms and Privacy text, reset.html (4 tests), app shell (6 tests), Contacts and choose/change @username (7 tests), Edit profile, Settings and QR code, and messaging with Block (6 messaging tests and 4 block tests) — all reported OK.

### Pending (before real users)
1. Better confirmation and reset email templates (free; may reduce Spam placement)
2. A way for users to report abuse, and a process for the founder to review reports
3. A routine for exporting data (free Supabase projects have no automatic point-in-time backup) and keeping the project active
4. A knowledgeable review of Terms and Privacy (the founder confirmed the promises below)
5. Later: reporting abusive users with a review process, message deletion, read receipts, notifications, media, groups
- Optional: domain-based email sending (needs a purchased domain and the founder's approval); bot protection on sign-up; self-host fonts; pin the Supabase library version

### Open risks
- Auth emails can land in Spam (BUG-007); Gmail is a personal mail service with a daily cap (about 500 per day per a third-party source, not verified).
- Supabase free projects are paused when they get too little database activity over 7 days; the owner gets a warning email about a week before; a paused project is resumed from the dashboard (BUG-009; Supabase's own page, its restore-window wording differs between its pages).
- Terms and Privacy are drafts. The founder confirmed (2026-11-13) that he can keep these promises: deleting an account on request by email, not for children under 13, no selling of personal data, messages not end-to-end encrypted, sharing with trusted service providers. A knowledgeable review is still advised before real users.
- Fonts are loaded from Google Fonts, so each visit makes a request to Google. Self-hosting the fonts is possible later.
- Supabase free Realtime limits, from Supabase's own documentation: 200 concurrent connections and 100 messages per second. This is the first wall when users grow. (An earlier note about 2 million messages per month came from third-party guides and is not on Supabase's limits page.)
- Messages are stored as normal text protected by Row Level Security. They are NOT end-to-end encrypted; anyone with database admin access (the founder, Supabase) can technically read them. The Privacy Policy and the empty chat screen say so.
- Free Supabase projects have no point-in-time backup; export data from time to time.

## Operations (the founder's manual tasks)
- Delete an account on request: Supabase dashboard → Authentication → Users → the person's row → Delete user. This also deletes their profile, chat memberships and the messages they sent, so those messages disappear for the other person too (founder accepted this on 2026-11-13).
- Keep the project active: open the project in the dashboard now and then; real use also counts. If it is paused, open the dashboard and choose Resume project.
- Export data from time to time (free projects have no automatic point-in-time backup).

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
- The "username already taken" message on the real database: not tested yet (needs a second account of the founder's own). Automated checks in a simulated Supabase passed; the real database, password-change rules and phone-camera QR scanning are covered only by the founder's manual report.
- Display on devices other than the founder's phone; no automated tests exist.
