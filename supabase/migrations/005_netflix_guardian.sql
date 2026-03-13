-- YARALMA Phase 10: Netflix Guardian tables for blur scenes and hidden titles.
-- Run this in Supabase Dashboard > SQL Editor after 004_blocked_keywords.sql.

-- Blur scenes: timestamps within Netflix content to overlay-blur
create table if not exists public.blur_scenes (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  season int,
  episode int,
  start_seconds int not null,
  end_seconds int not null,
  reason text,
  created_at timestamptz default now(),
  created_by uuid references public.profiles(id) on delete set null
);

create index if not exists idx_blur_scenes_title on public.blur_scenes(title);

-- Hidden titles: Netflix titles to hide from catalog (thumbnails)
create table if not exists public.hidden_titles (
  id uuid default gen_random_uuid() primary key,
  title text not null unique,
  netflix_id text,
  reason text,
  created_at timestamptz default now()
);

-- RLS: anyone can read (community-sourced list)
alter table public.blur_scenes enable row level security;
alter table public.hidden_titles enable row level security;

create policy "Anyone can read blur_scenes"
  on public.blur_scenes for select
  using (true);

create policy "Anyone can read hidden_titles"
  on public.hidden_titles for select
  using (true);

-- Sample data: Lion Guardian list
insert into public.blur_scenes (title, season, episode, start_seconds, end_seconds, reason) values
  ('Money Heist', 1, 2, 1245, 1290, 'Intimate scene'),
  ('Money Heist', 2, 5, 2100, 2180, 'Violence'),
  ('Squid Game', 1, 1, 3420, 3500, 'Graphic violence')
on conflict do nothing;

insert into public.hidden_titles (title, reason) values
  ('365 Days', 'Adult content'),
  ('Sex Education', 'Not age-appropriate'),
  ('Euphoria', 'Mature themes')
on conflict (title) do nothing;

comment on table public.blur_scenes is 'Lion Guardian: timestamps to blur in Netflix content.';
comment on table public.hidden_titles is 'Netflix titles to hide from catalog view.';
