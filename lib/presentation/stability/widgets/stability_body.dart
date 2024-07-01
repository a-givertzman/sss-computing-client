import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/stability/widgets/stability_diagram.dart';
///
class StabilityBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  const StabilityBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
  //
  @override
  State<StabilityBody> createState() => _StabilityBodyState();
}
class _StabilityBodyState extends State<StabilityBody> {
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
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(blockPadding),
                      child: StabilityDiagram(
                        apiAddress: _apiAddress,
                        dbName: _dbName,
                        authToken: _authToken,
                        appRefreshStream: widget._appRefreshStream,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: padding),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(width: padding),
          const Spacer(),
        ],
      ),
    );
  }
}
