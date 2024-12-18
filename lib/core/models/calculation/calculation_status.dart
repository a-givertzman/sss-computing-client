import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
/// Model for controlling status of calculation
/// and notifying widgets when it changes.
class CalculationStatus extends ChangeNotifier {
  final _refreshController = StreamController<DsDataPoint<bool>>.broadcast();
  bool _isInProcess = false;
  String? _message;
  String? _errorMessage;
  //
  @override
  void dispose() {
    _refreshController.close();
    super.dispose();
  }
  ///
  /// Indicates calculation status.
  /// Returns `true` if calculation is in progress.
  /// Returns `false` if calculation is completed
  /// or has not yet been performed.
  bool get isInProcess => _isInProcess;
  ///
  /// Returns message for successfully completed calculations.
  String? get message => _message;
  ///
  /// Returns error message for failed calculations.
  String? get errorMessage => _errorMessage;
  ///
  /// Changes calculation status to "in progress".
  /// If calculation is already in progress, do nothing.
  void start() {
    if (_isInProcess) return;
    _isInProcess = true;
    notifyListeners();
  }
  ///
  /// Changes calculation status to "completed"
  /// and change values for [message] and [errorMessage]
  /// depending on passed parameters values.
  /// If calculation is already completed, do nothing.
  void complete({String? message, String? errorMessage}) {
    if (!_isInProcess) return;
    _message = message;
    _errorMessage = errorMessage;
    _isInProcess = false;
    notifyListeners();
  }
  ///
  Stream<DsDataPoint<bool>> get refreshStream => _refreshController.stream;
  ///
  void fireRefreshEvent() => _refreshController.add(DsDataPoint(
        type: DsDataType.bool,
        name: DsPointName('/refresh'),
        value: true,
        status: DsStatus.ok,
        timestamp: '',
        cot: DsCot.req,
      ));
}
