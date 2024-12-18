import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
///
/// The interface for reading multiple text files as a stream.
sealed class TextFileStream {
  /// Stream of text files
  Stream<ResultF<String>> create(List<String> assetsPaths);
  /// Free up all resources
  Future<dynamic> dispose();
  /// Creates a stream of text files from assets
  factory TextFileStream.assets() = _AssetsStream;
}
/// Stream of text files from assets
class _AssetsStream implements TextFileStream {
  late StreamController<ResultF<String>> _controller;
  ///
  _AssetsStream() {
    _controller = StreamController.broadcast();
  }
  //
  _init(List<String> paths) async {
    String? lastPath;
    for (final path in paths) {
      final res = await TextFile.asset(path).content;
      switch (res) {
        case Ok(value: final data):
          lastPath = '${lastPath ?? ''}\n$data'.trim();
          _controller.add(Ok(lastPath));
          break;
        case Err():
          const Log('Docs').error(res.error);
          break;
      }
    }
    _controller.done;
  }
  //
  @override
  Stream<ResultF<String>> create(List<String> assetsPaths) {
    _init(assetsPaths);
    return _controller.stream;
  }
  //
  @override
  Future dispose() => _controller.close();
}
