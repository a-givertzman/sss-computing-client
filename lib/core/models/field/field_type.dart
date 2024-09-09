///
/// Enum of FieldData value types
enum FieldType {
  int,
  real,
  string,
  bool,
  date;
  //
  const FieldType();
  ///
  /// Create [FieldType] from it string representation
  factory FieldType.from(String value) {
    return switch (value) {
      'int' => FieldType.int,
      'real' => FieldType.real,
      'bool' => FieldType.bool,
      'date' => FieldType.date,
      _ => FieldType.string,
    };
  }
}
