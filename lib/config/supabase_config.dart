class SupabaseConfig {
  // Configuración de Supabase
  // Nota: Para producción, considera usar variables de entorno o un archivo .env
  
  // URL del proyecto Supabase (inferida del host proporcionado)
  static const String supabaseUrl = 'https://hqbmodvsywyhqcedakif.supabase.co';
  
  // Anon Key - Necesitas obtenerla de tu dashboard de Supabase
  // Ve a: https://hqbmodvsywyhqcedakif.supabase.co/project/_/settings/api
  // Y copia la "anon public" key
  // IMPORTANTE: Usa la "anon public" key, NO la "service_role" key
  static const String supabaseAnonKey = 'sb_publishable_rb-1LATupbSWwqGbpOSdZQ_1EiV238k';
  
  // Credenciales de PostgreSQL (para referencia)
  static const String dbHost = 'db.hqbmodvsywyhqcedakif.supabase.co';
  static const int dbPort = 5432;
  static const String dbName = 'postgres';
  static const String dbUser = 'postgres';
}

