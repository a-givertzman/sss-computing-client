///
enum FieldType {
  int,
  real,
  string,
  bool,
  date;
  ///
  const FieldType();
  ///
  factory FieldType.from(String value) {
    return switch (value) {
      "int" => FieldType.int,
      "real" => FieldType.real,
      "bool" => FieldType.bool,
      "date" => FieldType.date,
      _ => FieldType.string,
    };
  }
}
