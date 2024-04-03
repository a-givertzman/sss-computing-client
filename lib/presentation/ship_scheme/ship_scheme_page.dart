import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_body.dart';

///
class ShipSchemePage extends StatelessWidget {
  const ShipSchemePage({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ShipSchemeBody(),
    );
  }
}