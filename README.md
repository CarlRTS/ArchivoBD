# ArchivoBD

Aplicación Flutter para el Archivo Histórico Arquidiocesano de Caracas con integración a Supabase.

## Configuración

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Configurar Supabase

1. Abre `lib/config/supabase_config.dart`
2. Obtén tu **Anon Key** desde el dashboard de Supabase:
   - Ve a: https://hqbmodvsywyhqcedakif.supabase.co/project/_/settings/api
   - Copia la "anon public" key
3. Reemplaza `'TU_ANON_KEY_AQUI'` con tu clave real

### 3. Ejecutar la aplicación

```bash
flutter run
```

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la app
├── config/
│   └── supabase_config.dart # Configuración de Supabase
├── services/
│   └── auth_service.dart    # Servicio de autenticación
└── screens/
    └── login_screen.dart    # Pantalla de inicio de sesión
```

## Características

- ✅ Login con email y contraseña
- ✅ Integración con Supabase Auth
- ✅ Validación de formularios
- ✅ Manejo de errores
- ✅ UI moderna y responsive

## Credenciales de Base de Datos

- **Host:** db.hqbmodvsywyhqcedakif.supabase.co
- **Port:** 5432
- **Database:** postgres
- **User:** postgres

## Próximos Pasos

- [ ] Implementar pantalla de registro
- [ ] Agregar pantalla principal después del login
- [ ] Implementar recuperación de contraseña
- [ ] Agregar validación de email
