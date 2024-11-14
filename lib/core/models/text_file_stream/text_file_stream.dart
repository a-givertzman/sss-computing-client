import 'dart:async';

import 'package:hmi_core/hmi_core.dart';

///
/// The interface for reading multiple text files as a stream.
sealed class TextFileStream {
  /// Stream of text files
  Stream<ResultF<String>> create();

  /// Creates a stream of text files from assets
  factory TextFileStream.assets(List<String> assetsPaths) = _AssetsStream;
}

/// Stream of text files from assets
class _AssetsStream implements TextFileStream {
  final List<String> _paths;
  String? _lastPath;

  late StreamController<ResultF<String>> _controller;

  _AssetsStream(this._paths) {
    _controller = StreamController.broadcast();
  }

  _init() async {
    for (final path in _paths) {
      final res = await TextFile.asset(path).content;
      switch (res) {
        case Ok(value: final data):
          _lastPath = '${_lastPath ?? ''}\n$data'.trim();
          _controller.add(Ok(_lastPath!));
          break;
        case Err():
          Log('Docs').error(res.error);
          break;
      }
    }
    _controller.done;
  }

  @override
  Stream<ResultF<String>> create() {
    if (_lastPath == null) _init();
    return _controller.stream;
  }
}
