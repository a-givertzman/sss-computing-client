import 'package:hmi_core/hmi_core.dart';
///
/// Copy-on-write [TextFile]
class CopyOnWriteTextFile implements TextFile {
  final TextFile _copyTarget;
  final TextFile _copySource;
  ///
  /// Creates copy-on-write [TextFile] that interact with [source]
  /// until [target] has not been written yet. On write updates [target]
  /// content and lefts [source] unchanged.
  ///
  /// Unlike widely known mechanism,
  /// it does not control direct writing to the [source].
  const CopyOnWriteTextFile({
    required TextFile target,
    required TextFile source,
  })  : _copyTarget = target,
        _copySource = source;
  ///
  /// Returns [Ok] with content of [source] if [target] has not been written yet,
  /// and [target] content otherwise.
  ///
  /// Returns [Err] if no one of [target] and [source] has been written yet.
  @override
  Future<ResultF<String>> get content {
    return _copyTarget.content.then(
      (result) => result.mapOr(
        _copySource.content,
        (targetContent) => Ok(targetContent),
      ),
    );
  }
  ///
  /// Rewrite the entire [target] with [content].
  @override
  Future<void> write(String content) {
    return _copyTarget.write(content);
  }
}
