# Imagen para compilar el APK de Glint en el servidor Linux.
#
# La base pública de cirruslabs trae Android SDK + JDK 17 + licencias aceptadas,
# pero su Flutter más nuevo es 3.29, y el proyecto necesita Dart >= 3.11
# (Flutter 3.44). Así que partimos de esa base y le ponemos Flutter 3.44.7
# encima, reaprovechando todo el andamiaje de Android.
#
# Construir (una sola vez, en el servidor):
#   docker build -f deploy/Dockerfile.builder -t glint-flutter:3.44.7 .
FROM ghcr.io/cirruslabs/flutter:3.29.3

USER root
RUN rm -rf /sdks/flutter && \
    curl -sL -o /tmp/f.tar.xz \
      https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.44.7-stable.tar.xz && \
    tar xf /tmp/f.tar.xz -C /sdks && rm /tmp/f.tar.xz && \
    git config --global --add safe.directory /sdks/flutter && \
    flutter --version
