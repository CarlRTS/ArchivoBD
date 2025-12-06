# Solución de Problemas - Registro de Usuarios en Supabase

## Problema: Los usuarios no se crean en Supabase

### 1. Verificar la Clave API (Anon Key)

La clave que estás usando parece ser una "publishable key", pero Supabase requiere la **"anon public" key**.

**Pasos para obtener la clave correcta:**

1. Ve a tu dashboard de Supabase: https://hqbmodvsywyhqcedakif.supabase.co
2. Navega a: **Settings** → **API**
3. Busca la sección **"Project API keys"**
4. Copia la clave que dice **"anon public"** (NO uses "service_role")
5. La clave debería verse algo así: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (muy larga, tipo JWT)

6. Actualiza el archivo `lib/config/supabase_config.dart`:
```dart
static const String supabaseAnonKey = 'TU_CLAVE_ANON_PUBLIC_AQUI';
```

### 2. Verificar Configuración de Autenticación en Supabase

1. Ve a **Authentication** → **Settings** en tu dashboard
2. Verifica que:
   - **"Enable email signup"** esté activado
   - **"Confirm email"** puede estar activado (requiere verificación de email)
   - **"Secure email change"** está configurado correctamente

### 3. Verificar Políticas de Seguridad (RLS)

Si tienes Row Level Security (RLS) habilitado, asegúrate de tener políticas que permitan la inserción de usuarios.

1. Ve a **Authentication** → **Policies**
2. Verifica que existan políticas para la tabla `auth.users`

### 4. Verificar en la Consola

Cuando intentes registrar un usuario, revisa la consola de Flutter para ver los mensajes de debug que ahora se muestran:

```
Intentando registrar usuario: email@ejemplo.com
Metadata del usuario: {nombre: Juan, apellido: Pérez}
Respuesta de Supabase:
  - Usuario creado: true/false
  - ID del usuario: ...
  - Email: ...
  - Sesión: true/false
  - Email confirmado: true/false
```

### 5. Verificar en el Dashboard de Supabase

1. Ve a **Authentication** → **Users** en tu dashboard
2. Verifica si el usuario aparece ahí (aunque no esté confirmado)

### 6. Problemas Comunes

**Error: "Invalid API key"**
- Solución: Usa la "anon public" key, no la "publishable" key

**Error: "User already registered"**
- El email ya existe en Supabase

**Usuario creado pero no puede iniciar sesión**
- Verifica si "Confirm email" está activado en Authentication Settings
- El usuario necesita verificar su email antes de poder iniciar sesión

**No aparece ningún error pero el usuario no se crea**
- Revisa la consola de Flutter para ver los mensajes de debug
- Verifica las políticas de seguridad en Supabase
- Verifica que la URL y la clave API sean correctas

### 7. Probar la Conexión

El código ahora incluye mejor manejo de errores. Si ves un error específico, el mensaje te indicará qué verificar.

### 8. Contacto

Si el problema persiste después de verificar todo lo anterior:
1. Revisa los logs en la consola de Flutter
2. Revisa los logs en el dashboard de Supabase (Logs → API)
3. Verifica que tu proyecto de Supabase esté activo y no haya alcanzado límites

