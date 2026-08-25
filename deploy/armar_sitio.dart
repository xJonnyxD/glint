/// Arma en `build/site/` la misma estructura que sirve el servidor:
///
///     /            → landing/index.html        (web pública)
///     /admin/      → landing/admin/index.html  (panel de administración)
///     /app/        → build/web/                (app Flutter)
///     /descargas/  → APK de Android, si existe
///
/// Sirve tanto para previsualizar en local como para subir al servidor:
///
///     GLINT_ANON_KEY=eyJ… dart run deploy/armar_sitio.dart
///     dart run deploy/serve_local.dart 8092
///     rsync -avz --delete build/site/ jonny@192.168.1.9:~/glint/web/
///
/// La clave anon se inyecta en el panel desde `GLINT_ANON_KEY`. Es pública por
/// diseño (viaja dentro de la app); lo que protege los datos es RLS.
library;

import 'dart:io';

void copiarDir(Directory origen, Directory destino) {
  destino.createSync(recursive: true);
  for (final e in origen.listSync(recursive: true)) {
    final rel = e.path.substring(origen.path.length + 1);
    final ruta = '${destino.path}/$rel';
    if (e is Directory) {
      Directory(ruta).createSync(recursive: true);
    } else if (e is File) {
      Directory(File(ruta).parent.path).createSync(recursive: true);
      e.copySync(ruta);
    }
  }
}

void main() {
  final web = Directory('build/web');
  final landing = File('landing/index.html');

  if (!web.existsSync()) {
    stderr.writeln(
      'Falta build/web — compila antes con:\n'
      '  flutter build web --wasm --release --base-href=/app/ '
      '--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
    );
    exit(1);
  }
  if (!landing.existsSync()) {
    stderr.writeln('Falta landing/index.html');
    exit(1);
  }

  // Aviso si la app no se compiló para servirse bajo /app/
  final indexApp = File('${web.path}/index.html').readAsStringSync();
  if (!indexApp.contains('<base href="/app/"')) {
    stderr.writeln(
      'AVISO: build/web no tiene <base href="/app/">. La app fallará al '
      'cargar sus assets bajo /app/. Recompila con --base-href=/app/',
    );
  }

  final site = Directory('build/site');
  if (site.existsSync()) site.deleteSync(recursive: true);
  site.createSync(recursive: true);

  copiarDir(web, Directory('${site.path}/app'));
  _versionarBootstrap(Directory('${site.path}/app'));

  // El favicon y los iconos los comparte la landing con la app
  final favicon = File('${web.path}/favicon.png');
  if (favicon.existsSync()) favicon.copySync('${site.path}/favicon.png');
  final iconos = Directory('${web.path}/icons');
  if (iconos.existsSync()) copiarDir(iconos, Directory('${site.path}/icons'));

  // El APK, si ya se compiló. Se prefiere el de arm64-v8a (build
  // --split-per-abi), que cubre los teléfonos modernos y pesa ~1/3 del
  // universal; si solo existe el universal, se usa ese.
  final descargas = Directory('${site.path}/descargas')..createSync();
  const dir = 'build/app/outputs/flutter-apk';
  final apk = [
    File('$dir/app-arm64-v8a-release.apk'),
    File('$dir/app-release.apk'),
  ].firstWhere((f) => f.existsSync(),
      orElse: () => File('$dir/app-release.apk'));
  var html = landing.readAsStringSync();

  if (apk.existsSync()) {
    // Se guarda una copia en deploy/apk_versions/ (fuera de build/, que se
    // borra con `flutter clean`) para poder ofrecer siempre la versión
    // publicada anterior además de la nueva, y así poder alternar entre las
    // dos sin tener que recompilar la vieja.
    _archivarVersion(apk);
    final versiones = _ultimasDosVersiones();

    apk.copySync('${descargas.path}/glint.apk');
    final actual = versiones[0];
    final mb = (actual.lengthSync() / 1024 / 1024).toStringAsFixed(1);
    final fecha = _formatoFechaHora(actual.lastModifiedSync());
    // Cloudflare cachea el APK 4 horas (`max-age=14400`), así que tras publicar
    // uno nuevo el enlace seguía sirviendo el anterior: el usuario se descargaba
    // la versión vieja sin enterarse. El sufijo cambia la URL en cada
    // compilación y obliga al borde a ir a buscarlo. Misma técnica que se usa
    // con flutter_bootstrap.js más abajo.
    final v = actual.lastModifiedSync().millisecondsSinceEpoch;

    var bloque = '<a class="btn btn-primary" href="/descargas/glint.apk?v=$v" download>'
        'Descargar APK</a>\n'
        '          <p style="margin:10px 0 0;font-size:.82rem">$mb MB · Android 8+</p>\n'
        '          <p style="margin:4px 0 0;font-size:.75rem;opacity:.7">Actualizado: $fecha</p>';
    stdout.writeln('APK incluido ($mb MB, actualizado $fecha, ?v=$v) '
        '— ${apk.path.split('/').last}');

    // La versión anterior, si existe, se publica también para poder ir
    // probando entre las dos.
    if (versiones.length > 1) {
      final anterior = versiones[1];
      anterior.copySync('${descargas.path}/glint-anterior.apk');
      final mbA = (anterior.lengthSync() / 1024 / 1024).toStringAsFixed(1);
      final fechaA = _formatoFechaHora(anterior.lastModifiedSync());
      final vA = anterior.lastModifiedSync().millisecondsSinceEpoch;
      bloque += '\n'
          '          <a class="btn btn-ghost btn-sm" style="margin-top:14px" '
          'href="/descargas/glint-anterior.apk?v=$vA" download>'
          'Descargar versión anterior</a>\n'
          '          <p style="margin:8px 0 0;font-size:.75rem;opacity:.7">'
          '$mbA MB · Actualizado: $fechaA</p>';
      stdout.writeln('Versión anterior incluida (actualizado $fechaA) '
          '— ${anterior.path.split('/').last}');
    }

    html = _reemplazarBloque(html, bloque);
  } else {
    // Sin APK el botón llevaría a un 404, así que se muestra el mismo aviso
    // que en iOS.
    html = _reemplazarBloque(html, '<span class="badge">Próximamente</span>');
    stdout.writeln(
      'Sin APK: se publica la tarjeta de Android como "Próximamente".\n'
      'Para generarlo: flutter build apk --release (requiere el SDK de Android).',
    );
  }

  File('${site.path}/index.html').writeAsStringSync(html);

  _copiarPanelAdmin(site);

  // Al final del todo: la landing y el panel de administración se acaban de
  // escribir, así que ahora sí están sus referencias al favicon para versionar.
  _versionarIconos(site, Directory('${site.path}/app'), favicon);

  stdout.writeln('Sitio armado en build/site/');
}

/// Añade `?v=<timestamp>` a la referencia de flutter_bootstrap.js en el
/// index de la app.
///
/// Flutter no versiona sus archivos, así que si una vez se sirvieron con
/// cabeceras `immutable`, Cloudflare los retiene en el borde hasta un año y
/// no hay forma de purgarlos sin acceso a su API. Cambiar la URL con una
/// versión hace que el navegador pida una dirección nueva que el borde no
/// tiene cacheada: la trae fresca del origen (que ya manda `no-cache`) y en
/// cada despliegue vuelve a cambiar.
void _versionarBootstrap(Directory appDir) {
  final index = File('${appDir.path}/index.html');
  if (!index.existsSync()) return;
  final v = DateTime.now().millisecondsSinceEpoch;
  var html = index.readAsStringSync();
  html = html.replaceAll(
    RegExp(r'flutter_bootstrap\.js(\?v=\d+)?'),
    'flutter_bootstrap.js?v=$v',
  );
  index.writeAsStringSync(html);
  stdout.writeln('Bootstrap versionado (?v=$v) para sortear la caché del borde');
}

/// Añade `?v=<huella>` a las referencias del favicon y de los iconos.
///
/// Cloudflare los cachea 4 horas y no se entera de que el archivo cambió: tras
/// cambiar el icono de la app, el navegador seguía mostrando el anterior
/// durante horas (se comprobó: servía el viejo con `Age: 33605`). La huella se
/// saca del tamaño y la fecha del propio favicon, así que solo cambia cuando
/// el icono cambia de verdad, y las recargas normales siguen aprovechando la
/// caché.
void _versionarIconos(Directory site, Directory appDir, File favicon) {
  if (!favicon.existsSync()) return;
  final v = favicon.lengthSync() ^
      favicon.lastModifiedSync().millisecondsSinceEpoch;

  // replaceAllMapped y no replaceAll: en Dart, el reemplazo de `replaceAll`
  // es texto literal y no entiende los grupos $1, así que la sustitución se
  // quedaba sin hacer y los iconos seguían sin versionar.
  // Cubre href= y src=: la landing y la pantalla de carga pintan el logotipo
  // con <img src="...Icon-512.png">, y esas referencias también se quedaban
  // atrás en la caché del borde.
  String versionar(String html) => html.replaceAllMapped(
        RegExp(
          r'((?:href|src)=")(/?)((?:icons/)?(?:favicon|Icon-[\w-]+)\.png)'
          r'(\?v=[^"]*)?(")',
        ),
        (m) => '${m[1]}${m[2]}${m[3]}?v=$v${m[5]}',
      );

  for (final ruta in [
    '${site.path}/index.html',
    '${site.path}/admin/index.html',
    '${appDir.path}/index.html',
  ]) {
    final f = File(ruta);
    if (f.existsSync()) f.writeAsStringSync(versionar(f.readAsStringSync()));
  }

  // El manifest referencia los iconos del instalador; versionarlos ahí evita
  // que la app instalada se quede con el icono viejo.
  final manifest = File('${appDir.path}/manifest.json');
  if (manifest.existsSync()) {
    manifest.writeAsStringSync(
      manifest.readAsStringSync().replaceAllMapped(
            RegExp(r'"(icons/Icon-[^"?]+\.png)(\?v=\d+)?"'),
            (m) => '"${m[1]}?v=$v"',
          ),
    );
  }

  stdout.writeln('Iconos versionados (?v=$v)');
}

/// Copia el panel de administración inyectándole la clave anon.
void _copiarPanelAdmin(Directory site) {
  final origen = File('landing/admin/index.html');
  if (!origen.existsSync()) {
    stdout.writeln('Sin panel de administración (falta landing/admin/index.html)');
    return;
  }

  final anon = Platform.environment['GLINT_ANON_KEY'] ?? '';
  var html = origen.readAsStringSync();

  if (anon.isEmpty) {
    stderr.writeln(
      'AVISO: GLINT_ANON_KEY no está definida, el panel de administración no '
      'podrá conectarse. Exporta la clave y vuelve a armar:\n'
      "  GLINT_ANON_KEY=\$(ssh jonny@192.168.1.9 'grep ^ANON_KEY= ~/glint/.env | cut -d= -f2-')",
    );
  } else {
    html = html.replaceAll('__ANON_KEY__', anon);
  }

  final destino = Directory('${site.path}/admin')..createSync(recursive: true);
  File('${destino.path}/index.html').writeAsStringSync(html);
  stdout.writeln('Panel de administración en /admin/');
}

/// Carpeta donde se conservan los últimos APK compilados, fuera de `build/`
/// (que `flutter clean` borra sin avisar). Guardar aquí la versión que se
/// publicaba antes de recompilar es lo único que permite ofrecer "la versión
/// anterior" en la web sin tener que volver a compilarla.
Directory _dirVersiones() =>
    Directory('deploy/apk_versions')..createSync(recursive: true);

/// Copia el APK recién compilado a `deploy/apk_versions/` con un nombre
/// basado en su fecha de modificación (que es la fecha real de compilación),
/// y elimina las copias más antiguas que la segunda más reciente: solo hacen
/// falta la actual y la anterior para poder alternar entre las dos.
void _archivarVersion(File apk) {
  final fecha = apk.lastModifiedSync();
  String dos(int n) => n.toString().padLeft(2, '0');
  final nombre =
      'glint-${fecha.year}-${dos(fecha.month)}-${dos(fecha.day)}'
      '_${dos(fecha.hour)}-${dos(fecha.minute)}.apk';
  final destino = File('${_dirVersiones().path}/$nombre');
  // Si ya existe una copia con la misma fecha (p. ej. se vuelve a armar el
  // sitio sin recompilar) no hay nada que archivar de nuevo.
  if (!destino.existsSync()) {
    apk.copySync(destino.path);
    final raw = destino.openSync(mode: FileMode.append);
    raw.closeSync();
    destino.setLastModifiedSync(fecha);
  }

  final restantes = _ultimasDosVersiones();
  for (final f in _dirVersiones()
      .listSync()
      .whereType<File>()
      .where((f) => !restantes.contains(f))) {
    f.deleteSync();
  }
}

/// Los dos APK más recientes de `deploy/apk_versions/`, más nuevo primero.
List<File> _ultimasDosVersiones() {
  final archivos = _dirVersiones().listSync().whereType<File>().toList()
    ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
  return archivos.take(2).toList();
}

/// Formatea una fecha como `dd/MM/yyyy HH:mm` (para la fecha de actualización
/// del APK en la web de descargas).
String _formatoFechaHora(DateTime d) {
  String dos(int n) => n.toString().padLeft(2, '0');
  return '${dos(d.day)}/${dos(d.month)}/${d.year} ${dos(d.hour)}:${dos(d.minute)}';
}

/// Sustituye lo que haya entre los marcadores APK_ANDROID de la landing.
String _reemplazarBloque(String html, String contenido) {
  final re = RegExp(
    r'<!-- APK_ANDROID.*?-->.*?<!-- /APK_ANDROID -->',
    dotAll: true,
  );
  if (!re.hasMatch(html)) {
    stderr.writeln('AVISO: no se encontraron los marcadores APK_ANDROID');
    return html;
  }
  return html.replaceFirst(re, contenido);
}
