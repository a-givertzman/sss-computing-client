import '../widgets/accordion/accordion_item.dart';

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

  addAllIfAbsent(List<T> other) {
    for (var element in other) {
      if (!contains(element)) {
        add(element);
      }
    }
  }
}

extension AccordionListExt<T> on List<AccordionItem<T>> {
  AccordionItem<T>? findByPath(String path) {
    return firstWhereOrNull((e) {
      final data = e.data;
      return switch (data) {
        List() => data.contains(path),
        _ => false,
      };
    });
  }

  bool get anyOpen => any((e) => e.isOpen);
}
