import 'package:hmi_core/hmi_core_result_new.dart';
///
abstract interface class ValueRecord<T> {
  ///
  Future<ResultF<T>> fetch({required Map<String, dynamic> filter});
  ///
  Future<ResultF<String>> persist(
    String value, {
    required Map<String, dynamic> filter,
  });
}
