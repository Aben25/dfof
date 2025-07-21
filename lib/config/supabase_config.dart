import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://xtazgqpcaujwwaswzeoh.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh0YXpncXBjYXVqd3dhc3d6ZW9oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE4MTA5MDUsImV4cCI6MjA0NzM4NjkwNX0.nFutcV81_Na8L-wwxFRpYg7RhqmjMrYspP2LyKbE_q0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}