import 'package:distro_link/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Orange banner shown at the top of screens when the device is offline
/// or when the debug "Simulate Offline" toggle is active.
class AppOfflineBanner extends StatelessWidget {
  const AppOfflineBanner({
    super.key,
    this.pendingCount = 0,
  });

  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    final suffix = pendingCount == 1 ? '' : 's';
    final message = pendingCount > 0
        ? 'No internet · $pendingCount order$suffix pending sync'
        : 'No internet connection';

    return Container(
      color: AppColors.orangeLight,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.signal_wifi_off_rounded,
            size: 16,
            color: Color(0xFF92400E),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
