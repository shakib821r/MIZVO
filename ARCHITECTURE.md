# MIZVO — Architecture

## Overview
- Hosting: GitHub Pages (static files from the `main` branch root)
- Frontend: plain HTML, CSS and JavaScript (no build step)
- Backend: Supabase (Auth). supabase-js v2 loaded from `https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2`

## Pages and flow
- `auth.html` — Login (default), Create Account, Resend Verification Email.
  - signUp / signInWithPassword / resend via supabase-js.
  - Email redirect URL: https://shakib821r.github.io/MIZVO/
  - Redirects to `index.html` after login or if a session already exists.
- `index.html` — main app (demo UI).
  - On load: `getSession()`. No session → `auth.html`. Session → show app, name and email in Profile.
  - Log out → `signOut()` → `auth.html`. A SIGNED_OUT event also redirects to `auth.html`.

## Authentication facts
- Email confirmation is required for new accounts (confirmation email link redirects to the site root).
- Session is stored by supabase-js in the browser and shared by both pages.
- Display name is saved in user metadata (`display_name`) at signup.

## Security rules
- Frontend uses only the publishable key.
- Never place service_role or secret keys in frontend code.
- When database tables are added: enable Row Level Security on every table and write explicit policies.

## Known limits
- Default Supabase email service (custom SMTP is off): see BUGS.md BUG-002.
- Chat data in `index.html` is static demo content.
