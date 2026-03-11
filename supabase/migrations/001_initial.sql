-- YARALMA Phase 2: profiles table, RLS, and WhatsApp link column (for Phase 4).
-- Run this in Supabase Dashboard > SQL Editor (New query), then run it.

-- Profiles: one row per auth user (parent). Child device subscribes to this for is_locked.
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  parent_name text,
  faith_shield text check (faith_shield in ('mouride', 'tijaniyya', 'general_muslim', 'christian')),
  whatsapp_phone text,  -- E.164 for Phase 4 LOCK webhook lookup
  is_locked boolean default false,
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

-- Users can read their own profile
create policy "Users can read own profile"
  on public.profiles for select
  using (auth.uid() = id);

-- Users can update their own profile
create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Allow insert for the same user (e.g. on first sign-up)
create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Service role (Vercel/WhatsApp bot) can update is_locked by id or whatsapp_phone;
-- RLS does not apply to service role, so no policy needed for that.

comment on table public.profiles is 'YARALMA parent profiles; is_locked drives the Android overlay.';
