# MIZVO — Roadmap

## Done
1. Repository, GitHub Pages, Supabase connection
2. Signup, email verification, login, logout, session persistence
3. Forgot Password / password reset (tested by the founder, 2026-11-07)
4. About MIZVO section (tested by the founder, 2026-11-07)
5. Founder & CEO profile card (tested by the founder, 2026-11-07)
6. Email delivery via Gmail SMTP (works; emails may land in Spam — see BUG-007)

## Next (order agreed with the founder)
- Step B: user profiles table with Row Level Security
- Step C: one-to-one messaging with Supabase Realtime (the founder decides on the encryption approach first; initial messages would be stored as normal text protected by Row Level Security, not end-to-end encrypted)

## Optional / later (needs planning and approval)
- Improve the confirmation and reset email templates (free, may reduce spam placement)
- Domain-based email sending such as Brevo (a domain costs money; needs approval)
- Group chats
- Media sharing (check free-tier storage limits first)
- Push notifications, voice messages, calling (check feasibility within ৳0)
