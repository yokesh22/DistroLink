import 'package:distro_link/core/config/env.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Framework + service init. Called once from `main()` before `runApp`.
///
/// Add new init steps here (Hive, logger, error reporting, etc.) — keep
/// `main.dart` to a 5-line entry that does nothing else.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
}
