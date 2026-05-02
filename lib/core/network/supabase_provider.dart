import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

/// Exposes the singleton [SupabaseClient] as a Riverpod provider.
///
/// All repositories take this as a constructor argument so they remain
/// testable (override with a fake client in tests).
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) => Supabase.instance.client;
