import 'package:distro_link/app/theme.dart';
import 'package:distro_link/core/theme/app_spacing.dart';
import 'package:distro_link/core/widgets/app_button.dart';
import 'package:distro_link/core/widgets/app_card.dart';
import 'package:flutter/material.dart';

class DistroLinkApp extends StatelessWidget {
  const DistroLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DistroLink',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const _SetupHome(),
    );
  }
}

class _SetupHome extends StatelessWidget {
  const _SetupHome();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('DistroLink')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Setup complete', style: textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Design system wired. Ready to build features.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(label: 'Get started', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
