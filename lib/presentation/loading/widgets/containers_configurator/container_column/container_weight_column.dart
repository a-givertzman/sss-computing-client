import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage_plan/container/json_freight_container.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// [TableColumn] for [FreightContainer] weight.
class ContainerWeightColumn implements TableColumn<FreightContainer, double> {
  ///
  /// Creates [TableColumn] for [FreightContainer] weight.
  const ContainerWeightColumn();
  //
  @override
  String get key => 'weight';
  //
  @override
  FieldType get type => FieldType.real;
  //
  @override
  String get name => '${const Localized('Mass').v} [${const Localized('t').v}]';
  //
  @override
  String get nullValue => '—';
  //
  @override
  double get defaultValue => 0.0;
  //
  @override
  Alignment get headerAlignment => Alignment.centerRight;
  //
  @override
  Alignment get cellAlignment => Alignment.centerRight;
  //
  @override
  double? get grow => null;
  //
  @override
  double? get width => 150.0;
  //
  @override
  bool get useDefaultEditing => true;
  //
  @override
  bool get isResizable => true;
  //
  @override
  Validator? get validator => const Validator(
        cases: [
          MinLengthValidationCase(1),
          RealValidationCase(),
        ],
      );
  //
  @override
  double extractValue(FreightContainer container) => container.grossWeight;
  //
  @override
  double parseToValue(String text) => double.tryParse(text) ?? defaultValue;
  //
  @override
  String parseToString(double? value) {
    return (value ?? 0.0).toStringAsFixed(1);
  }
  //
  @override
  FreightContainer copyRowWith(FreightContainer container, String text) {
    final newContainerData = container.asMap()
      ..['grossWeight'] = parseToValue(text);
    return JsonFreightContainer.fromRow(newContainerData);
  }
  //
  @override
  ValueRecord<double>? buildRecord(
    FreightContainer container,
    double Function(String text) toValue,
  ) =>
      null;
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
