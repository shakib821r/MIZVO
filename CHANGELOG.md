# MIZVO — Changelog

## 2026-11-07
- `auth.html`: Login is now the default mode; redirects to `index.html` after login or when a session exists; friendlier error messages (wrong password, email not verified); extra hint in the signup message; errors logged to the browser console. Supabase URL, publishable key and redirect URL unchanged.
- `index.html`: added Supabase session check (redirects to `auth.html` when logged out), name and email in Profile, Log out button. Existing demo UI and functions unchanged.
- Added documentation files: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md.

## Before 2026-11-07 (exact dates not recorded)
- Created the public GitHub repository and enabled GitHub Pages (main branch, root).
- Connected Supabase Auth.
- Created `auth.html` (signup, login, resend verification) and later replaced it with a corrected version.
- Created the demo `index.html` chat interface.
