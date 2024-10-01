import 'package:vector_math/vector_math_64.dart';
///
/// Object for calculating common transformation matrix
/// for objects of scheme layout based on layout parameters.
class SchemeLayoutTransform {
  final double _minX;
  final double _maxX;
  final double _minY;
  final double _maxY;
  final double _scaleX;
  final double _scaleY;
  final double _shiftX;
  final double _shiftY;
  final bool _xReversed;
  final bool _yReversed;
  ///
  /// Creates object for calculating common transformation matrix
  /// for objects of scheme layout based on layout parameters.
  ///
  /// [minX], [maxX], [minY] and [maxY] – the range of values for coordinates
  /// value of scheme layout.
  ///
  /// [scaleX], [scaleY], [shiftX] and [shiftY] – scales and shifts
  /// from the top left corner of scheme layout.
  ///
  /// [xReversed] and [yReversed] – indicates that corresponding axis
  /// has opposite direction. By default axes are directed from top to bottom
  /// and left to right for the vertical and horizontal axis respectively.
  const SchemeLayoutTransform({
    required double minX,
    required double maxX,
    required double minY,
    required double maxY,
    double scaleX = 1.0,
    double scaleY = 1.0,
    double shiftX = 0.0,
    double shiftY = 0.0,
    bool xReversed = false,
    bool yReversed = false,
  })  : _minX = minX,
        _maxX = maxX,
        _minY = minY,
        _maxY = maxY,
        _scaleX = scaleX,
        _scaleY = scaleY,
        _shiftX = shiftX,
        _shiftY = shiftY,
        _xReversed = xReversed,
        _yReversed = yReversed;
  ///
  /// Returns common transformation matrix for objects of scheme
  /// layout based on passed parameters.
  Matrix4 transformationMatrix() {
    final scaleX = _xReversed ? -_scaleX : _scaleX;
    final scaleY = _yReversed ? -_scaleY : _scaleY;
    final shiftX = _shiftX - (_xReversed ? _maxX * scaleX : _minX * scaleX);
    final shiftY = _shiftY - (_yReversed ? _maxY * scaleY : _minY * scaleY);
    return Matrix4(
      scaleX, 0.0, 0.0, 0.0, //
      0.0, scaleY, 0.0, 0.0, //
      0.0, 0.0, 1.0, 0.0, //
      shiftX, shiftY, 0.0, 1.0, //
    );
  }
}
