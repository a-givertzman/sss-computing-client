import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
///
/// Object that holds curve data and converts it to
/// [LineChartBarData] for display on [LineChart].
class DiagramCurve {
  final List<Offset> _points;
  final Color _color;
  final String _caption;
  final bool _showDots;
  ///
  /// Creates object that holds curve data and converts it to
  /// [LineChartBarData] for display on [LineChart].
  ///
  /// [points] is list of points defining curve on two-dimensional plane,
  /// [LineChart] draws curve passing through given points.
  /// [caption] is [String] that identifies curve, describes its data.
  /// [color] determines color of drawing line
  /// [showDots] determines wheter to draw points through which curve passes.
  DiagramCurve({
    required List<Offset> points,
    required String caption,
    required Color color,
    bool showDots = false,
  })  : _points = points,
        _color = color,
        _caption = caption,
        _showDots = showDots;
  ///
  /// Returns curve color.
  Color get color => _color;
  ///
  /// Returns curve caption.
  String get caption => _caption;
  ///
  /// Returns [LineChartBarData] that is used to
  /// render curve on [LineChart] diagram.
  LineChartBarData lineBarData() => LineChartBarData(
        spots: _points
            .map((point) => FlSpot(
                  point.dx,
                  point.dy,
                ))
            .toList(),
        dotData: FlDotData(show: _showDots),
        color: _color,
      );
}
