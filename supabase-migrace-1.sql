-- Migrace 1: týdenní závod + úroveň C2
-- Vložte celé do Supabase SQL Editoru a spusťte (Run).

alter table public.players drop constraint players_level_check;
alter table public.players add constraint players_level_check
  check (level in ('a1','a2','b1','b2','c1','c2'));

alter table public.players add column if not exists week_key text not null default '';
alter table public.players add column if not exists week_xp integer not null default 0
  check (week_xp between 0 and 100000000);

-- push_progress nově přijímá i týdenní XP; stará verze se ruší
drop function if exists public.push_progress(uuid,text,text,int,int,int,text);

create or replace function public.push_progress(
  p_id uuid, p_secret text, p_name text, p_xp int, p_streak int, p_lessons int,
  p_level text, p_week_key text, p_week_xp int)
returns boolean language plpgsql security definer set search_path = public as $$
begin
  update players
     set name = left(p_name, 20), xp = p_xp, streak = p_streak, lessons = p_lessons,
         level = p_level, week_key = p_week_key, week_xp = p_week_xp, updated_at = now()
   where id = p_id and secret = p_secret;
  return found;
end $$;

-- get_leaderboard nově vrací i týdenní sloupce (změna návratového typu => drop + create)
drop function if exists public.get_leaderboard(text);

create function public.get_leaderboard(p_group text)
returns table (name text, xp int, streak int, lessons int, level text,
               week_key text, week_xp int, updated_at timestamptz)
language sql security definer set search_path = public stable as $$
  select name, xp, streak, lessons, level, week_key, week_xp, updated_at
    from players where group_code = p_group
   order by xp desc limit 50;
$$;

grant execute on function public.push_progress(uuid,text,text,int,int,int,text,text,int) to anon;
grant execute on function public.get_leaderboard(text) to anon;
