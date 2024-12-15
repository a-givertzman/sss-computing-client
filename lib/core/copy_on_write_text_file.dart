import 'package:hmi_core/hmi_core.dart';
///
/// Copy-on-write [TextFile]
class CopyOnWriteTextFile implements TextFile {
  final TextFile _copyTarget;
  final TextFile _copySource;
  ///
  /// Creates copy-on-write [TextFile] that interact with [source]
  /// until first write.
  ///
  /// On first write [source] is copied to [target]
  /// and all interactions will be redirected to [target].
  const CopyOnWriteTextFile({
    required TextFile target,
    required TextFile source,
  })  : _copyTarget = target,
        _copySource = source;
  //
  @override
  Future<ResultF<String>> get content async {
    return _copyTarget.content.then((result) => result.mapOr(
          _copySource.content,
          (targetContent) => Ok(targetContent),
        ));
  }
  //
  @override
  Future<void> write(String content) => _copyTarget.write(content);
}
