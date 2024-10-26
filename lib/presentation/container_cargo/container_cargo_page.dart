import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/container_cargo_body.dart';
///
class ContainerCargoPage extends StatelessWidget {
  final void Function() _onClose;
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>) _onSave;
  final String _label;
  final FreightContainer _container;
  final bool _fetchData;
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
    required Future<ResultF<List<FieldData>>> Function(List<FieldData>) onSave,
    required String label,
    required FreightContainer container,
    bool fetchData = false,
  })  : _onSave = onSave,
        _onClose = onClose,
        _label = label,
        _container = container,
        _fetchData = fetchData;
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
              onPressed: _onClose,
            ),
          ),
        ),
        title: Text(_label),
      ),
      body: ContainerCargoBody(
        onSave: _onSave,
        container: _container,
        fetchData: _fetchData,
      ),
    );
  }
}
