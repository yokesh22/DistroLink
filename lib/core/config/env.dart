import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed accessor over the loaded `.env` file.
///
/// `dotenv.load(...)` must be called once in `bootstrap()` before any
/// getter here is read. Missing values throw at access time so we fail
/// loudly at startup rather than producing misleading network errors later.
abstract final class Env {
  static String get supabaseUrl => _require('SUPABASE_URL');

  static String get supabaseAnonKey => _require('SUPABASE_ANON_KEY');

  static String _require(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw StateError('Missing required env var: $key. See .env.example.');
    }
    return value;
  }
}
