import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/general_parameter/pg_parameter_value.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
///
/// Widget for showing general information.
class GeneralInfoWidget extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  /// Creates widget for showing general information.
  const GeneralInfoWidget({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
  //
  @override
  State<GeneralInfoWidget> createState() => _GeneralInfoWidgetState();
}
///
class _GeneralInfoWidgetState extends State<GeneralInfoWidget> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: blockPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _InfoWidget(
            parameterId: 3,
            appRefreshStream: widget._appRefreshStream,
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
            name: const Localized('Draught').v,
            unit: const Localized('m').v,
          ),
          SizedBox(height: blockPadding),
          _InfoWidget(
            parameterId: 7,
            appRefreshStream: widget._appRefreshStream,
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
            name: const Localized('Heel').v,
            unit: const Localized('deg').v,
          ),
          SizedBox(height: blockPadding),
          _InfoWidget(
            parameterId: 51,
            appRefreshStream: widget._appRefreshStream,
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
            name: const Localized('Trim').v,
            unit: const Localized('m').v,
          ),
        ],
      ),
    );
  }
}
///
/// Widget that fetches parameter value and shows it.
class _InfoWidget extends StatelessWidget {
  final int parameterId;
  final Stream<DsDataPoint<bool>> appRefreshStream;
  final ApiAddress apiAddress;
  final String dbName;
  final String? authToken;
  final String name;
  final String? unit;
  ///
  /// Creates widget that fetches parameter value by [parameterId] and shows it.
  const _InfoWidget({
    required this.parameterId,
    required this.appRefreshStream,
    required this.apiAddress,
    required this.dbName,
    required this.authToken,
    required this.name,
    this.unit,
  });
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return SizedBox(
      height: 50.0,
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: padding),
          Expanded(
            child: FutureBuilderWidget(
              refreshStream: appRefreshStream,
              onFuture: () => PgParameterValues(
                apiAddress: apiAddress,
                dbName: dbName,
                authToken: authToken,
              ).fetchById(parameterId),
              caseData: (_, value, __) => Text(
                '${value.value.toStringAsFixed(2)} ${unit ?? ''}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
