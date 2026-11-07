# MIZVO — Project Context

Last updated: 2026-11-07

## Identity
- Name: MIZVO — a worldwide messaging app (goal; not yet built)
- Founder / decision-maker: Md Nazmus Shakib (GitHub: shakib821r)
- Repository: https://github.com/shakib821r/MIZVO (public)
- Live site: https://shakib821r.github.io/MIZVO/ (GitHub Pages, main branch, root)
- Stack: HTML, CSS, JavaScript, Supabase (Auth, Postgres database), supabase-js v2
- Budget: strictly ৳0 — free tools and free tiers only; no paid service without the founder's approval

## Files in the repository
- `index.html` — main app screen (demo chat UI with static data). Checks the Supabase session, Profile shows name and email, About MIZVO screen, Log out.
- `auth.html` — Login (default), Create Account, Resend Verification Email, Forgot Password (reset link request). Redirects to `index.html` after login or when a session exists. Signup message reminds users to check the Spam folder.
- `reset.html` — set a new password after opening the emailed reset link.
- `founder.jpg` — founder's portrait for the About MIZVO screen (re-encoded, no EXIF data).
- `README.md`
- Documentation: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md

## Progress log

### Completed and tested (reported by the founder)
- Signup with a new email: verification email received, link opens the site.
- Login, logout, session persistence, wrong-password message (2026-11-07).
- Forgot Password: all 8 tests reported OK (2026-11-07).
- About MIZVO (Profile → About MIZVO): all 5 tests reported OK (2026-11-07).
- Custom SMTP (Gmail) enabled in Supabase. Test to an outside address: email arrived in Spam; confirm link worked (2026-11-07).
- Signup message tells users to check the Spam folder (founder reported done, 2026-11-07).
- Step B (database): the existing `public.profiles` table was extended with `username`, `status`, `updated_at`; security rules tested in the SQL Editor (all 6 checks passed); signup trigger fixed to cut display names to 50 characters (2026-11-07). The app (`index.html`) does not read this table yet.

### Pending (order agreed with the founder)
1. Stage 1 audit for the brand/UI redesign (no code changes)
2. Redesign stages 2–4: three creative directions, five design signatures and design system, screen designs — each needs the founder's approval
3. Redesign implementation, including Profile "Identity Card" (username, status, QR, settings), theme system — uses the new profile columns
4. Step C: one-to-one messaging with Supabase Realtime, built in the new design (the founder decides the encryption approach first)
- Optional: improve the confirmation / reset email templates in the Supabase dashboard
- Later: domain-based email sending (needs a purchased domain; requires the founder's approval)

### Open risks
- Auth emails can land in Spam (BUG-007). Gmail is a personal mail service.
- Gmail sending limits: a third-party source says about 500 emails per day; not verified with Google's documentation.
- Supabase free projects pause after about one week of inactivity (BUG-009). Sources are third-party pricing guides; confirm on Supabase's official pricing page before launch.
- Supabase free Realtime limits (relevant to Step C), per third-party guides: about 200 concurrent connections and 2 million messages per month.

## Public information shown in the app
- Founder name "Md Nazmus Shakib", title "Founder & CEO", portrait photo (approved by the founder to be public).
- Contact email: mizvo.official@gmail.com
- The founder's phone number is intentionally NOT published.
- Vision and Mission text is exactly as written by the founder.

## Supabase configuration (set and checked by the founder in the dashboard)
- Custom SMTP: ON — Gmail (host smtp.gmail.com), sender and username mizvo.official@gmail.com, sender name MIZVO. The Gmail App Password is stored only in the Supabase dashboard and must never be shared or committed.
- Site URL: https://shakib821r.github.io/MIZVO/
- Redirect URLs: https://shakib821r.github.io/MIZVO/ and https://shakib821r.github.io/MIZVO/reset.html
- Database: `public.profiles` (see ARCHITECTURE.md). SQL is run by the founder in the Supabase SQL Editor (role: postgres).
- Only the publishable key is used in frontend code. service_role / secret keys must never be placed in frontend code.

## Working method (Android phone)
- Files are uploaded to GitHub with Add file → Upload files.
- Lesson: Android may rename a downloaded file to "name (1).html" when an older copy exists. GitHub then keeps both files and the live site keeps using the old one. Delete old copies from Downloads before downloading, and check the file list and line count after uploading (see BUGS.md BUG-006).
- Database changes: always inspect first (read-only queries), never drop existing data, and report exact error messages.

## Not verified
- Exact root cause of the earlier "cannot login after logout" bug (best explanation in BUGS.md BUG-001; fix confirmed working).
- Why the verification email went to Spam (BUG-007).
- A real signup with a name longer than 50 characters after the trigger fix (BUG-008): verified only by reading the function source.
