import 'package:distro_link/core/network/supabase_provider.dart';
import 'package:distro_link/features/auth/data/distributor_signup_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'distributor_signup_providers.g.dart';

@riverpod
DistributorSignupRepository distributorSignupRepository(Ref ref) =>
    DistributorSignupRepository(ref.watch(supabaseClientProvider));
