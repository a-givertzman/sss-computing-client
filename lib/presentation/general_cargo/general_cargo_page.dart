import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/presentation/general_cargo/widgets/general_cargo_body.dart';
///
/// Page for configuration of general cargo.
class GeneralCargoPage extends StatelessWidget {
  final void Function() _onClose;
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>) _onSave;
  final String _label;
  final Cargo _cargo;
  final bool _fetchData;
  ///
  /// Creates page for configuration of general cargo
  ///
  /// [onClose] and [onSave] callbacks run after returning on previous page
  /// or saving edited data, respectively.
  ///
  /// [label] used as title of page.
  ///
  /// [cargo] is instance of [Cargo] to be configured.
  /// Data for the the [cargo] will be fetched if [fetchData] is true.
  const GeneralCargoPage({
    super.key,
    required void Function() onClose,
    required Future<ResultF<List<FieldData>>> Function(List<FieldData>) onSave,
    required String label,
    required Cargo cargo,
    bool fetchData = false,
  })  : _onSave = onSave,
        _onClose = onClose,
        _label = label,
        _cargo = cargo,
        _fetchData = fetchData;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        leading: Tooltip(
          message: const Localized('Back').v,
          child: TooltipVisibility(
            visible: false,
            child: BackButton(
              onPressed: _onClose,
            ),
          ),
        ),
        title: Text(_label),
      ),
      body: GeneralCargoBody(
        onSave: _onSave,
        cargo: _cargo,
        fetchData: _fetchData,
      ),
    );
  }
}
