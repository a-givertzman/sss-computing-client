import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/stability/widgets/stability_body.dart';
///
class StabilityPage extends StatefulWidget {
  static const routeName = '/stability';
  ///
  const StabilityPage({super.key});
  ///
  @override
  State<StabilityPage> createState() => _StabilityPageState();
}
///
class _StabilityPageState extends State<StabilityPage> {
  late final String dbName;
  late final ApiAddress apiAddress;
  ///
  @override
  void initState() {
    dbName = const Setting('api-database').toString();
    apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return StabilityBody(dbName: dbName, apiAddress: apiAddress);
  }
}
