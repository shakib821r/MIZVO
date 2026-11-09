# MIZVO — Roadmap

## Done
1. Repository, GitHub Pages, Supabase connection
2. Signup, email verification, login, logout, session persistence
3. Forgot Password / password reset
4. About MIZVO and Founder & CEO card
5. Email delivery via Gmail SMTP (works; emails may land in Spam — BUG-007)
6. Step B: profiles table with username, status and security rules
7. Redesign (concept B "Halves"): design system, theme (Light / Dark / System), auth screens, reset screen, Terms and Privacy drafts, app shell with Chats, Profile and About — all tested by the founder (2026-11-08)
8. Contacts (find by exact @username) and choose/change @username with reserved-name protection — tested by the founder (2026-11-08)
9. Profile Identity Card: Edit profile, Settings, My QR code with scan-to-open links — reported working by the founder (2026-11-08)

## Next (order agreed with the founder; steps are given three at a time)
- Step C planning: decide the storage and encryption approach and the first-version scope
- Step C build: database tables with Row Level Security (conversations, members, messages), a safe "start chat" function, Realtime delivery, the Conversation screen and the real chat list, built in the new design
- After Step C: blocking users, message deletion, read receipts, notifications (each needs its own plan)

## Optional / later (needs planning and approval)
- Improve the confirmation and reset email templates (free, may reduce spam placement)
- Domain-based email sending such as Brevo (a domain costs money; needs approval)
- Avatar photo upload (Supabase Storage, free tier 1 GB — confirm limits)
- Delete account (needs a server function), push notifications, group chats, media sharing, voice messages, calling (check feasibility within ৳0)
- Self-host the fonts; pin the Supabase library to an exact version; stronger password rules (Supabase setting)
