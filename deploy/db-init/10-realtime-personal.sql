-- ============================================================================
-- Glint — Realtime para los datos personales (sync instantáneo entre dispositivos)
-- ============================================================================
-- Añade las tablas personales a la publicación supabase_realtime para que un
-- cambio hecho en un dispositivo llegue al instante a los demás (el cliente,
-- al recibir el evento, dispara una sincronización). RLS sigue aislando cada
-- usuario. REPLICA IDENTITY FULL para que los DELETE también viajen completos.
--
-- Idempotente. Requiere Realtime desplegado (publicación supabase_realtime).
-- Aplicar:
--   docker exec -i glint-db psql -U postgres -d postgres < deploy/db-init/10-realtime-personal.sql
-- ============================================================================

do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array[
      'habits','habit_completions','transactions','budgets','savings_goals',
      'debts','recurring_expenses','notes','events','routines'
    ]
    loop
      if to_regclass('public.' || t) is not null then
        if not exists (
          select 1 from pg_publication_tables
           where pubname = 'supabase_realtime'
             and schemaname = 'public' and tablename = t
        ) then
          execute format('alter publication supabase_realtime add table public.%I', t);
        end if;
        execute format('alter table public.%I replica identity full', t);
      end if;
    end loop;
  end if;
end $$;
