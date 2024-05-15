import 'dart:async';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/strength/strength_force_limited.dart';
import 'package:sss_computing_client/core/models/strength/strength_forces_limited.dart';
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
  late final StreamController<List<StrengthForceLimited>>
      _shearForcesController;
  late final StreamController<List<StrengthForceLimited>>
      _bendingMomentsController;
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  //
  @override
  void initState() {
    _shearForcesController = StreamController();
    _bendingMomentsController = StreamController();
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
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
        shearForces: shearForces,
        bendingMoments: bendingMoments,
      ),
    );
  }
  ///
  void _pushResultToStream<T>({
    required StreamController<T> controller,
    required ResultF<T> result,
  }) {
    switch (result) {
      case Ok(:final value):
        !controller.isClosed ? controller.add(value) : null;
      case Err(:final error):
        Log('$runtimeType').error(error.message);
    }
  }
  ///
  void _fetchShearForces() {
    PgShearForcesLimited(
      apiAddress: _apiAddress,
      dbName: _dbName,
      authToken: _authToken,
    ).fetchAll().then((result) => _pushResultToStream(
          controller: _shearForcesController,
          result: result,
        ));
  }
  ///
  void _fetchBendingMoments() {
    PgBendingMomentsLimited(
      apiAddress: _apiAddress,
      dbName: _dbName,
      authToken: _authToken,
    ).fetchAll().then((result) => _pushResultToStream(
          controller: _bendingMomentsController,
          result: result,
        ));
  }
}
