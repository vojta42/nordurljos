-- Migrace 4: jméno hráče u logů (pro debug) — veřejné statistiky (get_stats)
-- zůstávají anonymní/agregované beze změny, get_stats() sloupec player_name nikdy nečte.
-- Vložte celé do Supabase SQL Editoru a spusťte (Run).

alter table public.stats_events add column player_name text not null default '';

drop function if exists public.track(text,text);

create function public.track(p_kind text, p_meta text default '', p_player text default '')
returns void language plpgsql security definer set search_path = public as $$
begin
  if p_kind not in ('install','profile','group','first_lesson','level','lesson') then return; end if;
  insert into stats_events(kind, meta, player_name) values (p_kind, left(coalesce(p_meta,''), 20), left(coalesce(p_player,''), 20));
end $$;

grant execute on function public.track(text,text,text) to anon;
