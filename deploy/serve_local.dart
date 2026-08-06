/// Sirve el sitio replicando las cabeceras del Nginx de producción.
///
/// Permite probar en local exactamente lo que verá el servidor Ubuntu,
/// incluyendo COOP/COEP (necesarias para que Drift use OPFS y para el
/// renderer de WebAssembly).
///
///     dart run deploy/serve_local.dart [puerto] [carpeta]
///
/// Por defecto sirve `build/site` (la landing con la app en /app/). Para
/// probar solo la app: `dart run deploy/serve_local.dart 8092 build/web`.
library;

import 'dart:io';

const _tipos = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript',
  '.mjs': 'text/javascript',
  '.json': 'application/json',
  '.wasm': 'application/wasm',
  '.css': 'text/css',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.otf': 'font/otf',
  '.ttf': 'font/ttf',
  '.bin': 'application/octet-stream',
};

Future<void> main(List<String> args) async {
  final puerto = args.isEmpty ? 8092 : int.parse(args.first);
  final raiz = Directory(args.length > 1 ? args[1] : 'build/site');

  if (!raiz.existsSync()) {
    stderr.writeln('No existe ${raiz.path} — ejecuta antes deploy/armar_sitio.dart');
    exit(1);
  }

  final servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, puerto);
  stdout.writeln('Glint (build de producción) en http://localhost:$puerto');

  await for (final req in servidor) {
    final res = req.response;
    // Mismas cabeceras que deploy/nginx-glint.conf
    res.headers
      ..set('Cross-Origin-Opener-Policy', 'same-origin')
      ..set('Cross-Origin-Embedder-Policy', 'require-corp')
      ..set('Cache-Control', 'no-store');

    var ruta = Uri.decodeComponent(req.uri.path);
    if (ruta.endsWith('/')) ruta += 'index.html';

    var archivo = File('${raiz.path}$ruta');
    // Rutas del lado del cliente (GoRouter) → index.html
    if (!archivo.existsSync()) archivo = File('${raiz.path}/index.html');

    final ext = archivo.path.substring(archivo.path.lastIndexOf('.'));
    res.headers.contentType = ContentType.parse(_tipos[ext] ?? 'application/octet-stream');

    try {
      await res.addStream(archivo.openRead());
    } catch (_) {
      res.statusCode = HttpStatus.notFound;
    }
    await res.close();
  }
}
