///
/// Store and provide axis related data
class ChartAxis {
  final double valueInterval;
  final String? valueUnit;
  final String? caption;
  final bool _isCaptionVisible;
  final double captionSpaceReserved;
  final bool isLabelsVisible;
  final double labelsSpaceReserved;
  final bool isGridVisible;
  ///
  /// Creates structure with axis related data
  const ChartAxis({
    this.valueInterval = 100.0,
    this.valueUnit,
    this.caption,
    bool isCaptionVisible = false,
    this.captionSpaceReserved = 40.0,
    this.isLabelsVisible = false,
    this.labelsSpaceReserved = 20.0,
    this.isGridVisible = false,
  }) : _isCaptionVisible = isCaptionVisible;
  ///
  /// Returns `true` if [caption] is not null and [_isCaptionVisible] is true
  bool get isCaptionVisible => caption != null && _isCaptionVisible;
}
