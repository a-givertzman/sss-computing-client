import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/main/widgets/allowed_strength_force_chart.dart';
import 'package:sss_computing_client/presentation/main/widgets/metacentric_height_indicator.dart';
import 'package:sss_computing_client/presentation/main/widgets/ship_draughts_scheme.dart';
import 'package:sss_computing_client/presentation/main/widgets/weight_indicators.dart';
///
class MainPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  const MainPageBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
  //
  @override
  State<MainPageBody> createState() => _MainPageBodyState(
        appRefreshStream: _appRefreshStream,
      );
}
///
class _MainPageBodyState extends State<MainPageBody> {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  ///
  _MainPageBodyState({
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
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
    final blockPadding = const Setting('padding', factor: 2.0).toDouble;
    final padding = const Setting('padding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(0.0),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: ShipDraughtsScheme(
                  appRefreshStream: _appRefreshStream,
                  apiAddress: _apiAddress,
                  dbName: _dbName,
                  authToken: _authToken,
                ),
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.all(0.0),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: AllowedStrengthForceChart(
                        appRefreshStream: _appRefreshStream,
                        apiAddress: _apiAddress,
                        dbName: _dbName,
                        authToken: _authToken,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: blockPadding),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: MetacentricHeightIndicator(
                        appRefreshStream: _appRefreshStream,
                        apiAddress: _apiAddress,
                        dbName: _dbName,
                        authToken: _authToken,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: blockPadding),
          WeightIndicators(
            appRefreshStream: _appRefreshStream,
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
          ),
        ],
      ),
    );
  }
}
