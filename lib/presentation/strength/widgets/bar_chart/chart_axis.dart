class ChartAxis {
  final double? valueInterval;
  final String? caption;
  final double captionSpaceReserved;
  final bool isLabelsVisible;
  final double labelsSpaceReserved;
  final bool isGridVisible;
  ChartAxis({
    this.valueInterval,
    this.caption,
    this.captionSpaceReserved = 40.0,
    this.isLabelsVisible = true,
    this.labelsSpaceReserved = 20.0,
    this.isGridVisible = true,
  });
}