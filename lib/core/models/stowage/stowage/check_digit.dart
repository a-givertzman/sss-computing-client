import 'dart:math';
import 'package:collection/collection.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/core/models/stowage/stowage/stowage_operation/extensions/extension_transform.dart';
///
class CheckDigit {
  ///
  /// Length of valid container code.
  static const int _validContainerCodeLength = 10;
  ///
  static const Map<String, int> _alphabetValues = {
    "A": 10, "B": 12, "C": 13, "D": 14, "E": 15, "F": 16, //
    "G": 17, "H": 18, "I": 19, "J": 20, "K": 21, //
    "L": 23, "M": 24, "N": 25, "O": 26, "P": 27, //
    "Q": 28, "R": 29, "S": 30, "T": 31, "U": 32, //
    "V": 34, "W": 35, "X": 36, "Y": 37, "Z": 38, //
  };
  ///
  final String _containerCode;
  ///
  const CheckDigit.fromContainerCode(String containerCode)
      : _containerCode = containerCode;
  ///
  ResultF<int> value() {
    final checkDigit = _codeToNumbers()
        .map((numbers) => numbers.mapIndexed(
              (index, number) => (number * pow(2, index)).toInt(),
            ))
        .map((multipliedNumbers) => multipliedNumbers.sum)
        .map((sum) => sum % 11)
        .map((remainder) => remainder == 10 ? 0 : remainder);
    return checkDigit;
  }
  ///
  ResultF<List<int>> _codeToNumbers() {
    final numbers = _containerCode
        .split('')
        .map(
          (char) => _alphabetValues[char.toUpperCase()] ?? int.tryParse(char),
        )
        .whereType<int>()
        .toList();
    if (numbers.length != _validContainerCodeLength) {
      return Err(Failure(
        message: 'Invalid container code',
        stackTrace: StackTrace.current,
      ));
    }
    return Ok(numbers);
  }
}
