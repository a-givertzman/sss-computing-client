// import 'dart:convert';
// import 'dart:math';
// import 'package:ext_rw/ext_rw.dart' hide FieldType;
// import 'package:flutter/material.dart';
// import 'package:hmi_core/hmi_core.dart';
// import 'package:hmi_core/hmi_core_app_settings.dart';
// import 'package:hmi_core/hmi_core_result_new.dart';
// import 'package:hmi_widgets/hmi_widgets.dart';
// import 'package:sss_computing_client/core/models/cargo/cargo.dart';
// import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
// import 'package:sss_computing_client/core/models/cargo/json_cargo.dart';
// import 'package:sss_computing_client/core/models/cargo/pg_stores_others.dart';
// import 'package:sss_computing_client/core/models/field/field_data.dart';
// import 'package:sss_computing_client/core/models/field/field_type.dart';
// import 'package:sss_computing_client/core/models/record/field_record.dart';
// import 'package:sss_computing_client/core/models/frame/frames.dart';
// import 'package:sss_computing_client/core/validation/real_validation_case.dart';
// import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
// import 'package:sss_computing_client/presentation/loading/widgets/cargo_schemes.dart';
// import 'package:sss_computing_client/presentation/loading/widgets/cargo_table.dart';
// import 'package:sss_computing_client/presentation/loading/widgets/cargo_parameters/cargo_parameters_form.dart';
// ///
// class OtherStores extends StatefulWidget {
//   final Stream<DsDataPoint<bool>> _appRefreshStream;
//   final void Function() _fireRefreshEvent;
//   final ApiAddress _apiAddress;
//   final String _dbName;
//   final String? _authToken;
//   ///
//   const OtherStores({
//     super.key,
//     required Stream<DsDataPoint<bool>> appRefreshStream,
//     required void Function() fireRefreshEvent,
//     required ApiAddress apiAddress,
//     required String dbName,
//     required String? authToken,
//   })  : _appRefreshStream = appRefreshStream,
//         _fireRefreshEvent = fireRefreshEvent,
//         _apiAddress = apiAddress,
//         _dbName = dbName,
//         _authToken = authToken;
//   //
//   @override
//   State<OtherStores> createState() => _OtherStoresState();
// }
// class _OtherStoresState extends State<OtherStores> {
//   Cargo? _selectedCargo;
//   //
//   void _toggleCargo(Cargo? cargo) {
//     if (cargo?.id != _selectedCargo?.id) {
//       setState(() {
//         _selectedCargo = cargo;
//       });
//       return;
//     }
//     setState(() {
//       _selectedCargo = null;
//     });
//   }
//   //
//   @override
//   Widget build(BuildContext context) {
//     final blockPadding = const Setting('blockPadding').toDouble;
//     return FutureBuilderWidget(
//       refreshStream: widget._appRefreshStream,
//       onFuture: PgFramesReal(
//         apiAddress: widget._apiAddress,
//         dbName: widget._dbName,
//         authToken: widget._authToken,
//       ).fetchAll,
//       caseData: (context, framesReal, _) => FutureBuilderWidget(
//         refreshStream: widget._appRefreshStream,
//         onFuture: PgFramesTheoretical(
//           apiAddress: widget._apiAddress,
//           dbName: widget._dbName,
//           authToken: widget._authToken,
//         ).fetchAll,
//         caseData: (context, framesTheoretical, _) => FutureBuilderWidget(
//           refreshStream: widget._appRefreshStream,
//           onFuture: FieldRecord<Map<String, dynamic>>(
//             apiAddress: widget._apiAddress,
//             dbName: widget._dbName,
//             authToken: widget._authToken,
//             tableName: 'ship_parameters',
//             fieldName: 'value',
//             toValue: (value) => jsonDecode(value),
//             filter: {'key': 'hull_svg'},
//           ).fetch,
//           caseData: (context, hull, _) => FutureBuilderWidget(
//             refreshStream: widget._appRefreshStream,
//             onFuture: FieldRecord<Map<String, dynamic>>(
//               apiAddress: widget._apiAddress,
//               dbName: widget._dbName,
//               authToken: widget._authToken,
//               tableName: 'ship_parameters',
//               fieldName: 'value',
//               toValue: (value) => jsonDecode(value),
//               filter: {'key': 'hull_beauty_svg'},
//             ).fetch,
//             caseData: (context, hullBeauty, _) => FutureBuilderWidget(
//               refreshStream: widget._appRefreshStream,
//               onFuture: PgStoresOthers(
//                 apiAddress: widget._apiAddress,
//                 dbName: widget._dbName,
//                 authToken: widget._authToken,
//               ).fetchAll,
//               caseData: (context, cargos, _) {
//                 return Padding(
//                   padding: EdgeInsets.all(blockPadding),
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: CargoSchemes(
//                           cargos: cargos,
//                           hull: hull,
//                           hullBeauty: hullBeauty,
//                           framesReal: framesReal,
//                           framesTheoretical: framesTheoretical,
//                           onCargoTap: _toggleCargo,
//                           selectedCargo: _selectedCargo,
//                         ),
//                       ),
//                       SizedBox(height: blockPadding),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           IconButton.filled(
//                             onPressed: () => showDialog(
//                               barrierDismissible: false,
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 content: SizedBox(
//                                   height: 500.0,
//                                   width: 500.0,
//                                   child: CargoParametersForm(
//                                     onClose: () {
//                                       Navigator.of(context).pop();
//                                       _toggleCargo(null);
//                                       widget._fireRefreshEvent();
//                                     },
//                                     onSave: (fieldDatas) async {
//                                       final cargo = JsonCargo(json: {
//                                         for (final field in fieldDatas)
//                                           field.id: switch (field.type) {
//                                             FieldType.string =>
//                                               field.controller.text,
//                                             FieldType.real => double.tryParse(
//                                                 field.controller.text,
//                                               ),
//                                             FieldType.int => int.tryParse(
//                                                 field.controller.text,
//                                               ),
//                                             _ => field.controller.text,
//                                           },
//                                       });
//                                       switch (await PgStoresOthers(
//                                         apiAddress: widget._apiAddress,
//                                         dbName: widget._dbName,
//                                         authToken: widget._authToken,
//                                       ).add(cargo)) {
//                                         case Ok():
//                                           Navigator.of(context).pop(context);
//                                           widget._fireRefreshEvent();
//                                           return const Ok([]);
//                                         case Err(:final error):
//                                           return Err(error);
//                                       }
//                                     },
//                                     fieldData: [
//                                       FieldData(
//                                         id: 'name',
//                                         label: const Localized('Name').v,
//                                         unit: '',
//                                         type: FieldType.string,
//                                         initialValue: '',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'name',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                       FieldData(
//                                         id: 'mass',
//                                         label: const Localized('Mass').v,
//                                         unit: const Localized('t').v,
//                                         type: FieldType.real,
//                                         initialValue: '0.0',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'mass',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                       FieldData(
//                                         id: 'lcg',
//                                         label: const Localized('LCG').v,
//                                         unit: const Localized('m').v,
//                                         type: FieldType.real,
//                                         initialValue: '0.0',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'mass_shift_x',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                       FieldData(
//                                         id: 'tcg',
//                                         label: const Localized('TCG').v,
//                                         unit: const Localized('m').v,
//                                         type: FieldType.real,
//                                         initialValue: '0.0',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'mass_shift_y',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                       FieldData(
//                                         id: 'vcg',
//                                         label: const Localized('VCG').v,
//                                         unit: const Localized('m').v,
//                                         type: FieldType.real,
//                                         initialValue: '0.0',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'mass_shift_z',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                       FieldData(
//                                         id: 'bound_x1',
//                                         label: const Localized('X1').v,
//                                         unit: const Localized('m').v,
//                                         type: FieldType.real,
//                                         initialValue: '0.0',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'bound_x1',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                       FieldData(
//                                         id: 'bound_x2',
//                                         label: const Localized('X2').v,
//                                         unit: const Localized('m').v,
//                                         type: FieldType.real,
//                                         initialValue: '0.0',
//                                         isPersisted: true,
//                                         record: FieldRecord<String>(
//                                           toValue: (text) => text,
//                                           dbName: widget._dbName,
//                                           apiAddress: widget._apiAddress,
//                                           authToken: widget._authToken,
//                                           tableName: 'compartment',
//                                           fieldName: 'bound_x2',
//                                           filter: {'space_id': null},
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             icon: const Icon(Icons.add_rounded),
//                           ),
//                           SizedBox(width: blockPadding),
//                           IconButton.filled(
//                             onPressed: switch (_selectedCargo) {
//                               // ignore: unused_local_variable
//                               Cargo(:final int id) => () async {
//                                   switch (await PgStoresOthers(
//                                     apiAddress: widget._apiAddress,
//                                     dbName: widget._dbName,
//                                     authToken: widget._authToken,
//                                   ).remove(_selectedCargo!)) {
//                                     case Ok():
//                                       _toggleCargo(null);
//                                       widget._fireRefreshEvent();
//                                     case Err(:final error):
//                                       const Log('Remove cargo').error(error);
//                                   }
//                                 },
//                               _ => null,
//                             },
//                             icon: const Icon(Icons.remove_rounded),
//                           ),
//                           SizedBox(width: blockPadding),
//                           IconButton.filled(
//                             icon: const Icon(Icons.edit_rounded),
//                             onPressed: switch (_selectedCargo) {
//                               Cargo(
//                                 :final int id,
//                                 :final name,
//                                 :final weight,
//                                 :final lcg,
//                                 :final tcg,
//                                 :final vcg,
//                                 :final x1,
//                                 :final x2,
//                               ) =>
//                                 () => showDialog(
//                                       barrierDismissible: false,
//                                       context: context,
//                                       builder: (context) => AlertDialog(
//                                         content: SizedBox(
//                                           height: 500.0,
//                                           width: 500.0,
//                                           child: CargoParametersForm(
//                                             onClose: () {
//                                               Navigator.of(context).pop();
//                                               _toggleCargo(null);
//                                               widget._fireRefreshEvent();
//                                             },
//                                             onSave: (fieldDatas) async {
//                                               try {
//                                                 final fieldsPersisted =
//                                                     await Future.wait(
//                                                   fieldDatas.map(
//                                                     (field) async {
//                                                       switch (
//                                                           await field.save()) {
//                                                         case Ok(:final value):
//                                                           return field.copyWith(
//                                                             initialValue: value,
//                                                           );
//                                                         case Err(:final error):
//                                                           Log('$runtimeType | _persistAll')
//                                                               .error(error);
//                                                           throw Err<
//                                                               List<FieldData>,
//                                                               Failure>(
//                                                             error,
//                                                           );
//                                                       }
//                                                     },
//                                                   ),
//                                                 );
//                                                 return Ok(fieldsPersisted);
//                                               } on Err<List<FieldData>,
//                                                   Failure> catch (err) {
//                                                 return err;
//                                               }
//                                             },
//                                             fieldData: [
//                                               FieldData(
//                                                 id: 'name',
//                                                 label:
//                                                     const Localized('Name').v,
//                                                 unit: '',
//                                                 type: FieldType.string,
//                                                 initialValue: '$name',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'name',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                               FieldData(
//                                                 id: 'mass',
//                                                 label:
//                                                     const Localized('Mass').v,
//                                                 unit: const Localized('t').v,
//                                                 type: FieldType.real,
//                                                 initialValue: '$weight',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'mass',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                               FieldData(
//                                                 id: 'mass_shift_x',
//                                                 label: const Localized('LCG').v,
//                                                 unit: const Localized('m').v,
//                                                 type: FieldType.real,
//                                                 initialValue: '$lcg',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'mass_shift_x',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                               FieldData(
//                                                 id: 'mass_shift_y',
//                                                 label: const Localized('TCG').v,
//                                                 unit: const Localized('m').v,
//                                                 type: FieldType.real,
//                                                 initialValue: '$tcg',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'mass_shift_y',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                               FieldData(
//                                                 id: 'mass_shift_z',
//                                                 label: const Localized('VCG').v,
//                                                 unit: const Localized('m').v,
//                                                 type: FieldType.real,
//                                                 initialValue: '$vcg',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'mass_shift_z',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                               FieldData(
//                                                 id: 'bound_x1',
//                                                 label: const Localized('X1').v,
//                                                 unit: const Localized('m').v,
//                                                 type: FieldType.real,
//                                                 initialValue: '$x1',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'bound_x1',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                               FieldData(
//                                                 id: 'bound_x2',
//                                                 label: const Localized('X2').v,
//                                                 unit: const Localized('m').v,
//                                                 type: FieldType.real,
//                                                 initialValue: '$x2',
//                                                 record: FieldRecord<String>(
//                                                   toValue: (text) => text,
//                                                   dbName: widget._dbName,
//                                                   apiAddress:
//                                                       widget._apiAddress,
//                                                   authToken: widget._authToken,
//                                                   tableName: 'compartment',
//                                                   fieldName: 'bound_x2',
//                                                   filter: {'space_id': id},
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                               _ => null,
//                             },
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: blockPadding),
//                       Expanded(
//                         child: CargoTable(
//                           selected: _selectedCargo,
//                           onRowTap: _toggleCargo,
//                           columns: [
//                             CargoColumn<String>(
//                               type: 'text',
//                               key: 'type',
//                               name: '',
//                               defaultValue: 'other',
//                               extractValue: (cargo) => cargo.type.label,
//                               parseValue: (text) => CargoType.from(text).key,
//                               copyRowWith: (cargo, value) => JsonCargo(
//                                 json: cargo.asMap()
//                                   ..['type'] = CargoType.from(value).key,
//                               ),
//                               buildCell: (cargo) {
//                                 return Tooltip(
//                                   message: Localized(cargo.type.label).v,
//                                   child: Container(
//                                     margin: const EdgeInsets.symmetric(
//                                       vertical: 2.0,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: cargo.type.color,
//                                       borderRadius: const BorderRadius.all(
//                                         Radius.circular(2.0),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               width: 28.0,
//                             ),
//                             CargoColumn<String?>(
//                               width: 350.0,
//                               key: 'name',
//                               type: 'text',
//                               name: const Localized('Name').v,
//                               isEditable: true,
//                               isResizable: true,
//                               extractValue: (cargo) => cargo.name,
//                               parseValue: (value) => value,
//                               copyRowWith: (cargo, value) => JsonCargo(
//                                 json: cargo.asMap()..['name'] = value,
//                               ),
//                               buildRecord: (cargo) => FieldRecord<String>(
//                                 fieldName: 'name',
//                                 tableName: 'compartment',
//                                 toValue: (value) => value,
//                                 apiAddress: widget._apiAddress,
//                                 dbName: widget._dbName,
//                                 authToken: widget._authToken,
//                                 filter: {'space_id': cargo.id},
//                               ),
//                               defaultValue: '—',
//                               validator: const Validator(cases: [
//                                 MinLengthValidationCase(1),
//                               ]),
//                             ),
//                             CargoColumn<double>(
//                               headerAlignment: Alignment.centerRight,
//                               cellAlignment: Alignment.centerRight,
//                               width: 150.0,
//                               key: 'weight',
//                               type: 'real',
//                               name:
//                                   '${const Localized('Mass').v} [${const Localized('t').v}]',
//                               isResizable: true,
//                               isEditable: true,
//                               buildRecord: (cargo) => FieldRecord<String>(
//                                 fieldName: 'mass',
//                                 tableName: 'compartment',
//                                 toValue: (value) => value,
//                                 apiAddress: widget._apiAddress,
//                                 dbName: widget._dbName,
//                                 authToken: widget._authToken,
//                                 filter: {'space_id': cargo.id},
//                               ),
//                               defaultValue: '—',
//                               parseValue: (value) =>
//                                   _formatDouble(
//                                     double.parse(value),
//                                     fractionDigits: 1,
//                                   ) ??
//                                   0.0,
//                               extractValue: (cargo) =>
//                                   _formatDouble(
//                                     cargo.weight,
//                                     fractionDigits: 1,
//                                   ) ??
//                                   0.0,
//                               copyRowWith: (cargo, value) => JsonCargo(
//                                 json: cargo.asMap()..['weight'] = value,
//                               ),
//                               validator: const Validator(cases: [
//                                 MinLengthValidationCase(1),
//                                 RealValidationCase(),
//                               ]),
//                             ),
//                             CargoColumn<double>(
//                               headerAlignment: Alignment.centerRight,
//                               cellAlignment: Alignment.centerRight,
//                               grow: 1,
//                               key: 'lcg',
//                               type: 'real',
//                               name:
//                                   '${const Localized('LCG').v} [${const Localized('m').v}]',
//                               isEditable: false,
//                               buildRecord: (cargo) => FieldRecord<String>(
//                                 fieldName: 'lcg',
//                                 tableName: 'compartment',
//                                 toValue: (value) => value,
//                                 apiAddress: widget._apiAddress,
//                                 dbName: widget._dbName,
//                                 authToken: widget._authToken,
//                                 filter: {'space_id': cargo.id},
//                               ),
//                               defaultValue: '—',
//                               extractValue: (cargo) =>
//                                   _formatDouble(
//                                     cargo.lcg,
//                                     fractionDigits: 2,
//                                   ) ??
//                                   0.0,
//                               parseValue: (text) =>
//                                   _formatDouble(
//                                     double.tryParse(text),
//                                     fractionDigits: 2,
//                                   ) ??
//                                   0.0,
//                               copyRowWith: (cargo, value) => JsonCargo(
//                                 json: cargo.asMap()..['lcg'] = value,
//                               ),
//                             ),
//                             CargoColumn<double>(
//                               headerAlignment: Alignment.centerRight,
//                               cellAlignment: Alignment.centerRight,
//                               grow: 1,
//                               key: 'tcg',
//                               type: 'real',
//                               name:
//                                   '${const Localized('TCG').v} [${const Localized('m').v}]',
//                               isEditable: false,
//                               buildRecord: (cargo) => FieldRecord<String>(
//                                 fieldName: 'tcg',
//                                 tableName: 'compartment',
//                                 toValue: (value) => value,
//                                 apiAddress: widget._apiAddress,
//                                 dbName: widget._dbName,
//                                 authToken: widget._authToken,
//                                 filter: {'space_id': cargo.id},
//                               ),
//                               defaultValue: '—',
//                               extractValue: (cargo) =>
//                                   _formatDouble(
//                                     cargo.tcg,
//                                     fractionDigits: 2,
//                                   ) ??
//                                   0.0,
//                               parseValue: (text) =>
//                                   _formatDouble(
//                                     double.tryParse(text),
//                                     fractionDigits: 2,
//                                   ) ??
//                                   0.0,
//                               copyRowWith: (cargo, value) => JsonCargo(
//                                 json: cargo.asMap()..['tcg'] = value,
//                               ),
//                             ),
//                             CargoColumn<double>(
//                               headerAlignment: Alignment.centerRight,
//                               cellAlignment: Alignment.centerRight,
//                               grow: 1,
//                               key: 'vcg',
//                               type: 'real',
//                               name:
//                                   '${const Localized('VCG').v} [${const Localized('m').v}]',
//                               isEditable: false,
//                               buildRecord: (cargo) => FieldRecord<String>(
//                                 fieldName: 'vcg',
//                                 tableName: 'compartment',
//                                 toValue: (value) => value,
//                                 apiAddress: widget._apiAddress,
//                                 dbName: widget._dbName,
//                                 authToken: widget._authToken,
//                                 filter: {'space_id': cargo.id},
//                               ),
//                               defaultValue: '—',
//                               extractValue: (cargo) =>
//                                   _formatDouble(
//                                     cargo.vcg,
//                                     fractionDigits: 2,
//                                   ) ??
//                                   0.0,
//                               parseValue: (text) =>
//                                   _formatDouble(
//                                     double.tryParse(text),
//                                     fractionDigits: 2,
//                                   ) ??
//                                   0.0,
//                               copyRowWith: (cargo, value) => JsonCargo(
//                                 json: cargo.asMap()..['vcg'] = value,
//                               ),
//                             ),
//                           ],
//                           cargos: cargos,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   double? _formatDouble(double? value, {int fractionDigits = 1}) =>
//       ((value ?? 0.0) * pow(10, fractionDigits)).round() /
//       pow(10, fractionDigits);
// }
