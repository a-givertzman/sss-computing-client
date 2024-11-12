import 'dart:math';
import 'package:collection/collection.dart';
import 'package:hmi_core/hmi_core.dart';
///
/// Object to calculate check digit of container code
/// in accordance with [ISO 6346](https://www.iso.org/standard/83558.html).
class FreightContainerCheckDigit {
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
  const FreightContainerCheckDigit.fromContainerCode(String containerCode)
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
