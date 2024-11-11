import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
/// Object representing curve model as set of points through which it passes.
abstract interface class Curve {
  ///
  /// Returns [Result] containing all points of [Curve].
  FutureOr<Result<List<Offset>, Failure<String>>> points();
}
