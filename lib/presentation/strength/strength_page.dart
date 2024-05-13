import 'dart:async';
import 'package:flutter/material.dart';
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
  //
  @override
  void initState() {
    _shearForcesController = StreamController();
    _bendingMomentsController = StreamController();
    const FakeStrengthForces(
      valueRange: 50,
      nParts: 21,
      firstLimit: 50,
      minY: -200,
      maxY: 200,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_shearForcesController.isClosed
              ? _shearForcesController.add(forces)
              : null,
        });
    const FakeStrengthForces(
      valueRange: 100,
      nParts: 21,
      firstLimit: 150,
      minY: -500,
      maxY: 500,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_bendingMomentsController.isClosed
              ? _bendingMomentsController.add(forces)
              : null,
        });
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
}
