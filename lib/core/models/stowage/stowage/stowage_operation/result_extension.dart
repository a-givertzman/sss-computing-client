import 'package:hmi_core/hmi_core_result_new.dart';
///
extension ResultFExtension<V> on ResultF<V> {
  ///
  ResultF<N> bind<N>(ResultF<N> Function(V value) f) {
    return switch (this) {
      Ok(:final value) => f(value),
      Err(:final error) => Err(error),
    };
  }
  ///
  ResultF<N> map<N>(N Function(V value) f) {
    return switch (this) {
      Ok(:final value) => Ok(f(value)),
      Err(:final error) => Err(error),
    };
  }
  ///
  ResultF<V> log() {
    switch (this) {
      case Ok(:final value):
        print(value);
      case Err(:final error):
        print(error.message);
    }
    return this;
  }
}
