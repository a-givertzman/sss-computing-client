///
/// Option for [OptionsField].
typedef FieldOption<T> = ({
  int id,
  T value,
});
///
/// Field with options for its value, where only one option is active at a time.
abstract interface class OptionsField<T> {
  ///
  /// Returns the list of available options as [FieldOption<T>]
  List<FieldOption<T>> get options;
  ///
  /// Returns currently active option as [FieldOption<T>]
  FieldOption<T> get active;
  ///
  /// Converts [OptionsField] to json.
  List<Map<String, dynamic>> toJson();
}
