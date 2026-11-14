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
10. One-to-one messaging with unread badges, real-time delivery and Block — tested by the founder with two accounts (2026-11-09)
11. Message and new-chat rate limits — database test passed (2026-11-13)

## Next (steps are given three at a time)
- Better email templates for confirmation and password reset (free; may reduce Spam placement)
- Abuse reporting: a Report button, a table of reports and a review routine
- Data export routine and keeping the project active
- A knowledgeable review of Terms and Privacy
- Then: message deletion, read receipts, notifications (each needs its own plan)

## Optional / later (needs planning and approval)
- Improve the confirmation and reset email templates (free, may reduce spam placement)
- Domain-based email sending such as Brevo (a domain costs money; needs approval)
- Avatar photo upload (Supabase Storage, free tier 1 GB — confirm limits)
- Delete account (needs a server function), push notifications, group chats, media sharing, voice messages, calling (check feasibility within ৳0)
- Self-host the fonts; pin the Supabase library to an exact version; stronger password rules (Supabase setting)
