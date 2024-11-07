import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/presentation/other_stores_cargo/widgets/other_stores_cargo_body.dart';
///
/// Page for configuration of other stores cargo.
class OtherStoresCargoPage extends StatelessWidget {
  final void Function() _onClose;
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>) _onSave;
  final String _label;
  final Cargo _cargo;
  final bool _fetchData;
  ///
  /// Creates page for configuration of other stores cargo
  ///
  /// [onClose] and [onSave] callbacks run after returning on previous page
  /// or saving edited data, respectively.
  ///
  /// [label] used as title of page.
  ///
  /// [cargo] is instance of [Cargo] to be configured.
  /// Data for the the [cargo] will be fetched if [fetchData] is true.
  const OtherStoresCargoPage({
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: _onClose,
        ),
        title: Text(_label),
      ),
      body: OtherStoresCargoBody(
        onSave: _onSave,
        cargo: _cargo,
        fetchData: _fetchData,
      ),
    );
  }
}
