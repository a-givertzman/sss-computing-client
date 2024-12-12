/// AccordionItem class represents an item in an accordion.
final class AccordionItem<T> {
  /// Item title
  final String title;
  //
  bool _isOpen;
  //
  /// Item data
  final T? data;

  /// Item children, sub-items of the current item
  final List<AccordionItem<T>> children;

  /// - `True` if the `title` was not correctly localised.
  /// - `False` if the `title` was correctly localised.
  final bool localisationError;

  AccordionItem({
    required this.title,
    this.data,
    bool isOpen = false,
    this.localisationError = false,
    this.children = const [],
  }) : _isOpen = isOpen;

  bool get isOpen {
    return _isOpen;
  }

  bool get hasChildren => children.isNotEmpty;

  set setOpen(bool value) {
    _isOpen = value;
  }

  bool isEqualTo(AccordionItem? other) =>
      title == other?.title &&
      isOpen == other?.isOpen &&
      children == other?.children;

  @override
  String toString() {
    return 'AccordionItem(title: $title, isOpen: $isOpen, children: $children)';
  }
}
