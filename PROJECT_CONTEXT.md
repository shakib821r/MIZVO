# MIZVO — Project Context

Last updated: 2026-11-07

## Identity
- Name: MIZVO — a worldwide messaging app (goal; not yet built)
- Founder / decision-maker: Nazmus (GitHub: shakib821r)
- Repository: https://github.com/shakib821r/MIZVO (public)
- Live site: https://shakib821r.github.io/MIZVO/ (GitHub Pages, main branch, root)
- Stack: HTML, CSS, JavaScript, Supabase (Auth), supabase-js v2
- Budget: strictly ৳0 — free tools and free tiers only; no paid service without the founder's approval

## Files in the repository
- `index.html` — main app screen (demo chat UI with static data). Checks the Supabase session, shows name and email in Profile, has Log out.
- `auth.html` — login / create account / resend verification. Login is the default mode. Redirects to `index.html` after login or when a session already exists.
- `README.md`
- Documentation: PROJECT_CONTEXT.md, ARCHITECTURE.md, ROADMAP.md, BUGS.md, CHANGELOG.md, DECISIONS.md

## Progress log

### Completed and tested (reported by the founder)
- Signup with a new email: verification email received, link opens the site (2026-11).
- Login, logout, session persistence, wrong-password message (tests reported "All okay" on 2026-11-07).
- Login/Signup toggle works.
- `index.html` redirects to `auth.html` when logged out; Profile shows the user's email; Log out works.

### Pending
- Priority 3: Forgot Password / password reset
- Priority 4: About MIZVO section (Profile → About MIZVO)
- Priority 5: Founder & CEO profile card (needs the founder's real name, photo and text)
- Real messaging (database tables, Row Level Security, realtime), user profiles, groups, media, notifications

### Blocked / open risks
- Custom SMTP is OFF in Supabase. The default email service has strict limits (see BUGS.md BUG-002).

## Supabase configuration (verified in the dashboard by the founder)
- Custom SMTP: OFF
- Site URL and Redirect URLs include https://shakib821r.github.io/MIZVO/
- Only the publishable key is used in frontend code. service_role / secret keys must never be placed in frontend code.

## Not verified
- Whether emails reach addresses outside the Supabase team on the default email service at larger scale.
- Exact root cause of the earlier "cannot login after logout" bug (see BUGS.md BUG-001).
