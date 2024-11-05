import 'package:ext_rw/ext_rw.dart' hide FieldType;
import 'package:flutter/widgets.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/number_math_relation/greater_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/number_math_relation/less_than_or_equal_to.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/record/value_record.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/json_freight_container.dart';
import 'package:sss_computing_client/core/validation/number_math_relation_validation_case.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/table/table_column.dart';
///
/// TODO:
class ContainerWeightColumn implements TableColumn<FreightContainer, double> {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String _authToken;
  final bool _useDefaultEditing;
  ///
  const ContainerWeightColumn({
    required ApiAddress apiAddress,
    required String dbName,
    required String authToken,
    bool useDefaultEditing = false,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken,
        _useDefaultEditing = useDefaultEditing;
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
      ValidateValueRecord(
        toValue: toValue,
        record: FieldRecord<double>(
          apiAddress: _apiAddress,
          dbName: _dbName,
          authToken: _authToken,
          tableName: 'container',
          fieldName: 'gross_mass',
          filter: {'id': container.id},
          toValue: toValue,
        ),
        validator: Validator(cases: [
          NumberMathRelationValidationCase<double>(
            relation: const GreaterThanOrEqualTo(),
            toValue: toValue,
            secondValue: container.tareWeight,
            customMessage: '${const Localized(
              'Value must be greater than or equal to the tare weight',
            ).v} ${container.tareWeight} ${const Localized('t').v}',
          ),
          NumberMathRelationValidationCase<double>(
            relation: const LessThanOrEqualTo(),
            toValue: toValue,
            secondValue: container.maxGrossWeight,
            customMessage: '${const Localized(
              'Value must be less than or equal to the max gross weight',
            ).v} ${container.maxGrossWeight} ${const Localized('t').v}',
          ),
        ]),
      );
  //
  @override
  Widget? buildCell(context, cargo, updateValue) => null;
}
///
/// TODO
class ValidateValueRecord<T> implements ValueRecord<T> {
  final ValueRecord<T> record;
  final T Function(String text) toValue;
  final Validator validator;
  ///
  ValidateValueRecord({
    required this.record,
    required this.toValue,
    required this.validator,
  });
  //
  @override
  Future<ResultF<T>> fetch() => record.fetch();
  //
  @override
  Future<ResultF<T>> persist(String value) {
    final validateResult = validator.editFieldValidator(value);
    return switch (validateResult) {
      null => record.persist(value),
      String error => Future.value(Err(Failure(
          message: error,
          stackTrace: StackTrace.current,
        ))),
    };
  }
}
