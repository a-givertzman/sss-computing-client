class ChartAxis {
  final double? minValue;
  final double? maxValue;
  final double? valueInterval;
  final String? caption;
  final double captionSpaceReserved;
  final bool isLabelsVisible;
  final double labelsSpaceReserved;
  final bool isGridVisible;
  const ChartAxis({
    this.minValue,
    this.maxValue,
    this.valueInterval,
    this.caption,
    this.captionSpaceReserved = 40.0,
    this.isLabelsVisible = true,
    this.labelsSpaceReserved = 20.0,
    this.isGridVisible = true,
  });
}
