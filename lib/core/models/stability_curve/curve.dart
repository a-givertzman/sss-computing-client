import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart' hide Result;
import 'package:hmi_core/hmi_core_result_new.dart';
///
abstract interface class Curve {
  ///
  Future<Result<List<Offset>, Failure<String>>> fetch();
}
