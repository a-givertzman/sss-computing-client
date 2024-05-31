import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/core/models/metacentric_height/lerp_metacentric_height_limit.dart';
import 'package:sss_computing_client/core/models/metacentric_height/pg_metacentric_height_limits.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/main/widgets/future_circular_value_indicator.dart';
///
/// Widget for indicating metacentric height value.
class MetacentricHeightIndicator extends StatelessWidget {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates widget that fetching data about metacentric height
  /// and displaying it as CircularValueIndicator widget.
  ///
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `dbName` - name of the database;
  ///   - `authToken` - string authentication token for accessing server.
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
        caseData: (context, displacement, _) {
          final limit = LerpMetacentricHeightLimit(
            shipId: limits.first.shipId,
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
    return FCircularValueIndicator(
      future: FieldRecord<double>(
        tableName: 'result_stability',
        fieldName: 'result',
        dbName: _dbName,
        apiAddress: _apiAddress,
        authToken: _authToken,
        toValue: (value) => double.parse(value),
      ).fetch(filter: {'criterion_id': 12}),
      title: const Localized('Metacentric height').v,
      valueUnit: const Localized('m').v,
      fractionDigits: 2,
      low: low,
      high: high,
      minValue: 0,
      maxValue: (high ?? 0.0) + 1.0,
    );
  }
}
