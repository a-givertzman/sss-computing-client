import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces_limited.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/strength/widgets/strength_page_body.dart';
///
class StrengthPage extends StatefulWidget {
  ///
  const StrengthPage({super.key});
  //
  @override
  State<StrengthPage> createState() => _StrengthPageState();
}
///
class _StrengthPageState extends State<StrengthPage> {
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
  void dispose() {
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilderWidget(
        onFuture: () => PgShearForcesLimited(
          apiAddress: _apiAddress,
          dbName: _dbName,
          authToken: _authToken,
        ).fetchAll(),
        caseData: (_, shearForces, __) => FutureBuilderWidget(
          onFuture: () => PgBendingMomentsLimited(
            apiAddress: _apiAddress,
            dbName: _dbName,
            authToken: _authToken,
          ).fetchAll(),
          caseData: (_, bendingMoments, __) => StrengthPageBody(
            shearForces: shearForces,
            bendingMoments: bendingMoments,
          ),
        ),
      ),
    );
  }
}
