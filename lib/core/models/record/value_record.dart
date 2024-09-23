import 'package:hmi_core/hmi_core_result_new.dart';
///
/// Record with value stored in some source.
abstract interface class ValueRecord<T> {
  ///
  /// Returns [Result] with value of record.
  Future<ResultF<T>> fetch();
  ///
  /// Writes a new value to record
  /// and returns [Result] with written value.
  ///
  /// [value] – value that will be written to record.
  Future<ResultF<T>> persist(String value);
}
