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
      nParts: 20,
      firstLimit: 50,
      minY: -200,
      maxY: 200,
      minX: -100,
    ).fetchAll().then((result) => switch (result) {
          Ok(value: final forces) => !_shearForcesController.isClosed
              ? _shearForcesController.add(forces)
              : null,
        });
    const FakeStrengthForces(
      valueRange: 100,
      nParts: 20,
      firstLimit: 150,
      minY: -500,
      maxY: 500,
      minX: -100,
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
    return Scaffold(
      body: StrengthPageBody(
        shearForceStream:
          _shearForcesController.stream.asBroadcastStream(),
        bendingMomentStream:
          _bendingMomentsController.stream.asBroadcastStream(),
    ),
    );
  }
}
