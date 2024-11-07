import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/widgets/form/compund_field_data_validation.dart';
import 'package:sss_computing_client/core/widgets/form/field_data_form.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_lcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_name_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_tcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_vcg_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_weight_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_x1_column.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_column/cargo_x2_column.dart';
///
/// Form for configuration of other stores cargo.
class OtherStoresCargoBody extends StatefulWidget {
  final Future<ResultF<List<FieldData>>> Function(List<FieldData>) _onSave;
  final Cargo _cargo;
  final bool _fetchData;
  ///
  /// Creates form for configuration of other stores cargo.
  ///
  /// [onSave] callbacks run after saving edited data
  ///
  /// [cargo] is instance of [Cargo] to be configured.
  /// Data for the the [cargo] will be fetched if [fetchData] is true.
  const OtherStoresCargoBody({
    super.key,
    required Future<ResultF<List<FieldData>>> Function(List<FieldData>) onSave,
    required Cargo cargo,
    bool fetchData = false,
  })  : _onSave = onSave,
        _cargo = cargo,
        _fetchData = fetchData;
  //
  @override
  State<OtherStoresCargoBody> createState() => _OtherStoresCargoBodyState();
}
///
class _OtherStoresCargoBodyState extends State<OtherStoresCargoBody> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
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
    final blockPadding = const Setting('blockPadding').toDouble;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(blockPadding),
        child: SizedBox(
          width: 500.0,
          child: FieldDataForm(
            label: const Localized('Cargo parameters').v,
            onSave: widget._onSave,
            fieldDatas: _mapColumnsToFields(
              cargo: widget._cargo,
              fetch: widget._fetchData,
              columns: [
                CargoNameColumn(
                  buildRecord: (cargo, toValue) => FieldRecord<String?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'name',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoWeightColumn(
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'mass',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoLCGColumn(
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'mass_shift_x',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoTCGColumn(
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'mass_shift_y',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoVCGColumn(
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'mass_shift_z',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoX1Column(
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'bound_x1',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
                CargoX2Column(
                  buildRecord: (cargo, toValue) => FieldRecord<double?>(
                    dbName: _dbName,
                    apiAddress: ApiAddress(
                      host: _apiAddress.host,
                      port: _apiAddress.port,
                    ),
                    authToken: _authToken,
                    tableName: 'compartment',
                    fieldName: 'bound_x2',
                    filter: {'id': cargo.id},
                    toValue: toValue,
                  ),
                ),
              ],
            ),
            compundValidations: [
              CompoundFieldDataValidation(
                ownId: 'x1',
                otherId: 'lcg',
                validateValues: (x1, lcg) =>
                    switch (const LessThanOrEqualTo().process(
                  double.tryParse(x1) ?? 0.0,
                  double.tryParse(lcg) ?? 0.0,
                )) {
                  Ok(value: true) => const Ok(null),
                  Ok(value: false) => Err(Failure(
                      message: 'X1 !≤ Xg',
                      stackTrace: StackTrace.current,
                    )),
                },
              ),
              CompoundFieldDataValidation(
                ownId: 'lcg',
                otherId: 'x1',
                validateValues: (lcg, x1) =>
                    switch (const LessThanOrEqualTo().swaped().process(
                          double.tryParse(lcg) ?? 0.0,
                          double.tryParse(x1) ?? 0.0,
                        )) {
                  Ok(value: true) => const Ok(null),
                  Ok(value: false) => Err(Failure(
                      message: 'X1 !≤ Xg',
                      stackTrace: StackTrace.current,
                    )),
                },
              ),
              CompoundFieldDataValidation(
                ownId: 'lcg',
                otherId: 'x2',
                validateValues: (lcg, x2) =>
                    switch (const LessThanOrEqualTo().process(
                  double.tryParse(lcg) ?? 0.0,
                  double.tryParse(x2) ?? 0.0,
                )) {
                  Ok(value: true) => const Ok(null),
                  Ok(value: false) => Err(Failure(
                      message: 'Xg !≤ X2',
                      stackTrace: StackTrace.current,
                    )),
                },
              ),
              CompoundFieldDataValidation(
                ownId: 'x2',
                otherId: 'lcg',
                validateValues: (x2, lcg) =>
                    switch (const LessThanOrEqualTo().swaped().process(
                          double.tryParse(x2) ?? 0.0,
                          double.tryParse(lcg) ?? 0.0,
                        )) {
                  Ok(value: true) => const Ok(null),
                  Ok(value: false) => Err(Failure(
                      message: 'Xg !≤ X2',
                      stackTrace: StackTrace.current,
                    )),
                },
              ),
              CompoundFieldDataValidation(
                ownId: 'x1',
                otherId: 'x2',
                validateValues: (x1, x2) => switch (const LessThan().process(
                  double.tryParse(x1) ?? 0.0,
                  double.tryParse(x2) ?? 0.0,
                )) {
                  Ok(value: true) => const Ok(null),
                  Ok(value: false) => Err(Failure(
                      message: 'X1 !< X2',
                      stackTrace: StackTrace.current,
                    )),
                },
              ),
              CompoundFieldDataValidation(
                ownId: 'x2',
                otherId: 'x1',
                validateValues: (x2, x1) =>
                    switch (const LessThan().swaped().process(
                          double.tryParse(x2) ?? 0.0,
                          double.tryParse(x1) ?? 0.0,
                        )) {
                  Ok(value: true) => const Ok(null),
                  Ok(value: false) => Err(Failure(
                      message: 'X1 !< X2',
                      stackTrace: StackTrace.current,
                    )),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  //
  List<FieldData> _mapColumnsToFields({
    required List<TableColumn<Cargo, dynamic>> columns,
    required Cargo cargo,
    required bool fetch,
  }) =>
      columns
          .map(
            (col) => FieldData(
              id: col.key,
              label: col.name,
              initialValue: col.defaultValue,
              validator: col.validator,
              record: col.buildRecord(cargo, col.parseToValue)!,
              toValue: col.parseToValue,
              toText: col.parseToString,
              isSynced: !fetch,
            ),
          )
          .toList();
}
