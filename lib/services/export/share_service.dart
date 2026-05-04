import 'dart:io';

import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareFile(File file, {required String subject}) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject,
    );
  }
}
