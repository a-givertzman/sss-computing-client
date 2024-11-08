import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container_type.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/json_freight_container.dart';
import 'package:sss_computing_client/core/models/voyage/pg_waypoints.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/container_cargo_body.dart';
///
/// Page to configure [FreightContainer] entry.
class ContainerCargoPage extends StatefulWidget {
  final void Function() _onClose;
  final Future<ResultF<void>> Function(
    FreightContainer container,
    int containersNumber,
  ) _onSave;
  final FreightContainer? _container;
  final String _label;
  ///
  /// Creates page to configure [container] entry.
  ///
  /// [onClose] and [onSave] callbacks run after returning on previous page
  /// or saving edited data, respectively.
  ///
  /// [label] used as page title.
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
    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          message: const Localized('Back').v,
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
  Future<ResultF<List<FieldData>>> _onFormSave(List<FieldData> fields) {
    final fieldsValues = {
      for (final field in fields)
        field.id: field.toValue(
          field.controller.text,
        ),
    };
    final containersNumber = fieldsValues['containersNumber'] as int;
    return widget
        ._onSave(
          _containerFromFields(fieldsValues),
          containersNumber,
        )
        .then((saveResult) => saveResult.map((_) => fields));
  }
  FreightContainer _containerFromFields(Map<String, dynamic> fieldsValues) {
    return JsonFreightContainer.fromRow(
      {
        'id': widget._container?.id ?? -1,
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
        'polWaypointId': (fieldsValues['pol'] as Waypoint).id,
        'podWaypointId': (fieldsValues['pod'] as Waypoint).id,
      },
    );
  }
}
