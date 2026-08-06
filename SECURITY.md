# 🔒 Seguridad en Glint

## Reporte de Vulnerabilidades

Si descubres una vulnerabilidad de seguridad, **por favor NO abras un issue público**. 

En su lugar, envía un correo a: **jaqyanes@gmail.com**

Incluye:
- Descripción de la vulnerabilidad
- Pasos para reproducir
- Impacto potencial
- Sugerencias de arreglo (si tienes)

Te responderemos dentro de 48 horas.

---

## 🔐 Prácticas de Seguridad

### Almacenamiento de Datos Sensibles

```dart
// ✅ CORRECTO: Usar flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// Guardar token
await storage.write(key: 'auth_token', value: token);

// Leer token
final token = await storage.read(key: 'auth_token');

// Borrar token
await storage.delete(key: 'auth_token');

// ❌ INCORRECTO: No guardar en SharedPreferences
// SharedPreferences almacena en texto plano
```

### Autenticación

```dart
// ✅ Usar Supabase Auth (OAuth)
await _supabase.auth.signInWithOAuth(
  OAuthProvider.google,
  redirectTo: 'sv.glint.app://login-callback/',
);

// ❌ NUNCA: Guardar contraseñas en texto plano
// ❌ NUNCA: Enviar credenciales sin HTTPS
```

### API Requests

```dart
// ✅ Todas las requests a Supabase usan HTTPS
// ✅ Supabase maneja SSL/TLS automáticamente
// ✅ Auth headers se envían automáticamente

// ❌ NUNCA: Hacer requests HTTP sin SSL
// ❌ NUNCA: Incluir tokens en logs
```

### Row Level Security (RLS)

Todas las tablas en Supabase tienen RLS habilitado para proteger datos.

---

## 🛡️ Dependencias Seguras

```bash
# Auditar vulnerabilidades
flutter pub audit
```

---

## 🚨 Reporte de Incidentes

Actualmente **0 vulnerabilidades conocidas**.

Si encuentras un issue de seguridad, por favor reporta confidencialmente.

---

**Gracias por cuidar la seguridad de Glint! 🔒**
