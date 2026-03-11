# Phase 4: WhatsApp bot — deploy & Twilio setup

## 1. Deploy API to Vercel

1. Push this repo to GitHub (if not already).
2. Go to [Vercel Dashboard](https://vercel.com/dashboard) → **Add New** → **Project** → import the **YARALMA** repo (or the repo that contains `api/whatsapp.js`).
3. **Root Directory:** leave default (repo root).
4. **Environment variables:** Add:
   - `SUPABASE_URL` = your Supabase project URL (Project Settings → API).
   - `SUPABASE_SERVICE_ROLE_KEY` = your Supabase **service_role** key (never use in the Flutter app).
5. Deploy. Note the deployment URL, e.g. `https://yaralma-xxx.vercel.app`.

## 2. Twilio WhatsApp webhook

1. In [Twilio Console](https://console.twilio.com), go to **Messaging** → **Try it out** → **Send a WhatsApp message** (or your WhatsApp Sandbox / sender).
2. Under **When a message comes in**, set:
   - URL: `https://<your-vercel-app>.vercel.app/api/whatsapp`
   - Method: **POST**.
3. Save.

## 3. Link a phone number in the app

For the LOCK/UNLOCK commands to work, the sender’s WhatsApp number must match a profile:

- In Supabase **Table Editor** → `profiles`, set `whatsapp_phone` for the test user to the number you’ll send from (E.164, e.g. `+221771234567`), or digits only (e.g. `221771234567`).
- Or later: add a “Link WhatsApp” step in the Flutter app that saves the parent’s number to `profiles.whatsapp_phone`.

## 4. Test

1. Send **LOCK** to your Twilio WhatsApp Sandbox number from the linked phone.
2. Check Supabase: `profiles.is_locked` for that user should be `true`.
3. Send **UNLOCK**; `is_locked` should be `false`.
4. On the child’s Android device (with YARALMA Shield enabled and app subscribed to that profile), the overlay should appear when `is_locked` is true.
