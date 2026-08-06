-- Duración de los eventos de la agenda.
--
-- Hasta ahora `events` solo guardaba `hora` (el 'HH:mm' de inicio). Con eso no
-- se puede dibujar un evento como un bloque en una rejilla horaria: no se sabe
-- dónde termina. Se guardan MINUTOS en vez de una hora de fin para no tener que
-- tratar aparte los eventos que se pasan de la medianoche.
--
-- Idempotente: se puede volver a aplicar sin romper nada.
--
-- Aplicar en el servidor:
--   cat deploy/db-init/22-agenda-duracion.sql | \
--     ssh jonny@192.168.1.9 'docker exec -i glint-db psql -U postgres -d postgres'
--   -- y luego recargar el cache de esquema de PostgREST:
--   ssh jonny@192.168.1.9 'docker exec glint-db psql -U postgres -d postgres \
--     -c "notify pgrst, ''reload schema''"'

alter table public.events
  add column if not exists duracion_minutos integer not null default 60;

-- Una duración de 0 o negativa dejaría un bloque de altura nula o invertida.
-- El tope de un día evita que un dato corrupto pinte un bloque infinito.
do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'events_duracion_minutos_valida'
  ) then
    alter table public.events
      add constraint events_duracion_minutos_valida
      check (duracion_minutos > 0 and duracion_minutos <= 1440);
  end if;
end $$;

comment on column public.events.duracion_minutos is
  'Cuánto dura el evento en minutos. Solo aplica si hora no es nula (los de '
  'todo el día lo ignoran). Por defecto 60.';

-- `events` tiene los permisos concedidos a nivel de TABLA, no por columna
-- (a diferencia de `profiles`), así que la columna nueva los hereda y no hace
-- falta ampliar ningún grant. Comprobado con information_schema.

notify pgrst, 'reload schema';
