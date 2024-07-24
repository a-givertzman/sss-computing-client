import 'package:hmi_core/hmi_core_result_new.dart';
///
abstract interface class ValueRecord<T> {
  ///
  Future<ResultF<T>> fetch();
  ///
  Future<ResultF<T>> persist(String value);
}
