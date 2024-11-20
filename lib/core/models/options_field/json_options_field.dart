import 'package:sss_computing_client/core/models/options_field/options_field.dart';
///
/// [OptionsField] with text values that parses itself from json.
class JsonOptionsField implements OptionsField<String> {
  final List<Map<String, dynamic>> _json;
  ///
  /// Creates [OptionsField] with text values from passed [json].
  const JsonOptionsField({
    required List<Map<String, dynamic>> json,
  }) : _json = json;
  ///
  /// Creates [OptionsField] with text values from passed database [rowField].
  ///
  /// [rowField] should have the following format with only one item with `"isActive": true`:
  ///
  /// ```json
  /// [
  ///   {
  ///     "id": 1, // int
  ///     "value": "value1", // String
  ///     "isActive": true // bool
  ///   },
  ///   {
  ///     "id": 2, // int
  ///     "value": "value2", // String
  ///     "isActive": false // bool
  ///   }, ...
  /// ]
  /// ```
  ///
  /// Throws [ArgumentError] if format is not valid.
  factory JsonOptionsField.fromRowField(List<dynamic> rowField) {
    final options = rowField
        .map((opt) => {
              'id': opt['id'] as int,
              'value': opt['value'] as String,
              'isActive': opt['isActive'] as bool,
            })
        .toList();
    if (options.isEmpty ||
        options.where((opt) => opt['isActive'] as bool).length != 1) {
      throw ArgumentError(
        'JsonOptionsField.fromRowField: exactly one active option must be present',
      );
    }
    if (options.map((opt) => opt['id'] as int).toSet().length !=
        options.length) {
      throw ArgumentError(
        'JsonOptionsField.fromRowField: all option ids must be unique',
      );
    }
    return JsonOptionsField(json: options);
  }
  //
  @override
  List<FieldOption<String>> get options =>
      _json.map((opt) => _parseOption(opt).entry).toList();
  //
  @override
  FieldOption<String> get active => _json
      .map((opt) => _parseOption(opt))
      .firstWhere((opt) => opt.isActive)
      .entry;
  //
  @override
  List<Map<String, dynamic>> toJson() => List.from(
        _json.map(
          (opt) => Map.from(opt),
        ),
      );
  //
  ({FieldOption<String> entry, bool isActive}) _parseOption(
    Map<String, dynamic> option,
  ) =>
      (
        entry: (id: option['id'] as int, value: option['value'] as String),
        isActive: option['isActive'] as bool,
      );
}
