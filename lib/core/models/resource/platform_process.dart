import 'package:hmi_core/hmi_core_log.dart';

import 'dart:io';

/// Platform  process
class PlatformProcess {
  final Log _logger = const Log('Document launcher');

  ///
  Future<void> start(String url) async {
    try {
      final args = [url];
      Process process;
      if (Platform.isWindows) {
        process = await Process.start('explorer', args);
      } else if (Platform.isMacOS) {
        process = await Process.start('open', args);
      } else if (Platform.isLinux) {
        process = await Process.start('xdg-open', args);
      } else {
        throw Exception('Unsupported platform: ${Platform.operatingSystem}');
      }
      process.stdout.listen((data) {
        _logger.info(data);
      });
      process.stderr.listen((data) {
        _logger.error(data);
      });
      await process.exitCode;
    } catch (e) {
      _logger.error(e);
    }
  }
}
