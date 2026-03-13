-- YARALMA Phase 9: blocked_keywords table for YouTube Guardian.
-- Run this in Supabase Dashboard > SQL Editor after 003_usage_stats.sql.

-- Blocked keywords for search filtering (Wolof/French)
create table if not exists public.blocked_keywords (
  id uuid default gen_random_uuid() primary key,
  keyword text not null unique,
  language text check (language in ('wolof', 'french', 'english', 'other')),
  category text check (category in ('adult', 'violence', 'gambling', 'other')),
  created_at timestamptz default now()
);

-- Insert default blocked keywords (Wolof and French)
insert into public.blocked_keywords (keyword, language, category) values
  -- French
  ('porno', 'french', 'adult'),
  ('sexe', 'french', 'adult'),
  ('xxx', 'other', 'adult'),
  ('nu', 'french', 'adult'),
  ('nue', 'french', 'adult'),
  ('seins', 'french', 'adult'),
  ('drogue', 'french', 'other'),
  ('violence', 'french', 'violence'),
  ('arme', 'french', 'violence'),
  ('casino', 'french', 'gambling'),
  ('pari', 'french', 'gambling'),
  -- Wolof (common terms)
  ('takk', 'wolof', 'adult'),
  ('jigeen bu nit', 'wolof', 'adult'),
  ('gor bu nit', 'wolof', 'adult'),
  -- English
  ('porn', 'english', 'adult'),
  ('naked', 'english', 'adult'),
  ('nude', 'english', 'adult'),
  ('sex', 'english', 'adult'),
  ('gun', 'english', 'violence'),
  ('drugs', 'english', 'other')
on conflict (keyword) do nothing;

-- RLS: anyone can read (for caching in app)
alter table public.blocked_keywords enable row level security;

create policy "Anyone can read blocked_keywords"
  on public.blocked_keywords for select
  using (true);

comment on table public.blocked_keywords is 'Blocked search keywords for YouTube Guardian (Wolof/French/English).';
