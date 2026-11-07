# MIZVO — Roadmap

## Done
1. Repository, GitHub Pages, Supabase connection
2. Signup, email verification, login, logout, session persistence
3. Forgot Password / password reset (tested by the founder, 2026-11-07)
4. About MIZVO section (tested by the founder, 2026-11-07)
5. Founder & CEO profile card (tested by the founder, 2026-11-07)
6. Email delivery via Gmail SMTP (works; emails may land in Spam — see BUG-007)
7. Step B: profiles table with username, status and security rules (tested in the SQL Editor, 2026-11-07)

## Next (order agreed with the founder; each stage needs his approval)
- Stage 1: audit of the current project (no code changes)
- Stage 2: three different brand identity directions (logo, icon, typography, colors, sample UI) — the founder picks one
- Stage 3: five Design Signatures and the design system — the founder approves
- Stage 4: screen designs (Login, Signup, Forgot Password, Chat list, Conversation, Contacts, Profile "Identity Card", Settings, About) — the founder approves
- Stage 5: implementation, one screen at a time, preserving working features; includes username choice and validation, Edit Profile that really saves, QR profile code, working settings, dark/light/system theme
- Stage 6: testing (login, signup, logout, session, forgot password, profile updates, username validation, QR, settings, themes, mobile)
- Step C: one-to-one messaging with Supabase Realtime, built in the new design (the founder decides the encryption approach first; initial messages would be stored as normal text protected by Row Level Security, not end-to-end encrypted)

## Optional / later (needs planning and approval)
- Improve the confirmation and reset email templates (free, may reduce spam placement)
- Domain-based email sending such as Brevo (a domain costs money; needs approval)
- Avatar photo upload (Supabase Storage, free tier 1 GB — confirm limits)
- Group chats, media sharing, push notifications, voice messages, calling (check feasibility within ৳0)
