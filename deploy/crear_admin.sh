#!/bin/bash
# Crea (o promueve) una cuenta de administrador de Glint.
#
#   ./crear_admin.sh correo@ejemplo.com [contraseña]
#
# Si no pasas contraseña se genera una aleatoria y se guarda en
# ~/glint/.admin-credenciales con permisos 600 — nunca se imprime en pantalla,
# para que no acabe en el historial de la terminal ni en un log.
#
# Si la cuenta ya existe, no la toca: solo la marca como admin.
set -euo pipefail
cd "$(dirname "$0")"

EMAIL="${1:-}"
if [ -z "$EMAIL" ]; then
  echo "Uso: ./crear_admin.sh correo@ejemplo.com [contraseña]" >&2
  exit 1
fi

[ -f .env ] || { echo "Falta .env en $(pwd)" >&2; exit 1; }
SERVICE_KEY=$(grep ^SERVICE_ROLE_KEY= .env | cut -d= -f2-)
[ -n "$SERVICE_KEY" ] || { echo "Falta SERVICE_ROLE_KEY en .env" >&2; exit 1; }

PASSWORD="${2:-}"
GENERADA=0
if [ -z "$PASSWORD" ]; then
  # 24 caracteres base64 sin símbolos problemáticos para la shell
  PASSWORD=$(openssl rand -base64 24 | tr -d '/+=' | cut -c1-24)
  GENERADA=1
fi

api() {
  docker run --rm --network traefik-public curlimages/curl:latest -s "$@"
}

echo "→ Creando la cuenta $EMAIL…"
RESP=$(api -X POST http://glint-api/auth/v1/admin/users \
  -H "apikey: $SERVICE_KEY" \
  -H "Authorization: Bearer $SERVICE_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\",\"email_confirm\":true}")

UID_NUEVO=$(printf '%s' "$RESP" | grep -o '"id":"[^"]*' | head -1 | cut -d'"' -f4 || true)

if [ -z "$UID_NUEVO" ]; then
  if printf '%s' "$RESP" | grep -qi "already been registered\|already exists"; then
    # Ya existía: le ponemos la contraseña nueva para que el script sea
    # idempotente y sirva también para restablecerla.
    echo "  La cuenta ya existía; se restablece su contraseña."
    UID_EXISTENTE=$(docker exec glint-db psql -U postgres -d postgres -tAc \
      "select id from auth.users where email = '$EMAIL'")
    if [ -z "$UID_EXISTENTE" ]; then
      echo "La cuenta existe en auth pero no se pudo leer su id." >&2
      exit 1
    fi
    api -X PUT "http://glint-api/auth/v1/admin/users/$UID_EXISTENTE" \
      -H "apikey: $SERVICE_KEY" \
      -H "Authorization: Bearer $SERVICE_KEY" \
      -H "Content-Type: application/json" \
      -d "{\"password\":\"$PASSWORD\"}" > /dev/null
  else
    echo "No se pudo crear la cuenta:" >&2
    printf '%s\n' "$RESP" >&2
    exit 1
  fi
fi

echo "→ Marcando como administrador…"
# `-i` es imprescindible: sin él docker exec no reenvía stdin y el heredoc
# nunca llega a psql, así que el UPDATE se pierde en silencio.
docker exec -i glint-db psql -U postgres -d postgres -q <<SQL
-- El trigger crea el perfil al registrarse, pero lo insertamos por si la
-- cuenta es anterior a que existiera.
insert into public.profiles (id, email, nombre, creado_en)
select u.id, u.email,
       coalesce(u.raw_user_meta_data ->> 'nombre', split_part(u.email,'@',1)),
       u.created_at
  from auth.users u where u.email = '$EMAIL'
on conflict (id) do nothing;

update public.profiles set es_admin = true where email = '$EMAIL';
SQL

ES_ADMIN=$(docker exec glint-db psql -U postgres -d postgres -tAc \
  "select es_admin from public.profiles where email = '$EMAIL'")

if [ "$ES_ADMIN" != "t" ]; then
  echo "No se pudo marcar como admin (¿existe la cuenta?)." >&2
  exit 1
fi

if [ "$GENERADA" = "1" ]; then
  umask 077
  {
    echo "# Credenciales de administrador de Glint"
    echo "# Generadas el $(date '+%Y-%m-%d %H:%M:%S')"
    echo "# CAMBIA LA CONTRASEÑA AL ENTRAR POR PRIMERA VEZ."
    echo "url=https://glint.yanes.xyz/admin/"
    echo "email=$EMAIL"
    echo "password=$PASSWORD"
  } > "$HOME/glint/.admin-credenciales"
  chmod 600 "$HOME/glint/.admin-credenciales"
  echo
  echo "Cuenta lista. La contraseña se generó al azar y está en:"
  echo "  ~/glint/.admin-credenciales   (solo tú puedes leerlo)"
  echo
  echo "Léela con:  cat ~/glint/.admin-credenciales"
  echo "Y cámbiala al entrar por primera vez."
else
  # Contraseña elegida a mano: no la guardamos en ningún sitio, pero dejamos
  # constancia para que el archivo no siga mostrando una contraseña anterior
  # que ya no sirve (y que seguiría pareciendo válida).
  if [ -n "$PASSWORD" ] && [ -f "$HOME/glint/.admin-credenciales" ]; then
    umask 077
    {
      echo "# Credenciales de administrador de Glint"
      echo "# La contraseña se estableció a mano el $(date '+%Y-%m-%d %H:%M:%S')."
      echo "# No se guarda aquí: la eligió el usuario."
      echo "url=https://glint.yanes.xyz/admin/"
      echo "email=$EMAIL"
    } > "$HOME/glint/.admin-credenciales"
    chmod 600 "$HOME/glint/.admin-credenciales"
  fi
  echo
  echo "Cuenta $EMAIL actualizada con la contraseña indicada."
fi
echo "Panel: https://glint.yanes.xyz/admin/"
