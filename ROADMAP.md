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

## Next (order agreed with the founder; each step is tested before the next)
- Redesign step 3: Profile "Identity Card" — Edit profile that really saves (name, status, @username), QR profile code (contains only a username-based link; opening it requires sign-in)
- Redesign step 4: Settings screen — theme, change password, sign out of all devices; Notifications and Delete account stay marked "later" until they are real
- Step C: one-to-one messaging with Supabase Realtime and the Conversation screen, built in the new design (the founder decides the encryption approach first; initial messages would be normal text protected by Row Level Security, not end-to-end encrypted)

## Optional / later (needs planning and approval)
- Improve the confirmation and reset email templates (free, may reduce spam placement)
- Domain-based email sending such as Brevo (a domain costs money; needs approval)
- Avatar photo upload (Supabase Storage, free tier 1 GB — confirm limits)
- Delete account (needs a server function), push notifications, group chats, media sharing, voice messages, calling (check feasibility within ৳0)
- Self-host the fonts; pin the Supabase library to an exact version; stronger password rules (Supabase setting)
