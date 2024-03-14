import 'dart:async';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';

abstract interface class Cargos {
  Future<ResultF<List<Cargo>>> fetchAll();
}

class FakeCargos implements Cargos {
  @override
  Future<ResultF<List<Cargo>>> fetchAll() async {
    final cargos = List.generate(
      100,
      (index) => {
        'id': index,
        'name': 'CARGO-$index',
        'weight': 0.0,
        'lcg': 0.0,
        'vcg': 0.0,
        'tcg': 0.0,
        'leftSideX': 0.0,
        'rightSideX': 0.0,
      },
    ).map((json) => JsonCargo(json: json)).toList();
    // debugging
    await Future.delayed(const Duration(seconds: 1));
    return Ok(cargos);
    // debugging
    // return Err(Failure(
    //   message: 'Failed to fetch cargos',
    //   stackTrace: StackTrace.current,
    // ));
  }
}
