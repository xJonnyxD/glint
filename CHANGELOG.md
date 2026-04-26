# Changelog - Glint

Todos los cambios notables en Glint se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/),
y este proyecto sigue [Versionado Semántico](https://semver.org/lang/es/).

## [0.1.0] - 2026-04-26

### ✨ Agregado
- 🔐 Autenticación con email/contraseña
- 🔐 Autenticación con Google OAuth
- 📋 Sistema completo de hábitos con racha y estadísticas
- 💰 Gestión de finanzas (ingresos, gastos, transacciones)
- 💰 Presupuestos por categoría
- 💰 Metas de ahorro
- 💰 Gestión de deudas
- 💰 Gastos recurrentes
- 📝 Notas con colores y etiquetas
- 📅 Calendario con eventos
- 🔄 Rutinas (mañana, tarde, noche)
- 🎮 Sistema de XP y niveles
- 🎮 Logros desbloqueables
- 💾 Base de datos local con Drift (SQLite)
- 🌓 Soporte para modo oscuro/claro
- 🌍 Localización en español (El Salvador)
- 📱 Interfaz responsiva

### 🔧 Técnico
- Flutter 3.22 + Dart 3.4
- Arquitetura Clean con BLoC/Cubit
- Drift ORM para persistencia local
- Supabase Auth para autenticación
- GetIt para inyección de dependencias
- Go Router para navegación

### 📝 Documentación
- README.md detallado
- CONTRIBUTING.md para contribuyentes
- DEVELOPMENT.md para desarrolladores
- GitHub Issue & PR templates
- Inline code documentation

---

## Plan de Futuro

### 🚧 Próximas Versiones

#### v0.2.0 - Sincronización Cloud (En progreso)
- [ ] Sincronización de hábitos con Supabase
- [ ] Sincronización de transacciones
- [ ] Sincronización de notas
- [ ] Sincronización de eventos
- [ ] Sincronización de rutinas
- [ ] Resolución de conflictos
- [ ] Indicadores de estado de sync

#### v0.3.0 - Gamificación Completa
- [ ] Completar sistema de logros
- [ ] Leaderboards
- [ ] Desafíos semanales
- [ ] Badges especiales
- [ ] Historial de XP

#### v0.4.0 - Mejoras de UI/UX
- [ ] Animaciones pulidas
- [ ] Transiciones mejoradas
- [ ] Gestos y haptics
- [ ] Temas personalizables
- [ ] Widgets personalizados

#### v0.5.0 - Analytics y Reportes
- [ ] Reportes detallados
- [ ] Gráficos de progreso
- [ ] Exportación de datos (CSV, PDF)
- [ ] Análisis de patrones
- [ ] Predicciones

#### v1.0.0 - Release Público
- [ ] Play Store
- [ ] App Store
- [ ] Sitio web
- [ ] Documentación pública

---

## Convenciones de Commits

Usamos emojis para categorizar commits:

- 🎨 `:art:` - Cambios en estilos/UI
- ⚡ `:zap:` - Mejoras de performance
- 🔧 `:wrench:` - Cambios en configuración
- 📚 `:books:` - Documentación
- ✨ `:sparkles:` - Nueva característica
- 🐛 `:bug:` - Arreglo de bug
- 🔐 `:lock:` - Seguridad
- ♻️ `:recycle:` - Refactoring
- 📱 `:iphone:` - Cambios de mobile
- 🧪 `:test_tube:` - Tests
- 🚀 `:rocket:` - Deployment

### Ejemplo
```
✨ feat: agregar sistema de XP en hábitos
🐛 fix: error al sincronizar datos
📚 docs: actualizar guía de contribución
```

---

## Versionado

- **MAJOR**: Cambios incompatibles (breaking changes)
- **MINOR**: Nuevas características compatibles
- **PATCH**: Arreglos de bugs

Formato: `v{MAJOR}.{MINOR}.{PATCH}`

---

Última actualización: **26 de Abril, 2026**
