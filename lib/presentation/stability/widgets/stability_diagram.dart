import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/stability_curve/metacentric_height_line.dart';
import 'package:sss_computing_client/core/models/stability_curve/pg_dynamic_stability_curve.dart';
import 'package:sss_computing_client/core/models/stability_curve/pg_static_stability_curve.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/curves_diagram.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/diagram_curve.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/diagram_x_value_label.dart';
import 'package:sss_computing_client/core/widgets/curves_diagram/diagram_y_value_label.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
/// Displays stability diagram. Diagram displays static and dynamic
/// stability curves and initial metacentric height line.
class StabilityDiagram extends StatelessWidget {
  static const _minX = 0.0;
  static const _maxX = 90.0;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  /// Creates widget that displaying stability diagram.
  ///   [apiAddress] – [ApiAddress] of server that interact with database;
  ///   [dbName] – name of the database;
  ///   [authToken] – string authentication token for accessing server;
  ///   [appRefreshStream] – stream with events causing data to be updated.
  const StabilityDiagram({
    super.key,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken,
        _appRefreshStream = appRefreshStream;
  //
  @override
  Widget build(BuildContext context) {
    final shipId = const Setting('shipId').toInt;
    final theme = Theme.of(context);
    final labelsColor = theme.colorScheme.primary;
    final gridColor = theme.colorScheme.primary;
    final labelsStyle = theme.textTheme.labelSmall ?? const TextStyle();
    return FutureBuilderWidget(
      refreshStream: _appRefreshStream,
      onFuture: FieldRecord<double>(
        tableName: 'parameter_data',
        fieldName: 'result',
        dbName: _dbName,
        apiAddress: _apiAddress,
        authToken: _authToken,
        toValue: (value) => double.parse(value),
        filter: {
          'parameter_id': 18,
          'ship_id': shipId,
        },
      ).fetch,
      caseData: (context, h, _) => FutureBuilderWidget(
        refreshStream: _appRefreshStream,
        onFuture: FieldRecord<double>(
          tableName: 'parameter_data',
          fieldName: 'result',
          dbName: _dbName,
          apiAddress: _apiAddress,
          authToken: _authToken,
          toValue: (value) => double.parse(value),
          filter: {
            'parameter_id': 7,
            'ship_id': shipId,
          },
        ).fetch,
        caseData: (context, theta0, _) => FutureBuilderWidget(
          refreshStream: _appRefreshStream,
          onFuture: PgStaticStabilityCurve(
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
          ).points,
          caseData: (context, staticCurve, _) => FutureBuilderWidget(
            refreshStream: _appRefreshStream,
            onFuture: PgDynamicStabilityCurve(
              apiAddress: _apiAddress,
              dbName: _dbName,
              authToken: _authToken,
            ).points,
            caseData: (context, dynamicCurve, _) => CurvesDiagram(
              minX: _minX,
              maxX: _maxX,
              maxY: _getMaxY(
                curves: [staticCurve, dynamicCurve],
                initialValue: h,
                gap: 1.0,
              ),
              xAxis: ChartAxis(
                valueInterval: 10,
                captionSpaceReserved: 16,
                labelsSpaceReserved: 32,
                caption:
                    '${const Localized('Angle of heel').v}, ${theta0 < 0.0 ? const Localized('to port side').v : const Localized('to starboard').v}',
                valueUnit: const Localized('deg').v,
                isLabelsVisible: true,
                isCaptionVisible: true,
              ),
              yAxis: ChartAxis(
                valueInterval: 0.5,
                captionSpaceReserved: 16,
                labelsSpaceReserved: 36,
                caption: const Localized('Righting lever').v,
                valueUnit: const Localized('m').v,
                isLabelsVisible: true,
                isCaptionVisible: true,
              ),
              labelsColor: labelsColor,
              gridColor: gridColor,
              curves: [
                DiagramCurve(
                  points: MetacentricHeightLine(
                    minX: _minX,
                    maxX: _maxX,
                    theta0: theta0.abs(),
                    h: h,
                  ).points().value,
                  caption: const Localized('h').v,
                  color: Colors.purpleAccent,
                ),
                DiagramCurve(
                  points: staticCurve,
                  caption: const Localized('dso').v,
                  color: Colors.greenAccent,
                ),
                DiagramCurve(
                  points: dynamicCurve,
                  caption: const Localized('ddo').v,
                  color: Colors.orangeAccent,
                ),
              ],
              xLabels: [
                DiagramXValueLabel(
                  caption:
                      'θ₀ (${theta0.abs().toStringAsFixed(1)}${const Localized('deg').v})',
                  value: theta0.abs(),
                  color: labelsColor,
                  style: labelsStyle,
                ),
                DiagramXValueLabel(
                  caption:
                      'θ₀ + 1 ${const Localized('radian').v} (${(theta0.abs() + radians2Degrees).toStringAsFixed(1)}${const Localized('deg').v}))',
                  value: theta0.abs() + radians2Degrees,
                  color: labelsColor,
                  style: labelsStyle,
                ),
              ],
              yLabels: [
                DiagramYValueLabel(
                  caption:
                      '${const Localized('h').v} (${h.toStringAsFixed(2)} ${const Localized('m').v})',
                  value: h,
                  color: labelsColor,
                  style: labelsStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //
  double _getMaxY({
    required List<List<Offset>> curves,
    double initialValue = 0.0,
    double gap = 0.0,
  }) =>
      curves.fold(initialValue, (curr, curve) {
        final curveMaxY = curve
            .fold(
              Offset(initialValue, initialValue),
              (curr, next) => curr.dy > next.dy ? curr : next,
            )
            .dy;
        return curveMaxY > curr ? curveMaxY : curr;
      }) +
      gap;
}
