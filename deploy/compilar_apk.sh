#!/bin/bash
# Compila el APK de release de Glint apuntando al servidor de producción.
#
#   ./deploy/compilar_apk.sh
#
# Requiere haber aceptado antes las licencias del SDK de Android (una vez):
#   ANDROID_HOME=D:/dev/android/sdk \
#   JAVA_HOME=D:/dev/jdk-17.0.19+10 \
#   D:/dev/android/sdk/cmdline-tools/latest/bin/sdkmanager.bat --licenses
set -euo pipefail
cd "$(dirname "$0")/.."

export JAVA_HOME="${JAVA_HOME:-D:/dev/jdk-17.0.19+10}"
export ANDROID_HOME="${ANDROID_HOME:-D:/dev/android/sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$JAVA_HOME/bin:/d/dev/flutter/bin:$PATH"
# Git Bash convierte las rutas que empiezan por / en rutas de Windows
export MSYS_NO_PATHCONV=1

SERVIDOR="${SERVIDOR:-jonny@192.168.1.9}"
URL="${SUPABASE_URL:-https://glint.yanes.xyz}"

echo "→ Leyendo la clave anon del servidor…"
ANON="${SUPABASE_ANON_KEY:-$(ssh -o BatchMode=yes "$SERVIDOR" \
  'grep ^ANON_KEY= ~/glint/.env | cut -d= -f2-')}"
[ -n "$ANON" ] || { echo "No se pudo leer la ANON_KEY" >&2; exit 1; }

echo "→ Instalando los paquetes del SDK que faltasen…"
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager.bat" \
  "platform-tools" "platforms;android-35" "build-tools;35.0.0" >/dev/null

echo "→ Configurando Flutter…"
flutter config --android-sdk "$ANDROID_HOME" >/dev/null

echo "→ Compilando el APK de release…"
flutter build apk --release \
  --dart-define=SUPABASE_URL="$URL" \
  --dart-define=SUPABASE_ANON_KEY="$ANON"

APK=build/app/outputs/flutter-apk/app-release.apk
[ -f "$APK" ] || { echo "El APK no se generó" >&2; exit 1; }
echo
echo "APK listo: $APK  ($(du -h "$APK" | cut -f1))"
echo
echo "Para publicarlo en la web de descargas:"
echo "  GLINT_ANON_KEY=\$ANON dart run deploy/armar_sitio.dart"
echo "  rsync -avz --delete build/site/ $SERVIDOR:~/glint/web/"
