import 'package:flutter/material.dart';

class DistroLinkApp extends StatelessWidget {
  const DistroLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DistroLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('DistroLink — setup complete')),
      ),
    );
  }
}
