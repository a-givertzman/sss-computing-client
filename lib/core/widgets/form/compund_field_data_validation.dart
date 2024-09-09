import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/validation/text_editing_controller_validation_case.dart';
///
/// Object providing [ValidationCase] that uses value of multiple [FieldData].
class CompoundFieldDataValidation {
  final String _ownId;
  final String _otherId;
  final ResultF<void> Function(
    String ownValue,
    String otherValue,
  ) _validateValues;
  ///
  /// Create object providing [ValidationCase]
  /// that uses value of multiple [FieldData].
  ///
  ///   `ownId` - id of field for which validation case is provided.
  ///   `otherId` - id of field used for comparison.
  ///   `validateValues` - used to determine validity of value,
  /// returns [Ok] if value is valid and [Err] otherwise.
  const CompoundFieldDataValidation({
    required String ownId,
    required String otherId,
    required ResultF<void> Function(
      String ownValue,
      String otherValue,
    ) validateValues,
  })  : _ownId = ownId,
        _otherId = otherId,
        _validateValues = validateValues;
  ///
  /// Returns id of field for which validation case is provided.
  String get ownId => _ownId;
  ///
  /// Returns id of field used for comparison.
  String get otherId => _otherId;
  ///
  /// Constructs and returns validation case based on multiple fields.
  ///
  ///   `fieldsData` - list containing fields used during validation.
  ValidationCase validationCase(List<FieldData> fieldsData) {
    return TECValidationCase(
      controller: fieldsData
          .firstWhere(
            (field) => field.id == _otherId,
          )
          .controller,
      compareValues: _validateValues,
    );
  }
}
