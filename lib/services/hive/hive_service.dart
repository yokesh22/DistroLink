import 'package:hive_ce/hive.dart';

/// Holds all open Hive boxes. Obtained via the hive service provider.
class HiveService {
  const HiveService({
    required this.areasBox,
    required this.shopsBox,
    required this.productsBox,
    required this.outboxBox,
  });

  final Box<dynamic> areasBox;
  final Box<dynamic> shopsBox;
  final Box<dynamic> productsBox;
  final Box<dynamic> outboxBox;
}
