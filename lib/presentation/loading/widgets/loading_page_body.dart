import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/presentation/loading/widgets/ballasts.dart';
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
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            dividerColor: Theme.of(context).colorScheme.surface,
            dividerHeight: 2.0,
            tabs: <Widget>[
              Tab(
                text: const Localized('Ballast').v,
              ),
              Tab(
                text: const Localized('Цистерны запаса').v,
              ),
              Tab(
                text: const Localized('Прочие запасы').v,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Ballasts(
                  appRefreshStream: widget._appRefreshStream,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
                StoresTanks(
                  appRefreshStream: widget._appRefreshStream,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
                OtherStores(
                  appRefreshStream: widget._appRefreshStream,
                  apiAddress: widget._apiAddress,
                  dbName: widget._dbName,
                  authToken: widget._authToken,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
