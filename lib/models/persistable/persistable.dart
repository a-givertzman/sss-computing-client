import 'package:hmi_core/hmi_core_result_new.dart';

abstract interface class Persistable<T> {
  Future<ResultF<void>> persist(T value);
  Future<ResultF<T>> fetch();
}
