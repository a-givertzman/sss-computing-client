import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/core/models/metacentric_height/lerp_metacentric_height_limit.dart';
import 'package:sss_computing_client/core/models/metacentric_height/pg_metacentric_height_limits.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/main/widgets/future_circular_value_indicator.dart';
///
class MetacentricHeightIndicator extends StatelessWidget {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const MetacentricHeightIndicator({
    super.key,
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilderWidget(
      onFuture: () => PgMetacentricHeightLimits(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll(),
      caseLoading: (context) => _buildCaseLoading(),
      caseData: (context, limits, _) => FutureBuilderWidget(
        onFuture: () => FieldRecord<double>(
          tableName: 'loads_general',
          fieldName: 'displacement',
          dbName: _dbName,
          apiAddress: _apiAddress,
          authToken: _authToken,
          toValue: (value) => double.parse(value),
        ).fetch(),
        caseLoading: (context) => _buildCaseLoading(),
        caseData: (context, displacement, retry) {
          final limit = LerpMetacentricHeightLimit(
            shipId: 1,
            displacement: displacement,
            limits: limits,
          );
          return _buildCaseData(low: limit.low, high: limit.high);
        },
      ),
    );
  }
  //
  Widget _buildCaseLoading() {
    return const Stack(
      children: [
        Positioned.fill(
          child: FCircularValueIndicator(
            future: null,
            title: 'Metacentric height',
            valueUnit: 'm',
          ),
        ),
        Positioned.fill(
          child: CupertinoActivityIndicator(),
        ),
      ],
    );
  }
  //
  Widget _buildCaseData({required double? low, required double? high}) {
    return FCircularValueIndicator(
      future: FieldRecord<double>(
        tableName: 'result_stability',
        fieldName: 'result',
        dbName: _dbName,
        apiAddress: _apiAddress,
        authToken: _authToken,
        toValue: (value) => double.parse(value),
      ).fetch(filter: {'criterion_id': 12}),
      title: 'Metacentric height',
      valueUnit: 'm',
      fractionDigits: 2,
      low: low,
      high: high,
      minValue: 0,
      maxValue: (high ?? 0.0) + (low ?? 0.0),
    );
  }
}
