///
class SchemeAxisTicksReal {
  final double _minValue;
  final double _maxValue;
  final double _valueInterval;
  final String? _valueLabel;
  final int _labelFractionDigits;
  ///
  const SchemeAxisTicksReal({
    required double minValue,
    required double maxValue,
    required double valueInterval,
    String? valueLabel,
    int labelFractionDigits = 0,
  })  : _minValue = minValue,
        _maxValue = maxValue,
        _valueInterval = valueInterval,
        _valueLabel = valueLabel,
        _labelFractionDigits = labelFractionDigits;
  ///
  /// Returns ticks as [List] of offsets and labels
  /// based on passed values range and interval.
  List<({double offset, String? label})> ticks() {
    final offset = _minValue.abs() % _valueInterval;
    return _getMultiples(_valueInterval, _maxValue - _minValue)
        .map(
          (multiple) => (
            offset: _minValue + offset + multiple,
            label:
                '${(_minValue + multiple + offset).toStringAsFixed(_labelFractionDigits)}${_valueLabel ?? ''}',
          ),
        )
        .toList();
  }
  ///
  /// Returns multiples of [divisor] less than or equal to [max]
  List<double> _getMultiples(double divisor, double max) {
    return List<double>.generate(
      max ~/ divisor + 1,
      (idx) => (idx * divisor),
    );
  }
}
