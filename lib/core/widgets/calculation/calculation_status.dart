import 'package:flutter/material.dart';
///
/// Model for controlling status of calculation
/// and notifying widgets when it changes.
class CalculationStatus extends ChangeNotifier {
  bool _isInProcess = false;
  ///
  /// Indicates caculation status.
  /// Returns true if calculation is in progress.
  /// Returns false if calculation is completed
  /// or has not yet been performed.
  bool get isInProcess => _isInProcess;
  ///
  /// Changes calculation status to "in progress".
  /// If calculation is already in progress, do nothing.
  void start() {
    if (_isInProcess) return;
    _isInProcess = true;
    notifyListeners();
  }
  ///
  /// Changes calculation status to "completed".
  /// If calculation is already completed, do nothing.
  void stop() {
    if (!_isInProcess) return;
    _isInProcess = false;
    notifyListeners();
  }
}
