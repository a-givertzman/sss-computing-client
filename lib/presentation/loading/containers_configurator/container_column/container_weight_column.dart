import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/validation/number_math_relation_validation_case.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
class ContainerWeightColumn implements TableColumn<FreightContainer, double> {
  final bool _useDefaultEditing;
  ///
  const ContainerWeightColumn({
    bool useDefaultEditing = false,
  }) : _useDefaultEditing = useDefaultEditing;
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
  bool get useDefaultEditing => _useDefaultEditing;
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
  FreightContainer copyRowWith(FreightContainer container, String text) =>
      FreightContainer.fromSizeCode(
        container.type.isoName,
        id: container.id,
        serial: container.serial,
        tareWeight: container.tareWeight,
        cargoWeight: parseToValue(text) - container.tareWeight,
      );
  //
  @override
  ValueRecord<double>? buildRecord(
    FreightContainer container,
    double Function(String text) toValue,
  ) =>
      ValidateValueRecord(
        value: container.grossWeight,
        toValue: toValue,
        validationCase: NumberMathRelationValidationCase<double>(
          relation: const GreaterThanOrEqualTo(),
          toValue: toValue,
          secondValue: container.tareWeight,
          customMessage: Localized(
            'Gross weight must be greater than Tare weight: ${container.tareWeight} t',
          ).v,
        ),
      );
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
///
class ValidateValueRecord<T> implements ValueRecord<T> {
  T value;
  final T Function(String text) toValue;
  final ValidationCase validationCase;
  ValidateValueRecord({
    required this.value,
    required this.toValue,
    required this.validationCase,
  });
  @override
  Future<ResultF<T>> fetch() {
    return Future.value(Ok(value));
  }
  @override
  Future<ResultF<T>> persist(String value) {
    final validateResult = validationCase.isSatisfiedBy(value);
    return switch (validateResult) {
      Ok() => Future.value(Ok(toValue(value))),
      Err(:final error) => Future.value(Err(error)),
    };
  }
}
