# MIZVO — Architecture

## Overview
- Hosting: GitHub Pages (static files from the `main` branch root)
- Frontend: plain HTML, CSS and JavaScript (no build step)
- Backend: Supabase (Auth and Postgres). supabase-js v2 loaded from `https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`
- Fonts: Sora and Manrope from Google Fonts, with system fallbacks

## Design layer
- `mizvo.css`: CSS variables for light and dark (`:root` and `:root[data-theme="dark"]`), shared components (page, fields, buttons, links, messages, app shell, cards, segmented control, bottom navigation) and the busy animation. Respects reduced motion.
- `mizvo-theme.js`: loaded in `<head>`; applies Light / Dark / System before the page paints; stores the choice under the key `mizvo-theme` in the browser; exposes `window.MizvoTheme.get()` and `.set()`.

## Pages and flow
- `auth.html` — modes Sign in (default), Create account, Reset password. signUp / signInWithPassword / resend / resetPasswordForEmail. Signup email redirect: the site root. Reset email redirect: `reset.html`. Redirects to `index.html` after sign-in or if a session exists. Address hints: `#forgot`, `#signup`, `#password-updated`.
- `reset.html` — opened from the reset email. Reads the link before the client starts; shows the form only after Supabase's PASSWORD_RECOVERY event (or a session with a recovery link); `updateUser({ password })`, then `signOut`, then `auth.html#password-updated`. Invalid or expired link: message and "Request a new link" (`auth.html#forgot`).
- `index.html` — main app. `getSession()`: no session goes to `auth.html`. Screens (one `showScreen` function): Chats (empty state), Profile, About. Reads `display_name`, `username`, `status` from `profiles` for the signed-in user. Log out calls `signOut()`; a SIGNED_OUT event also redirects to `auth.html`.
- `terms.html`, `privacy.html` — static draft pages.

## Authentication facts
- Email confirmation is required for new accounts. The session is stored by supabase-js in the browser and shared by all pages. The display name is saved in user metadata at signup and copied into `profiles` by a database trigger.
- Supabase Redirect URLs allowed: the site root and `reset.html`.

## Database (Supabase Postgres)
- One table so far: `public.profiles`, one row per user, created by trigger `on_auth_user_created` → `public.handle_new_user()` when a user signs up (display name cut to 50 characters, `search_path` empty).
- Columns: `id` (uuid, primary key, references auth.users, delete cascade), `display_name` (max 50), `username` (unique, 3–20 characters of a–z 0–9 _, empty until chosen), `status` (max 140), `avatar_url`, `created_at`, `updated_at` (kept current by trigger `profiles_set_updated_at`).
- Row Level Security is ON. Policies: signed-in users can read all rows; users can update only their own row. No insert policy (the trigger inserts), no delete, and the anonymous role has no access. The email address is never stored in `profiles`.
- SQL is run in the Supabase SQL Editor as role `postgres`. Inspect first with read-only queries.

## Email
- Supabase Auth emails go through custom SMTP: Gmail, sender mizvo.official@gmail.com, sender name MIZVO. The App Password is stored only in the Supabase dashboard.

## Security rules
- Frontend uses only the publishable key. Never place service_role or secret keys in frontend code.
- Add Row Level Security and explicit policies to every new table.
- Text from users is shown with `textContent`, never inserted as HTML.

## Known limits
- Gmail is a personal mail service: auth emails can land in Spam and there is a daily cap (BUG-002, BUG-007).
- Free Supabase projects pause after inactivity (BUG-009).
- GitHub Pages serves static files only: no server code and no custom security headers.
- No messaging yet; Chats shows an empty state.
