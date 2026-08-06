// `dart.library.js_interop` es la condición correcta para "estamos en web":
// está disponible tanto al compilar con dart2js como con dart2wasm. La
// condición antigua (`dart.library.html`) no existe en dart2wasm, así que
// arrastraba la implementación nativa —y con ella dart:ffi— rompiendo la
// compilación a WebAssembly.
export 'connection_native.dart'
    if (dart.library.js_interop) 'connection_web.dart';
