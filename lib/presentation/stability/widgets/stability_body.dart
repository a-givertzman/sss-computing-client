import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/criterion/pg_stability_criterions.dart';
import 'package:sss_computing_client/core/models/stability_parameter/pg_stability_parameters.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterion_list.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterions_summary.dart';
import 'package:sss_computing_client/presentation/stability/widgets/parameters_table.dart';
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
    final theme = Theme.of(context);
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
                Expanded(
                  child: FutureBuilderWidget(
                    refreshStream: widget._appRefreshStream,
                    onFuture: PgStabilityCriterions(
                      dbName: _dbName,
                      apiAddress: _apiAddress,
                      authToken: _authToken,
                    ).fetchAll,
                    caseData: (context, criterions, _) {
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${const Localized('Критерии остойчивости').v}:',
                                    textAlign: TextAlign.start,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  CriterionsSummary(criterions: criterions),
                                ],
                              ),
                              SizedBox(height: padding),
                              Expanded(
                                flex: 1,
                                child: CriterionList(criterions: criterions),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: padding),
          Expanded(
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: FutureBuilderWidget(
                  onFuture: PgStabilityParameters(
                    apiAddress: _apiAddress,
                    dbName: _dbName,
                    authToken: _authToken,
                  ).fetchAll,
                  caseData: (_, parameters, __) => StabilityParametersTable(
                    parameters: parameters,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
