///
/// AccordionItem class represents an item in an accordion.
final class AccordionItem<T> {
  /// Item title
  final String title;
  ///
  /// Item open state
  bool _isOpen;
  ///
  /// Item data
  final T? data;
  /// Item children, sub-items of the current item
  final List<AccordionItem<T>> children;
  /// - `True` if the `title` was not correctly localised.
  /// - `False` if the `title` was correctly localised.
  final bool localisationError;
  //
  AccordionItem({
    required this.title,
    this.data,
    bool isOpen = false,
    this.localisationError = false,
    this.children = const [],
  }) : _isOpen = isOpen;
  ///
  /// Item open state.
  bool get isOpen {
    return _isOpen;
  }
  ///
  /// Item has children.
  bool get hasChildren => children.isNotEmpty;
  /// Update item open state.
  set setOpen(bool value) {
    _isOpen = value;
  }
  ///
  /// Check if the item is equal to another item.
  bool isEqualTo(AccordionItem? other) =>
      title == other?.title &&
      isOpen == other?.isOpen &&
      children == other?.children;
  //
  @override
  String toString() {
    return 'AccordionItem(title: $title, isOpen: $isOpen, children: $children)';
  }
}
