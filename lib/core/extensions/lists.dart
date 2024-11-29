/// List extensions
extension ListExt<T> on List<T> {
  /// Returns the first element that matches the given [test]
  T? firstWhereOrNull(bool Function(T element) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
