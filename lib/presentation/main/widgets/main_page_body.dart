import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/presentation/main/widgets/allowed_strength_force_chart.dart';
import 'package:sss_computing_client/presentation/main/widgets/future_circular_value_indicator.dart';
import 'package:sss_computing_client/presentation/main/widgets/metacentric_height_indicator.dart';
import 'package:sss_computing_client/presentation/main/widgets/weight_indicators.dart';
///
class MainPageBody extends StatefulWidget {
  ///
  const MainPageBody({super.key});
  //
  @override
  State<MainPageBody> createState() => _MainPageBodyState();
}
class _MainPageBodyState extends State<MainPageBody> {
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
    final blockPadding = const Setting('padding', factor: 2.0).toDouble;
    final padding = const Setting('padding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Column(
        children: [
          const Spacer(),
          SizedBox(height: blockPadding),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.all(0.0),
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: AllowedStrengthForceChart(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: MetacentricHeightIndicator(
                              apiAddress: _apiAddress,
                              dbName: _dbName,
                              authToken: _authToken,
                            ),
                          ),
                          SizedBox(width: padding),
                          const Expanded(
                            child: DisabledWidget(
                              disabled: true,
                              child: FCircularValueIndicator(
                                title: 'Bulk',
                                valueUnit: '°',
                                minValue: 0,
                                maxValue: 360,
                                low: 60.0,
                                high: 300.0,
                                future: null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: blockPadding),
          Expanded(
            child: WeightIndicators(
              apiAddress: _apiAddress,
              dbName: _dbName,
              authToken: _authToken,
            ),
          ),
        ],
      ),
    );
  }
}
