import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/metacentric_height/lerp_metacentric_height_limit.dart';
import 'package:sss_computing_client/core/models/metacentric_height/pg_metacentric_height_high_limits.dart';
import 'package:sss_computing_client/core/models/metacentric_height/pg_metacentric_height_low_limits.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/main/widgets/future_circular_value_indicator.dart';
///
/// Widget for indicating metacentric height value.
class MetacentricHeightIndicator extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates widget that fetching data about metacentric height
  /// and displaying it as CircularValueIndicator widget.
  ///
  ///   - [apiAddress] – [ApiAddress] of server that interact with database;
  ///   - [dbName] – name of the database;
  ///   - [authToken] – string authentication token for accessing server.
  const MetacentricHeightIndicator({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _appRefreshStream = appRefreshStream,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Widget build(BuildContext context) {
    final shipId = const Setting('shipId').toInt;
    final projectId = int.tryParse(const Setting('projectId').toString());
    return FutureBuilderWidget(
      refreshStream: _appRefreshStream,
      onFuture: PgMetacentricHeightLowLimits(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll,
      caseLoading: (context) => _buildCaseLoading(),
      caseData: (context, lowLimits, _) {
        return FutureBuilderWidget(
          refreshStream: _appRefreshStream,
          onFuture: PgMetacentricHeightHighLimits(
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
          ).fetchAll,
          caseLoading: (context) => _buildCaseLoading(),
          caseData: (context, highLimits, _) => FutureBuilderWidget(
            refreshStream: _appRefreshStream,
            onFuture: FieldRecord<double>(
              tableName: 'heel_trim_general',
              fieldName: 'draft_avg_value',
              dbName: _dbName,
              apiAddress: _apiAddress,
              authToken: _authToken,
              toValue: (value) => double.parse(value),
              filter: {'ship_id': 1},
            ).fetch,
            caseLoading: (context) => _buildCaseLoading(),
            caseData: (context, draft, _) {
              return FutureBuilderWidget(
                refreshStream: _appRefreshStream,
                onFuture: FieldRecord<double>(
                  tableName: 'loads_general',
                  fieldName: 'displacement',
                  dbName: _dbName,
                  apiAddress: _apiAddress,
                  authToken: _authToken,
                  toValue: (value) => double.parse(value),
                  filter: {'ship_id': 1},
                ).fetch,
                caseLoading: (context) => _buildCaseLoading(),
                caseData: (context, displacement, _) {
                  final lowLimit = LerpMetacentricHeightLimit(
                    shipId: shipId,
                    projectId: projectId,
                    displacement: draft,
                    limits: lowLimits,
                  );
                  final highLimit = LerpMetacentricHeightLimit(
                    shipId: shipId,
                    projectId: projectId,
                    displacement: displacement,
                    limits: highLimits,
                  );
                  return _buildCaseData(
                    low: lowLimit.value,
                    high: highLimit.value,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
  //
  Widget _buildCaseLoading() {
    return Stack(
      children: [
        Positioned.fill(
          child: FCircularValueIndicator(
            future: null,
            title: const Localized('Metacentric height').v,
            valueUnit: const Localized('m').v,
          ),
        ),
        const Positioned.fill(
          child: CupertinoActivityIndicator(),
        ),
      ],
    );
  }
  //
  Widget _buildCaseData({required double? low, required double? high}) {
    final infSymbol = const Localized('inf').v;
    final andSymbol = const Localized('and').v;
    return Tooltip(
      message:
          '> ${low?.toStringAsFixed(2) ?? '-$infSymbol'} $andSymbol < ${high?.toStringAsFixed(2) ?? infSymbol}',
      child: FCircularValueIndicator(
        future: FieldRecord<double>(
          tableName: 'parameter_data',
          fieldName: 'result',
          dbName: _dbName,
          apiAddress: _apiAddress,
          authToken: _authToken,
          toValue: (value) => double.parse(value),
          filter: {'parameter_id': 18},
        ).fetch(),
        title: const Localized('Metacentric height').v,
        valueUnit: const Localized('m').v,
        fractionDigits: 2,
        low: low,
        high: high,
        minValue: 0,
        maxValue: (high ?? 0.0) + 1.0,
      ),
    );
  }
}
