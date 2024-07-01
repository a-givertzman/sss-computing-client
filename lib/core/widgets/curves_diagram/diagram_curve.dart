import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
///
/// Object that holds curve data and converts it to
/// [LineChartBarData] for display on [LineChart].
class DiagramCurve {
  final List<Offset> points;
  final Color color;
  final String caption;
  final bool showDots;
  ///
  /// Creates object that holds curve data and converts it to
  /// [LineChartBarData] for display on [LineChart].
  ///
  /// `points` is list of points defining curve on two-dimensional plane,
  /// [LineChart] draws curve passing through given points.
  /// `caption` is [String] that identifies curve, describes its data.
  /// `color` determines color of drawing line
  /// `showDots` determines wheter to draw points through which curve passes.
  DiagramCurve({
    required this.points,
    required this.caption,
    required this.color,
    this.showDots = false,
  });
  ///
  /// Returns [LineChartBarData] that is used to
  /// render curve on [LineChart] diagram.
  LineChartBarData lineBarData() => LineChartBarData(
        spots: points
            .map((point) => FlSpot(
                  point.dx,
                  point.dy,
                ))
            .toList(),
        dotData: FlDotData(show: showDots),
        color: color,
      );
}
