import 'package:distro_link/app/app.dart';
import 'package:distro_link/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await bootstrap();
  runApp(const ProviderScope(child: DistroLinkApp()));
}
