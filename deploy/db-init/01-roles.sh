#!/bin/sh
# Crea los roles que GoTrue y PostgREST esperan (solo en el primer arranque).
set -e

psql -v ON_ERROR_STOP=1 -U postgres -d postgres <<SQL
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Roles de aplicación (sin login) que usan las políticas de Supabase
CREATE ROLE anon NOLOGIN;
CREATE ROLE authenticated NOLOGIN;
CREATE ROLE service_role NOLOGIN BYPASSRLS;

-- Usuario de servicio de GoTrue. SUPERUSER porque crea y migra su propio schema.
CREATE USER supabase_auth_admin SUPERUSER PASSWORD '$POSTGRES_PASSWORD';

-- Usuario de PostgREST: no hereda permisos, los asume por JWT
CREATE USER authenticator NOINHERIT PASSWORD '$POSTGRES_PASSWORD';
GRANT anon, authenticated, service_role TO authenticator;

-- auth.uid() — la usan todas las políticas RLS de Glint. GoTrue crea el
-- schema auth en su primera migración, así que lo dejamos listo aquí.
CREATE SCHEMA IF NOT EXISTS auth;
GRANT USAGE ON SCHEMA auth TO anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION auth.uid()
RETURNS uuid
LANGUAGE sql STABLE
AS \$\$
  SELECT nullif(
    coalesce(
      current_setting('request.jwt.claim.sub', true),
      (current_setting('request.jwt.claims', true)::jsonb ->> 'sub')
    ),
    ''
  )::uuid
\$\$;

CREATE OR REPLACE FUNCTION auth.role()
RETURNS text
LANGUAGE sql STABLE
AS \$\$
  SELECT nullif(
    coalesce(
      current_setting('request.jwt.claim.role', true),
      (current_setting('request.jwt.claims', true)::jsonb ->> 'role')
    ),
    ''
  )::text
\$\$;
SQL
