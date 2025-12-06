import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Verificar conexión con Supabase
  Future<bool> checkConnection() async {
    try {
      // Intentar hacer una consulta simple para verificar la conexión
      await _supabase.from('_').select('count').limit(1).maybeSingle();
      return true;
    } catch (e) {
      debugPrint('Error de conexión con Supabase: $e');
      return false;
    }
  }

  // Iniciar sesión con email y contraseña
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Registrar nuevo usuario
  Future<AuthResponse> signUpWithEmail(
    String email,
    String password, {
    String? nombre,
    String? apellido,
  }) async {
    try {
      debugPrint('Intentando registrar usuario: $email');
      
      // Preparar metadata del usuario
      Map<String, dynamic> userMetadata = {};
      if (nombre != null && nombre.isNotEmpty) {
        userMetadata['nombre'] = nombre;
      }
      if (apellido != null && apellido.isNotEmpty) {
        userMetadata['apellido'] = apellido;
      }
      if (nombre != null && nombre.isNotEmpty && apellido != null && apellido.isNotEmpty) {
        userMetadata['full_name'] = '$nombre $apellido';
      }

      debugPrint('Metadata del usuario: $userMetadata');

      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: userMetadata.isNotEmpty ? userMetadata : null,
      );

      debugPrint('Respuesta de Supabase:');
      debugPrint('  - Usuario creado: ${response.user != null}');
      debugPrint('  - ID del usuario: ${response.user?.id}');
      debugPrint('  - Email: ${response.user?.email}');
      debugPrint('  - Sesión: ${response.session != null}');
      debugPrint('  - Email confirmado: ${response.user?.emailConfirmedAt != null}');

      // Verificar si el registro fue exitoso
      if (response.user == null) {
        throw Exception('No se pudo crear el usuario. Verifica tu configuración de Supabase.');
      }

      return response;
    } catch (e) {
      debugPrint('Error al registrar usuario: $e');
      
      // Proporcionar mensajes de error más descriptivos
      String errorString = e.toString().toLowerCase();
      
      if (errorString.contains('already registered') || 
          errorString.contains('user already registered')) {
        throw Exception('Este correo electrónico ya está registrado.');
      } else if (errorString.contains('invalid api key') || 
                 errorString.contains('invalid key') ||
                 errorString.contains('jwt')) {
        throw Exception('Error de configuración: La clave API de Supabase no es válida.\n\nPor favor:\n1. Ve a tu dashboard de Supabase\n2. Settings > API\n3. Copia la "anon public" key\n4. Actualízala en lib/config/supabase_config.dart');
      } else if (errorString.contains('network') || 
                 errorString.contains('connection') ||
                 errorString.contains('timeout')) {
        throw Exception('Error de conexión. Verifica tu conexión a internet.');
      } else if (errorString.contains('password')) {
        throw Exception('La contraseña no cumple con los requisitos de seguridad.');
      } else if (errorString.contains('email')) {
        throw Exception('El formato del correo electrónico no es válido.');
      }
      
      // Si es un error de Supabase, extraer el mensaje
      if (e is AuthException) {
        throw Exception(e.message);
      }
      
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Obtener usuario actual
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Verificar si hay una sesión activa
  bool isLoggedIn() {
    return _supabase.auth.currentUser != null;
  }

  // Stream de cambios de autenticación
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}

