import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargos.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_test.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';

///
class ShipSchemePage extends StatefulWidget {
  ///
  const ShipSchemePage({super.key});

  ///
  @override
  State<ShipSchemePage> createState() => _ShipSchemePageState();
}

class _ShipSchemePageState extends State<ShipSchemePage> {
  late final String _dbName;
  late final ApiAddress _address;

  ///
  @override
  void initState() {
    _dbName = const Setting('api-database').toString();
    _address = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilderWidget<List<Cargo>>(
        onFuture: DbCargos(
          dbName: _dbName,
          apiAddress: _address,
        ).fetchAll,
        caseData: (context, data) => ShipSchemeTest(cargos: data),
      ),
    );
  }
}
