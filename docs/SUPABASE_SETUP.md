# Supabase setup (Phase 2)

Do this once so the app and WhatsApp bot can use your backend.

## 1. Create a project

1. Go to [Supabase Dashboard](https://supabase.com/dashboard) and sign in.
2. **New project** → choose org, name (e.g. `yaralma`), database password, region.
3. Wait for the project to be ready.

## 2. Run the migration

1. In the project, open **SQL Editor** → **New query**.
2. Open `supabase/migrations/001_initial.sql` in this repo and copy its full contents.
3. Paste into the SQL Editor and click **Run**.
4. Confirm: **Table Editor** should show a `profiles` table with columns `id`, `parent_name`, `faith_shield`, `whatsapp_phone`, `is_locked`, `updated_at`.

## 3. Enable Realtime

1. Go to **Database** → **Replication**.
2. Find `profiles` and turn **Realtime** ON so the child device can react to `is_locked` changes.

## 4. Enable Auth

1. Go to **Authentication** → **Providers**.
2. Enable at least one provider (e.g. **Email** or **Google**) so `auth.users` exists and `profiles.id` can reference it.

## 5. Get API keys

1. Go to **Project Settings** (gear) → **API**.
2. Copy **Project URL** and **anon public** key.
3. In the app: edit `yaralma_app/assets/config.env` and set:
   - `SUPABASE_URL=<your Project URL>`
   - `SUPABASE_ANON_KEY=<your anon key>`
4. For the WhatsApp bot (Phase 4): copy the **service_role** key and add it to Vercel env as `SUPABASE_SERVICE_ROLE_KEY` (never put service_role in the Flutter app).

## 6. (Optional) Supabase CLI

If you use the Supabase CLI and `supabase link`, you can run migrations with:

```bash
supabase db push
```

Otherwise running the SQL in the Dashboard (step 2) is enough.
