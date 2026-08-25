#!/usr/bin/env bash
#
# Le asigna a `supabase_storage_admin` la misma contraseña que ya usa el resto
# del stack, que es la que el compose le pasa a storage-api en DATABASE_URL.
#
#   ssh jonny@192.168.1.9 'bash -s' < deploy/clave_storage.sh
#
# La contraseña se lee con `\getenv` de psql, ya dentro del contenedor de
# Postgres: no aparece en este archivo, ni en el historial de la terminal, ni
# en los argumentos de ningún proceso (que es lo que el reporte de seguridad
# reprocha a `crear_admin.sh` en SEC-27). `:'pw'` la escapa como literal SQL.
#
# Requisito previo: haber aplicado deploy/db-init/23-storage.sql, que crea el
# rol. Es idempotente: se puede repetir.
set -euo pipefail

docker exec -i glint-db psql -U postgres -d postgres -v ON_ERROR_STOP=1 -f - <<'SQL'
\getenv pw POSTGRES_PASSWORD
alter role supabase_storage_admin password :'pw';
SQL

echo "Contraseña de supabase_storage_admin asignada."
