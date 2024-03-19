import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/presentation/cargo/widgets/cargo_body.dart';

class CargoPage extends StatelessWidget {
  const CargoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CargoBody(
        cargos: DbCargos(
          dbName: 'sss-computing',
          apiAddress: ApiAddress.localhost(port: 8080),
        ),
      ),
    );
  }
}
