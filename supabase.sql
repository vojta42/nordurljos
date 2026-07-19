-- Norðurljós: žebříček skupin přátel
-- Vložte celé do Supabase SQL Editoru a spusťte (Run).

create table public.players (
  id uuid primary key default gen_random_uuid(),
  group_code text not null,
  secret text not null,
  name text not null check (char_length(name) between 1 and 20),
  xp integer not null default 0 check (xp between 0 and 100000000),
  streak integer not null default 0 check (streak between 0 and 100000),
  lessons integer not null default 0 check (lessons between 0 and 100000),
  level text not null default 'a1' check (level in ('a1','a2','b1','b2','c1')),
  updated_at timestamptz not null default now()
);
create index players_group_idx on public.players (group_code);

-- Zamknout tabulku: žádný přímý přístup zvenčí
alter table public.players enable row level security;
revoke all on public.players from anon, authenticated;

-- Připojení do skupiny (vrátí id hráče)
create or replace function public.join_group(p_group text, p_name text, p_secret text)
returns uuid language plpgsql security definer set search_path = public as $$
declare v_id uuid;
begin
  if char_length(p_group) not between 10 and 40 then raise exception 'bad group code'; end if;
  if char_length(p_secret) < 10 then raise exception 'bad secret'; end if;
  if (select count(*) from players where group_code = p_group) >= 50 then raise exception 'group full'; end if;
  insert into players (group_code, name, secret) values (p_group, left(p_name, 20), p_secret)
  returning id into v_id;
  return v_id;
end $$;

-- Nahrání vlastního pokroku (jen se správným tajným tokenem)
create or replace function public.push_progress(
  p_id uuid, p_secret text, p_name text, p_xp int, p_streak int, p_lessons int, p_level text)
returns boolean language plpgsql security definer set search_path = public as $$
begin
  update players
     set name = left(p_name, 20), xp = p_xp, streak = p_streak,
         lessons = p_lessons, level = p_level, updated_at = now()
   where id = p_id and secret = p_secret;
  return found;
end $$;

-- Žebříček skupiny (jen pro toho, kdo zná kód skupiny)
create or replace function public.get_leaderboard(p_group text)
returns table (name text, xp int, streak int, lessons int, level text, updated_at timestamptz)
language sql security definer set search_path = public stable as $$
  select name, xp, streak, lessons, level, updated_at
    from players where group_code = p_group
   order by xp desc limit 50;
$$;

-- Odchod ze skupiny (smaže vlastní záznam)
create or replace function public.leave_group(p_id uuid, p_secret text)
returns boolean language plpgsql security definer set search_path = public as $$
begin
  delete from players where id = p_id and secret = p_secret;
  return found;
end $$;

grant execute on function public.join_group(text,text,text) to anon;
grant execute on function public.push_progress(uuid,text,text,int,int,int,text) to anon;
grant execute on function public.get_leaderboard(text) to anon;
grant execute on function public.leave_group(uuid,text) to anon;
