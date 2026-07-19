-- Migrace 2: anonymní statistiky aplikace
-- Vložte celé do Supabase SQL Editoru a spusťte (Run).

create table public.stats_events (
  id bigint generated always as identity primary key,
  kind text not null check (kind in ('install','profile','group','first_lesson','level')),
  meta text not null default '',
  created_at timestamptz not null default now()
);
alter table public.stats_events enable row level security;
revoke all on public.stats_events from anon, authenticated;

-- zápis jedné anonymní události (bez jakýchkoli osobních dat)
create or replace function public.track(p_kind text, p_meta text default '')
returns void language plpgsql security definer set search_path = public as $$
begin
  if p_kind not in ('install','profile','group','first_lesson','level') then return; end if;
  insert into stats_events(kind, meta) values (p_kind, left(coalesce(p_meta,''), 20));
end $$;

-- souhrnné statistiky pro stránku „O aplikaci“
create or replace function public.get_stats()
returns json language sql security definer set search_path = public stable as $$
  select json_build_object(
    'installs',      (select count(*) from stats_events where kind='install'),
    'profiles',      (select count(*) from stats_events where kind='profile'),
    'groups',        (select count(*) from stats_events where kind='group'),
    'first_lessons', (select count(*) from stats_events where kind='first_lesson'),
    'levels',        (select coalesce(json_object_agg(meta, c), '{}'::json)
                        from (select meta, count(*) c from stats_events
                               where kind='level' group by meta) t)
  );
$$;

grant execute on function public.track(text,text) to anon;
grant execute on function public.get_stats() to anon;
