# MIZVO — Changelog

## 2026-11-07
- Database (Step B), run by the founder in the Supabase SQL Editor:
  - Found that `public.profiles` already existed (id, display_name, avatar_url, created_at; 3 rows; read-all and update-own policies; signup trigger). Kept all data and policies.
  - Added columns `username` (unique, 3–20 chars of a–z, 0–9, _), `status` (max 140), `updated_at`; added length checks; revoked anonymous access and delete; added an `updated_at` trigger.
  - Tested the security rules with a rolled-back script (read all, no editing of others, no delete, username format, anonymous blocked): all passed.
  - Changed the signup trigger function `handle_new_user` to cut `display_name` to 50 characters (BUG-008).
- Email delivery:
  - Supabase dashboard: enabled custom SMTP with Gmail (mizvo.official@gmail.com, sender name MIZVO). Credentials stored only in Supabase.
  - `auth.html`: signup success message now also says to check the Spam folder.
- About MIZVO:
  - `index.html`: Profile → "About MIZVO" button, new About screen (founder card with photo, name and "Founder & CEO"; Our Vision; Our Mission; Contact email) and a Back button. Photo falls back to an initial if it cannot load. Existing login, logout and demo UI unchanged.
  - `founder.jpg` (new): founder portrait, re-encoded to about 20 KB with no EXIF data.
- Forgot Password feature:
  - `auth.html`: added "Forgot Password?" link, Reset Password mode (Send Reset Link), support for `#forgot` and `#password-updated` in the address, friendlier messages for email rate limits and network errors.
  - `reset.html` (new): checks the recovery link, new password and confirm password, updates the password, signs out, returns to `auth.html`. Shows an expired-link message with a "Request a new link" button.
  - Supabase dashboard: added Redirect URL https://shakib821r.github.io/MIZVO/reset.html.
- Fixed duplicate file `auth (1).html` (renamed to `auth.html`).
- `auth.html`: Login is now the default mode; redirects to `index.html` after login or when a session exists; friendlier error messages (wrong password, email not verified); extra hint in the signup message; errors logged to the browser console. Supabase URL, publishable key and redirect URL unchanged.
- `index.html`: added Supabase session check (redirects to `auth.html` when logged out), name and email in Profile, Log out button.
- Added documentation files: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md.

## Before 2026-11-07 (exact dates not recorded)
- Created the public GitHub repository and enabled GitHub Pages (main branch, root).
- Connected Supabase Auth.
- Created `auth.html` (signup, login, resend verification) and later replaced it with a corrected version.
- Created the demo `index.html` chat interface.
