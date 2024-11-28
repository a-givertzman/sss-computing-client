import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/criterion/pg_draught_criterions.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/stability/widgets/stability_criterions_list.dart';
///
/// TODO: add doc
class DraftCriteria extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  const DraftCriteria({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
  //
  @override
  State<DraftCriteria> createState() => _DraftCriteriaState();
}
///
class _DraftCriteriaState extends State<DraftCriteria> {
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
    return FutureBuilderWidget(
      refreshStream: widget._appRefreshStream,
      onFuture: PgDraughtCriterions(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll,
      caseData: (context, criterions, _) {
        return StabilityCriterionsList(
          criterions: criterions,
          title: const Localized('draft criteria').v,
        );
      },
    );
  }
}
