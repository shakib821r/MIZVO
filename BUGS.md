# MIZVO — Bugs

## BUG-001 — Cannot log in again after logout
- Status: Fixed. Founder tested login, logout, session persistence and wrong password on 2026-11-07 and reported "All okay".
- Symptom: After Log out, logging in again did not work.
- Most likely cause (from code review, not proven by logs): `auth.html` always opened in "Create Account" mode, so pressing the button after logout sent a signup request (Supabase returns a generic success for an already-registered email and does not log in). Also, after a successful login the page only showed a message and did not open the app.
- Fix: `auth.html` now opens in Login mode, redirects to `index.html` after login, and skips itself when a session already exists.

## BUG-002 — Default email service limits
- Status: Mitigated (2026-11-07).
- Cause: Supabase's default email service delivers only to project team members and has a very low hourly email limit.
- Fix: custom SMTP enabled using Gmail (mizvo.official@gmail.com, App Password stored only in the Supabase dashboard). A test to an outside address delivered successfully.
- Remaining limits: Gmail daily sending cap (about 500 per day per a third-party source; not verified) and spam placement (BUG-007). A domain-based provider is the long-term fix and needs the founder's approval because a domain costs money.

## BUG-003 — Signup with an already-verified email shows a generic success message
- Status: Mitigated (by design in Supabase).
- Supabase intentionally returns a success-like response and sends no email. This prevents revealing which emails are registered.
- Mitigation: the message also says "Already registered? Use the Login link below."

## BUG-004 — Earlier auth.html problems (resend button unclickable, page reset, toggle stuck)
- Status: Resolved by the replacement auth.html; toggle and signup confirmed working in tests.

## BUG-005 — index.html shows demo data only (open, expected)
- Chats, stories and messages are static demo content. Real messaging is not implemented yet.

## BUG-006 — Upload created a duplicate file "auth (1).html" (2026-11-07)
- Status: Resolved.
- Symptom: "Forgot Password?" did not appear on the live site. GitHub had `auth.html` (old, 201 lines) and `auth (1).html` (new, 275 lines).
- Cause: Android renamed the downloaded file to "auth (1).html"; uploading it created a new file instead of replacing `auth.html`.
- Fix: deleted the old `auth.html`, renamed `auth (1).html` to `auth.html` on GitHub.
- Prevention: after every upload, check the file list for names with "(1)" and confirm the line count of the changed file.
- Seen again on 2026-11-08: the new `index.html` was not live at first (new Profile rows missing). The exact cause was not confirmed (a renamed duplicate file or an old cached page); it worked after the file list and line count were checked again.

## BUG-007 — Verification email lands in Spam (open, mitigated)
- Status: Open; mitigated in the interface.
- Symptom: a signup test to a new outside address delivered the email from sender "Mizvo" to the Spam folder. The recipient's mail service said it looked similar to messages previously marked as spam.
- Likely factors (not confirmed): very short default email template, new sender with no history, personal Gmail account used as the sender (Supabase warns that it is a personal rather than transactional provider).
- Mitigation done: the signup message tells users to check the Spam folder (the resend and reset messages already did).
- Possible next steps: improve the email templates in the Supabase dashboard (free, no guarantee); domain-based sending (costs money, needs approval).

## BUG-008 — Long display name could break signup (found and fixed 2026-11-07)
- Status: Fixed (verified by reading the function source; not yet tested with a real signup).
- Cause: a rule added to `public.profiles` limits `display_name` to 50 characters, but the signup trigger `handle_new_user` copied the name without cutting it, so a name longer than 50 characters could make account creation fail.
- Fix: the trigger now uses `left(..., 50)`.
- Follow-up: test a real signup with a long name during the next test round.

## BUG-009 — Free Supabase project pauses after inactivity (open risk)
- Status: Open (platform limit, not a code bug).
- Third-party pricing guides say free projects pause after about one week of inactivity. A paused project makes the app stop working until it is restored from the Supabase dashboard.
- Mitigation: check the project regularly; confirm the rule on Supabase's official pricing page; plan before real users arrive (any paid option needs the founder's approval).

- Confirmed on Supabase's own pages (2026-11-13): free projects are paused when they have too little database activity over 7 days, the owner gets a warning email about a week earlier, and the project is resumed from the dashboard. A few database requests per day usually keep it active, but this is not a guarantee. Their pages differ on how long a paused project can be restored (90 days or 1 year), so resume it quickly.

## BUG-010 — Clients could choose the message time (found and fixed 2026-11-09, before launch)
- Status: Fixed.
- Cause: the first messaging permissions let a signed-in person insert a value for `created_at`, so someone could place messages in the past or future and distort ordering and unread counts.
- Fix: insert permission is limited to `conversation_id`, `sender_id` and `body` (same for blocks); "mark as read" uses the server clock through `mark_chat_read`.
- Check: a rolled-back test confirmed that setting the time is refused.
