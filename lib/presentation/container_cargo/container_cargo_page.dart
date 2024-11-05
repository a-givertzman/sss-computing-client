import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
import 'package:sss_computing_client/core/models/stowage/container/json_freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/pg_waypoints.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/container_cargo_body.dart';
///
class ContainerCargoPage extends StatefulWidget {
  final void Function() _onClose;
  final Future<ResultF<void>> Function(
    FreightContainer container,
    int containersNumber,
  ) _onSave;
  final FreightContainer? _container;
  final String _label;
  ///
  /// TODO: update doc
  ///
  /// [onClose] and [onSave] callbacks run after returning on previous page
  /// or saving edited data, respectively.
  ///
  /// [label] used as title of page.
  ///
  /// [container] is instance of [Cargo] to be configured.
  /// Data for the the [container] will be fetched if [fetchData] is true.
  const ContainerCargoPage({
    super.key,
    required void Function() onClose,
    required Future<ResultF<void>> Function(
      FreightContainer container,
      int containersNumber,
    ) onSave,
    required String label,
    FreightContainer? container,
  })  : _onSave = onSave,
        _onClose = onClose,
        _label = label,
        _container = container;
  //
  @override
  State<ContainerCargoPage> createState() => _ContainerCargoPageState();
}
///
class _ContainerCargoPageState extends State<ContainerCargoPage> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String _authToken;
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: Tooltip(
          message: const Localized('Назад').v,
          child: TooltipVisibility(
            visible: false,
            child: BackButton(
              onPressed: widget._onClose,
            ),
          ),
        ),
        title: Text(widget._label),
      ),
      body: FutureBuilderWidget(
        onFuture: PgWaypoints(
          apiAddress: _apiAddress,
          dbName: _dbName,
          authToken: _authToken,
        ).fetchAll,
        caseData: (context, waypoints, _) => ContainerCargoBody(
          onSave: _onFormSave,
          container: widget._container,
          waypoints: waypoints,
        ),
      ),
    );
  }
  //
  Future<ResultF<List<FieldData>>> _onFormSave(List<FieldData> fields) async {
    final fieldsValues = {
      for (final field in fields)
        field.id: field.toValue(
          field.controller.text,
        ),
    };
    final containerRow = {
      'id': -1,
      'isoCode': FreightContainerType.fromSizeCode(
        '${fieldsValues['lengthCode']}${fieldsValues['heightCode']}',
      ).isoCode,
      'serialCode': fieldsValues['serialCode'],
      'typeCode': fieldsValues['typeCode'],
      'ownerCode': fieldsValues['ownerCode'],
      'checkDigit': fieldsValues['checkDigit'],
      'grossWeight': fieldsValues['grossWeight'],
      'maxGrossWeight': fieldsValues['maxGrossWeight'],
      'tareWeight': fieldsValues['tareWeight'],
      'polWaypointId': fieldsValues['pol'].id,
      'podWaypointId': fieldsValues['pod'].id,
    };
    final containersNumber = fieldsValues['containersNumber'] as int;
    final saveResult = await widget._onSave(
      JsonFreightContainer.fromRow(containerRow),
      containersNumber,
    );
    return switch (saveResult) {
      Ok() => Ok(fields),
      Err(:final error) => Err(error),
    };
  }
}
