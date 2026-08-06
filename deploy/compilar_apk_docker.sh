#!/bin/bash
# Compila el APK de Glint en el servidor Linux usando una imagen de Flutter.
#
#   ./deploy/compilar_apk_docker.sh
#
# Por qué en el servidor y no en Windows: el JDK 17 en algunas máquinas Windows
# no puede abrir el pipe interno de NIO (usa sockets AF_UNIX vía el selector
# WEPoll) y Gradle falla con "Unable to establish loopback connection". En Linux
# ese problema no existe. La imagen de cirruslabs ya trae Flutter, el SDK de
# Android y las licencias aceptadas.
#
# Deja el APK en build/site/descargas/glint.apk y, si se le pasa --deploy,
# lo publica en el servidor.
set -euo pipefail
cd "$(dirname "$0")/.."

SERVIDOR="${SERVIDOR:-jonny@192.168.1.9}"
# Imagen propia: la base pública de cirruslabs solo llega a Flutter 3.29, y el
# proyecto necesita Dart >= 3.11 (Flutter 3.44). Se construye una vez en el
# servidor con deploy/Dockerfile.builder.
IMAGEN="${FLUTTER_IMAGE:-glint-flutter:3.44.7}"
URL="${SUPABASE_URL:-https://glint.yanes.xyz}"

echo "→ Empaquetando el código…"
TAR=$(mktemp --suffix=.tgz)
tar czf "$TAR" \
  --exclude=build --exclude=.dart_tool --exclude='android/.gradle' \
  --exclude='.git' \
  lib android web pubspec.yaml pubspec.lock analysis_options.yaml \
  flutter_launcher_icons.yaml assets test tool

echo "→ Enviando al servidor…"
scp -q "$TAR" "$SERVIDOR:/tmp/glint-src.tgz"
rm -f "$TAR"

echo "→ Compilando dentro del contenedor (puede tardar unos minutos)…"
ssh "$SERVIDOR" bash -s "$IMAGEN" "$URL" <<'REMOTO'
set -e
IMAGEN="$1"; URL="$2"
ANON=$(grep ^ANON_KEY= ~/glint/.env | cut -d= -f2-)
mkdir -p ~/glint-build
# La limpieza se hace DESDE UN CONTENEDOR, no con `rm` a secas: la compilación
# corre como root (-u root) y deja los archivos de Gradle con propietario root,
# que el usuario normal no puede borrar. Cuando eso pasaba, el `rm -rf` fallaba
# con "Permission denied", `set -e` cortaba el script y la compilación no
# llegaba a empezar — sin un error visible en la salida.
docker run --rm -v ~/glint-build:/limpiar alpine \
  sh -c 'rm -rf /limpiar/* /limpiar/.[!.]* 2>/dev/null || true'
tar xzf /tmp/glint-src.tgz -C ~/glint-build
# Techo de recursos: sin él, Gradle + el compilador de Dart pueden llevarse
# toda la memoria de la máquina y tumbar las demás apps que corren en el mismo
# servidor (llegó a provocar un reinicio). 8 GB de los 15 son de sobra para
# compilar, y dejan respirar al resto.
docker run --rm -u root \
  --memory=8g --memory-swap=10g --cpus=3 \
  -v ~/glint-build:/app -w /app "$IMAGEN" bash -c "
  git config --global --add safe.directory /app 2>/dev/null || true
  flutter pub get
  flutter build apk --release \
    --dart-define=SUPABASE_URL=$URL \
    --dart-define=SUPABASE_ANON_KEY=$ANON \
    --dart-define=GLINT_REALTIME=true
"
# Devolver la propiedad al usuario para que el scp de vuelta pueda leer el APK
# y para dejar el directorio manejable desde fuera de Docker.
docker run --rm -v ~/glint-build:/app alpine \
  sh -c "chown -R $(id -u):$(id -g) /app" || true
REMOTO

echo "→ Trayendo el APK…"
mkdir -p build/app/outputs/flutter-apk
scp -q "$SERVIDOR:~/glint-build/build/app/outputs/flutter-apk/app-release.apk" \
  build/app/outputs/flutter-apk/app-release.apk

TAM=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
echo
echo "APK listo ($TAM): build/app/outputs/flutter-apk/app-release.apk"

if [ "${1:-}" = "--deploy" ]; then
  echo "→ Publicándolo en la web de descargas…"
  GLINT_ANON_KEY=$(ssh "$SERVIDOR" 'grep ^ANON_KEY= ~/glint/.env | cut -d= -f2-') \
    dart run deploy/armar_sitio.dart
  rsync -avz --delete build/site/ "$SERVIDOR:~/glint/web/"
  echo "Publicado en https://glint.yanes.xyz/descargas/glint.apk"
fi
