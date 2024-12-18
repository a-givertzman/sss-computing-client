import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sss_computing_client/core/models/resource/platform_process.dart';
import 'package:sss_computing_client/presentation/docs_viewer/docs_page.dart';
///
/// Resource interface for handling different types of resources
sealed class Resource {
  /// Launches the resource.
  Future launch();
  ///
  /// Creates a [Resource] from the [url].
  factory Resource.fromUrl(String url, int pageIndex, BuildContext context) {
    return switch (url.startsWith('http')) {
      true => _HttpResource(url),
      _ => url.endsWith('.md')
          ? _MarkdownResource(url, pageIndex, context)
          : _DocumentResource(url)
    };
  }
}
///
/// Resource for handling http resources
class _HttpResource implements Resource {
  /// The url of the resource.
  final String url;
  //
  _HttpResource(this.url);
  //
  @override
  Future launch() async {
    return PlatformProcess().start(url);
  }
}
///
/// Resource for handling markdown resources.
class _MarkdownResource implements Resource {
  /// The markdown file.
  final String url;
  /// Index of pushed page in navigation panel
  final int pageIndex;
  /// The context.
  final BuildContext context;
  //
  _MarkdownResource(this.url, this.pageIndex, this.context);
  //
  @override
  Future launch() async {
    final currentPath = switch (url.startsWith('assets/')) {
      true => url,
      false => 'assets/${url.replaceFirst('/', '')}',
    };
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MarkdownViewerPage(
          pageIndex: pageIndex,
          currentPath: currentPath,
        ),
        settings: const RouteSettings(name: '/MarkdownViewerPage'),
      ),
    );
  }
}
///
/// Resource for handling document resources.
class _DocumentResource implements Resource {
  /// The url of the resource.
  final String url;
  //
  _DocumentResource(this.url);
  //
  @override
  Future launch() async {
    return await copyAssetToTempDirectory(url, Uri.file(url).pathSegments.last)
        .then(PlatformProcess().start);
  }
  ///
  /// Normalizes the `path` by removing leading and trailing slashes.
  String normalizePath(String path) {
    return path.replaceAll(RegExp(r'^/|/$'), '');
  }
  ///
  /// Loads the asset and copy it the a temporary directory.
  Future<String> copyAssetToTempDirectory(String url, String fileName) async {
    final assetPath = switch (url.startsWith('assets/')) {
      true => url,
      false => 'assets/${url.replaceFirst('/', '')}',
    };
    ByteData data = await rootBundle.load(assetPath);
    String homeDir;
    if (Platform.isWindows) {
      homeDir = Platform.environment['USERPROFILE']!;
    } else if (Platform.isMacOS || Platform.isLinux) {
      homeDir = Platform.environment['HOME']!;
    } else {
      throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}',
      );
    }
    /// Create the Documents directory.
    String documentsDir = path.join(homeDir, 'Documents');
    /// Check the directory exists
    Directory(documentsDir).createSync(recursive: true);
    /// Create the full file path in the Documents directory
    String filePath = path.join(documentsDir, fileName);
    File file = File(filePath);
    await file.writeAsBytes(data.buffer.asUint8List());
    return filePath;
  }
}
