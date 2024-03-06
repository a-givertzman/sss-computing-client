import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/strength/widgets/bar_chart.dart';
import 'package:sss_computing_client/presentation/strength/widgets/chart_axis.dart';

class LiveBarChart extends StatelessWidget {
  final Stream<Map<String, dynamic>> _dataStream;
  final double? _minX;
  final double? _maxX;
  final double? _minY;
  final double? _maxY;
  const LiveBarChart({
    super.key,
    required Stream<Map<String, dynamic>> dataStream,
    double? minX,
    double? maxX,
    double? minY,
    double? maxY,
  })  : _dataStream = dataStream,
        _maxY = maxY,
        _minY = minY,
        _maxX = maxX,
        _minX = minX;

  // double _getMinX() => _xOffsets.fold(_xOffsets[0]?.$1 ?? 0.0, (prev, offset) {
  //       if (offset != null) {
  //         final (left, right) = offset;
  //         return min(min(left, right), prev);
  //       }
  //       return prev;
  //     });

  // double _getMaxX() => _xOffsets.fold(_xOffsets[0]?.$1 ?? 0.0, (prev, offset) {
  //       if (offset != null) {
  //         final (left, right) = offset;
  //         return max(max(left, right), prev);
  //       }
  //       return prev;
  //     });

  // double _getMinY() => _yValues.fold(_yValues[0] ?? 0.0, (prev, value) {
  //       if (value != null) return min(prev, value);
  //       return prev;
  //     });

  // double _getMaxY() => _yValues.fold(_yValues[0] ?? 0.0, (prev, value) {
  //       if (value != null) return max(prev, value);
  //       return prev;
  //     });

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return StreamBuilder(
      stream: _dataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          Log('$runtimeType | stream data').debug(snapshot.data);
          return Card(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: BarChart(
                color: Colors.lightGreenAccent,
                caption: 'ShearForce',
                barCaptions: snapshot.data?['barCaptions'] ?? [],
                yValues: snapshot.data?['yValues'] ?? [],
                xOffsets: snapshot.data?['xOffsets'] ?? [],
                lowLimits: snapshot.data?['lowLimits'] ?? [],
                highLimits: snapshot.data?['highLimits'] ?? [],
                minX: _minX ?? 0.0,
                maxX: _maxX ?? 0.0,
                minY: _minY ?? 0.0,
                maxY: _maxY ?? 0.0,
                xAxis: ChartAxis(
                  valueInterval: 25,
                  labelsSpaceReserved: 55.0,
                  captionSpaceReserved: 0.0,
                  isLabelsVisible: false,
                ),
                yAxis: ChartAxis(
                  valueInterval: 50,
                  labelsSpaceReserved: 60.0,
                  captionSpaceReserved: 15.0,
                  caption: '[10^3 tonn]',
                ),
              ),
            ),
          );
        }
        return const Card(
          child: Center(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }
}
