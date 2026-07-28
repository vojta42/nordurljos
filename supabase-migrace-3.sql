-- Migrace 3: logování dokončení lekce (každé dokončení, ne jen první)
-- Vložte celé do Supabase SQL Editoru a spusťte (Run).

alter table public.stats_events drop constraint stats_events_kind_check;
alter table public.stats_events add constraint stats_events_kind_check
  check (kind in ('install','profile','group','first_lesson','level','lesson'));

create or replace function public.track(p_kind text, p_meta text default '')
returns void language plpgsql security definer set search_path = public as $$
begin
  if p_kind not in ('install','profile','group','first_lesson','level','lesson') then return; end if;
  insert into stats_events(kind, meta) values (p_kind, left(coalesce(p_meta,''), 20));
end $$;

create or replace function public.get_stats()
returns json language sql security definer set search_path = public stable as $$
  select json_build_object(
    'installs',      (select count(*) from stats_events where kind='install'),
    'profiles',      (select count(*) from stats_events where kind='profile'),
    'groups',        (select count(*) from stats_events where kind='group'),
    'first_lessons', (select count(*) from stats_events where kind='first_lesson'),
    'levels',        (select coalesce(json_object_agg(meta, c), '{}'::json)
                        from (select meta, count(*) c from stats_events
                               where kind='level' group by meta) t),
    'lessons_done',  (select count(*) from stats_events where kind='lesson')
  );
$$;
