import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/tabs/tab_setting.dart';
import 'package:sss_computing_client/core/widgets/tabs/tabs_view_widget.dart';
import 'package:sss_computing_client/presentation/loading/widgets/ballasts_tanks.dart';
import 'package:sss_computing_client/presentation/loading/widgets/other_stores.dart';
import 'package:sss_computing_client/presentation/loading/widgets/stores_tanks.dart';
///
class LoadingPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  const LoadingPageBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _appRefreshStream = appRefreshStream,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  State<LoadingPageBody> createState() => _LoadingPageBodyState();
}
class _LoadingPageBodyState extends State<LoadingPageBody> {
  //
  @override
  Widget build(BuildContext context) {
    return TabViewWidget(
      isScrollable: true,
      physics: const NeverScrollableScrollPhysics(),
      tabsSettings: [
        TabSetting(
          label: const Localized('Ballast').v,
          content: BallastsTanks(
            appRefreshStream: widget._appRefreshStream,
            apiAddress: widget._apiAddress,
            dbName: widget._dbName,
            authToken: widget._authToken,
          ),
        ),
        TabSetting(
          label: const Localized('Цистерны запаса').v,
          content: StoresTanks(
            appRefreshStream: widget._appRefreshStream,
            apiAddress: widget._apiAddress,
            dbName: widget._dbName,
            authToken: widget._authToken,
          ),
        ),
        TabSetting(
          label: const Localized('Прочие запасы').v,
          content: OtherStores(
            appRefreshStream: widget._appRefreshStream,
            apiAddress: widget._apiAddress,
            dbName: widget._dbName,
            authToken: widget._authToken,
          ),
        ),
      ],
    );
  }
}
