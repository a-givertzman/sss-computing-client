import 'package:hmi_core/hmi_core.dart';
///
/// Object to construct title for bay pair;
class BayPairTitle {
  final bool _withFortyFoots;
  final bool _isThirtyFt;
  final int? _oddBayNumber;
  final int? _evenBayNumber;
  ///
  /// Creates object to construct title for bay pair (sibling [oddBayNumber] and [evenBayNumber]).
  /// [withFortyFoots] indicates that bay pair contains 40 ft containers.
  const BayPairTitle({
    required bool withFortyFoots,
    required bool isThirtyFt,
    required int? oddBayNumber,
    required int? evenBayNumber,
  })  : _withFortyFoots = withFortyFoots,
        _isThirtyFt = isThirtyFt,
        _oddBayNumber = oddBayNumber,
        _evenBayNumber = evenBayNumber;
  ///
  /// Returns title for bay pair.
  String title() {
    final bayPairTitle = _withFortyFoots
        ? ' ${_oddBayNumber != null ? '(${'$_oddBayNumber'.padLeft(2, '0')})' : ''}${_evenBayNumber != null ? '$_evenBayNumber'.padLeft(2, '0') : ''} '
        : ' ${_oddBayNumber != null ? '$_oddBayNumber'.padLeft(2, '0') : ''}${_evenBayNumber != null ? '(${'$_evenBayNumber'.padLeft(2, '0')})' : ''} ';
    return '$bayPairTitle${_isThirtyFt ? const Localized('30ft_indicator').v : ''}';
  }
}
