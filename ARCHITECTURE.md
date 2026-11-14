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
- `index.html` — main app. `getSession()`: no session goes to `auth.html`. Screens (one `showScreen` function): Chats, Conversation, Contacts, Choose/Change username, Profile, Edit profile, My QR code, Settings, Blocked people, About. Reads `display_name`, `username`, `status` from `profiles` for the signed-in user. Contacts finds a person with an exact `username` match. The username screen cleans the input (lowercase a–z, 0–9, _), checks availability with a short delay, then updates the user's own row; the database has the final say (unique, format and reserved-name rules). "Skip for now" is remembered for the browser session only. Log out calls `signOut()`; a SIGNED_OUT event also redirects to `auth.html`.
- Edit profile updates `display_name` (max 50) and `status` (max 140) of the user's own row. Settings: theme buttons, read-only email and language, change password (`auth.updateUser`, with a message when Supabase asks for a recent sign-in), sign out of all devices (`signOut({ scope: "global" })`), and "not available yet" rows for Notifications and Delete account.
- My QR code: `qrcode.js` (self-hosted, MIT) draws an SVG QR code in black on white. It encodes only `https://shakib821r.github.io/MIZVO/?u=<username>`: no email and no private data. Opening the link: signed in, the app shows that person's card in Contacts; signed out, the username is kept in `sessionStorage` (`mizvo-pending-u`), the person signs in, then the card opens.
- Messaging (index.html): the chat list comes from the database function `my_chats()`. Opening a chat loads the latest 50 messages (older ones on request) and calls `mark_chat_read`. Sending inserts into `messages`; new messages arrive through one Realtime channel (`postgres_changes`, INSERT on `messages`); after a reconnect the list and the open chat are reloaded. "Message" on a Contacts card calls `start_direct_chat`. Block and Unblock write to `blocks`; Settings → Blocked people lists and removes blocks.
- `terms.html`, `privacy.html` — static draft pages (Privacy says messages are not end-to-end encrypted).

## Authentication facts
- Email confirmation is required for new accounts. The session is stored by supabase-js in the browser and shared by all pages. The display name is saved in user metadata at signup and copied into `profiles` by a database trigger.
- Supabase Redirect URLs allowed: the site root and `reset.html`.

## Database (Supabase Postgres)
- One table so far: `public.profiles`, one row per user, created by trigger `on_auth_user_created` → `public.handle_new_user()` when a user signs up (display name cut to 50 characters, `search_path` empty).
- Columns: `id` (uuid, primary key, references auth.users, delete cascade), `display_name` (max 50), `username` (unique, 3–20 characters of a–z 0–9 _, empty until chosen), `status` (max 140), `avatar_url`, `created_at`, `updated_at` (kept current by trigger `profiles_set_updated_at`).
- Row Level Security is ON. Policies: signed-in users can read all rows; users can update only their own row. No insert policy (the trigger inserts), no delete, and the anonymous role has no access. The email address is never stored in `profiles`.
- Trigger `profiles_block_reserved_username` (function `mizvo_block_reserved_username`) rejects reserved usernames for app users: anything starting with "mizvo" and a fixed list (admin, support, official, staff, and similar). Roles postgres, supabase_admin and service_role are exempt. The list in `index.html` is only early feedback.
- Messaging tables (all with Row Level Security): `conversations` (one per pair, unique `pair_key`), `conversation_members` (who is in a chat, `last_read_at`), `messages` (1–2,000 characters, sender, server time) and `blocks`. Full record of all scripts: `database.sql`.
- Rules: only members read a chat's messages; a message needs the sender to be the signed-in user, a member, and no block in either direction; messages cannot be edited or deleted; clients may only insert `conversation_id`, `sender_id` and `body`; a person sees only the blocks they made; anonymous users have no access. Helper functions `mizvo_is_member` and `mizvo_can_send` (security definer) avoid circular rules.
- Rate limits: trigger `messages_limit_rate` (function `mizvo_limit_messages`) refuses more than 10 messages per 10 seconds or 600 per hour per sender; `start_direct_chat` refuses more than 20 new chats per hour per person (column `conversations.created_by`). Both raise error code 54000, which the app turns into friendly messages.
- Functions: `start_direct_chat(other)` (creates or reopens the one chat of a pair, refuses blocked or invalid people), `my_chats()` (list with last message and unread count), `mark_chat_read(conv)` (server clock). Realtime publication includes `messages`.
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
