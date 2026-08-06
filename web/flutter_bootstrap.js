// Arranque de Flutter personalizado.
//
// `--no-web-resources-cdn` marca useLocalCanvasKit, pero esa bandera no cubre
// a skwasm — el renderer de la build con --wasm — que se seguía descargando de
// gstatic.com en cada visita. Fijar canvasKitBaseUrl tiene prioridad sobre
// todo lo demás en el cargador, así que también obliga a skwasm a servirse
// desde este dominio.
//
// La ruta es relativa al <base href>, así que con --base-href=/app/ resuelve
// a /app/canvaskit/.

{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/",
  },
  // Usamos el callback para quitar la pantalla de carga solo cuando la app ya
  // está pintada, no antes (si no, se ve un parpadeo en blanco).
  onEntrypointLoaded: async (engineInitializer) => {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();
    const splash = document.getElementById("glint-splash");
    if (splash) {
      splash.classList.add("glint-splash--oculto");
      setTimeout(() => splash.remove(), 450);
    }
  },
});
