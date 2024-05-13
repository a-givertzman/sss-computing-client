import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces.dart';
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
  late final StreamController<List<StrengthForce>> _shearForcesController;
  late final StreamController<List<StrengthForce>> _bendingMomentsController;
  late final ApiAddress apiAddress;
  late final String dbName;
  late final String? authToken;
  //
  @override
  void initState() {
    _shearForcesController = StreamController();
    _bendingMomentsController = StreamController();
    apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    dbName = const Setting('api-database').toString();
    authToken = const Setting('api-auth-token').toString();
    _fetchShearForces();
    _fetchBendingMoments();
    super.initState();
  }
  //
  @override
  void dispose() {
    _shearForcesController.close();
    _bendingMomentsController.close();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final shearForces = _shearForcesController.stream.asBroadcastStream();
    final bendingMoments = _bendingMomentsController.stream.asBroadcastStream();
    return Scaffold(
      body: StrengthPageBody(
        shearForceStream: shearForces,
        bendingMomentStream: bendingMoments,
      ),
    );
  }
  ///
  void _fetchShearForces() {
    PgShearForces(
      apiAddress: apiAddress,
      dbName: dbName,
      authToken: authToken,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_shearForcesController.isClosed
              ? _shearForcesController.add(forces)
              : null,
          Err(:final error) => Log('$runtimeType').error(error.message),
        });
  }
  ///
  void _fetchBendingMoments() {
    PgBendingMoments(
      apiAddress: apiAddress,
      dbName: dbName,
      authToken: authToken,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_shearForcesController.isClosed
              ? _bendingMomentsController.add(forces)
              : null,
          Err(:final error) => Log('$runtimeType').error(error.message),
        });
  }
}
