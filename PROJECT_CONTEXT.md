# MIZVO — Project Context

Last updated: 2026-11-07

## Identity
- Name: MIZVO — a worldwide messaging app (goal; not yet built)
- Founder / decision-maker: Md Nazmus Shakib (GitHub: shakib821r)
- Repository: https://github.com/shakib821r/MIZVO (public)
- Live site: https://shakib821r.github.io/MIZVO/ (GitHub Pages, main branch, root)
- Stack: HTML, CSS, JavaScript, Supabase (Auth), supabase-js v2
- Budget: strictly ৳0 — free tools and free tiers only; no paid service without the founder's approval

## Files in the repository
- `index.html` — main app screen (demo chat UI with static data). Checks the Supabase session, Profile shows name and email, About MIZVO screen, Log out.
- `auth.html` — Login (default), Create Account, Resend Verification Email, Forgot Password (reset link request). Redirects to `index.html` after login or when a session exists.
- `reset.html` — set a new password after opening the emailed reset link.
- `founder.jpg` — founder's portrait for the About MIZVO screen (re-encoded, no EXIF data).
- `README.md`
- Documentation: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md

## Progress log

### Completed and tested (reported by the founder)
- Signup with a new email: verification email received, link opens the site.
- Login, logout, session persistence, wrong-password message (2026-11-07).
- Forgot Password: reset link email, new password page, password changed, login with the new password, reused link shows an expired message — all 8 tests reported OK (2026-11-07).
- About MIZVO (Profile → About MIZVO): founder photo, name and "Founder & CEO", Our Vision, Our Mission, contact email, back navigation — all 5 tests reported OK (2026-11-07).

### Pending (next step to be chosen by the founder)
- Fix email delivery for real users with a free custom SMTP provider (BUG-002)
- User profiles table with Row Level Security
- Real messaging (database tables, realtime), groups, media, notifications

### Blocked / open risks
- Custom SMTP is OFF in Supabase. The default email service has strict limits (see BUGS.md BUG-002). Verification and reset emails reached the founder's test addresses, but delivery to outside users at scale is not verified.

## Public information shown in the app
- Founder name "Md Nazmus Shakib", title "Founder & CEO", portrait photo (approved by the founder to be public).
- Contact email: mizvo.official@gmail.com
- The founder's phone number is intentionally NOT published.
- Vision and Mission text is exactly as written by the founder.

## Supabase configuration (set and checked by the founder in the dashboard)
- Custom SMTP: OFF
- Site URL: https://shakib821r.github.io/MIZVO/
- Redirect URLs: https://shakib821r.github.io/MIZVO/ and https://shakib821r.github.io/MIZVO/reset.html
- Only the publishable key is used in frontend code. service_role / secret keys must never be placed in frontend code.

## Working method (Android phone)
- Files are uploaded to GitHub with Add file → Upload files.
- Lesson: Android may rename a downloaded file to "name (1).html" when an older copy exists. GitHub then keeps both files and the live site keeps using the old one. Delete old copies from Downloads before downloading, and check the file list and line count after uploading (see BUGS.md BUG-006).

## Not verified
- Email delivery to addresses outside the Supabase team at larger scale.
- Exact root cause of the earlier "cannot login after logout" bug (best explanation in BUGS.md BUG-001; fix confirmed working).
