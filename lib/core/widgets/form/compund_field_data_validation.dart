import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/field/field_data.dart';
import 'package:sss_computing_client/core/validation/text_editing_controller_validation_case.dart';
///
class CompoundFieldDataValidation {
  final String _ownId;
  final String _otherId;
  final ResultF<void> Function(
    String ownValue,
    String otherValue,
  ) _validateValues;
  ///
  const CompoundFieldDataValidation({
    required String ownId,
    required String otherId,
    required ResultF<void> Function(String, String) validateValues,
  })  : _ownId = ownId,
        _otherId = otherId,
        _validateValues = validateValues;
  //
  String get ownId => _ownId;
  //
  String get otherId => _otherId;
  ///
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
