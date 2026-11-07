# MIZVO — Architecture

## Overview
- Hosting: GitHub Pages (static files from the `main` branch root)
- Frontend: plain HTML, CSS and JavaScript (no build step)
- Backend: Supabase (Auth). supabase-js v2 loaded from `https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`

## Pages and flow
- `auth.html` — three modes: Login (default), Create Account, Reset Password.
  - signUp / signInWithPassword / resend / resetPasswordForEmail via supabase-js.
  - Signup email redirect: https://shakib821r.github.io/MIZVO/
  - Reset email redirect: https://shakib821r.github.io/MIZVO/reset.html
  - Redirects to `index.html` after login or if a session already exists.
  - Address hints: `#forgot` opens Reset Password mode; `#password-updated` shows the success message.
- `reset.html` — opened from the reset email.
  - Reads the link before the client starts; shows the form only after Supabase's PASSWORD_RECOVERY event (or a session with a recovery link).
  - updateUser({ password }) → signOut → `auth.html#password-updated`.
  - Invalid or expired link → message and "Request a new link" (`auth.html#forgot`).
- `index.html` — main app.
  - On load: `getSession()`. No session → `auth.html`. Session → show app, name and email in Profile.
  - Screens (switched by `showScreen`): chats, conversation, stories, calls, profile, about. Chat data is static demo content.
  - Profile → About MIZVO opens the `about` screen (founder card, Our Vision, Our Mission, Contact). Static text; the founder photo is `founder.jpg` with a letter fallback.
  - Log out → `signOut()` → `auth.html`. A SIGNED_OUT event also redirects to `auth.html`.
- `founder.jpg` — static image served by GitHub Pages.

## Authentication facts
- Email confirmation is required for new accounts (confirmation link redirects to the site root).
- Session is stored by supabase-js in the browser and shared by all pages.
- Display name is saved in user metadata (`display_name`) at signup.
- Supabase Redirect URLs allowed: the site root and `reset.html`.

## Security rules
- Frontend uses only the publishable key.
- Never place service_role or secret keys in frontend code.
- When database tables are added: enable Row Level Security on every table and write explicit policies.

## Database (Supabase Postgres)
- Table `public.profiles` (one row per user):
  - `id` uuid, primary key, references `auth.users(id)` on delete cascade
  - `username` text, unique, format `^[a-z0-9_]{3,20}$`, may be empty
  - `display_name` text, max 50 characters
  - `status` text, max 140 characters
  - `avatar_url` text
  - `created_at`, `updated_at` (kept current by trigger `profiles_set_updated_at`)
- Row Level Security is ON. Policies: "Authenticated users can view profiles" (select, all rows), "Users can update own profile" (update, own row only). No insert policy (the trigger inserts) and no delete.
- Access: `anon` has no access; `authenticated` cannot delete.
- Trigger `on_auth_user_created` on `auth.users` runs `public.handle_new_user()` (security definer, empty search_path): inserts the profile row with the display name from signup metadata, trimmed to 50 characters.
- Email addresses are never stored in `profiles`.
- `index.html` does not read this table yet (planned for the redesign).
- SQL is run in the Supabase SQL Editor as role `postgres`. Always inspect first with read-only queries.

## Platform limits (free plan; third-party summaries, recheck in Supabase documentation)
- Database 500 MB, file storage 1 GB, 50,000 monthly active users.
- Realtime: about 200 concurrent connections and 2 million messages per month.
- Project pauses after about one week of inactivity.

## Email
- Supabase Auth emails (signup confirmation, password reset) are sent through custom SMTP: Gmail, sender mizvo.official@gmail.com, sender name MIZVO.
- The App Password is stored only in the Supabase dashboard (SMTP settings).

## Known limits
- Gmail is a personal mail service: auth emails can land in Spam and there is a daily sending cap (BUGS.md BUG-002, BUG-007).
- Chat data in `index.html` is static demo content.
