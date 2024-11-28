import 'package:sss_computing_client/core/extensions/lists.dart';
import 'package:sss_computing_client/core/widgets/accordion/accordion_item.dart';

abstract interface class AccordionModel<T> {
  /// List of accordion items for the [AccordionWidget]
  List<AccordionItem<T>> get items;

  ///
  onItemSelected(AccordionItem<T> item);

  /// The current [AccordionItem]
  /// Initialized in the [create] method
  /// If the [currentPath] is null or does not exist, the first item will be used
  AccordionItem<T>? get currentItem;
}

class MarkdownAccordionModel implements AccordionModel<List<String>> {
  @override
  final List<AccordionItem<List<String>>> items;

  AccordionItem<List<String>>? _currentItem;

  ///
  MarkdownAccordionModel(this.items);

  /// Assets paths
  List<String> get currentAssets => currentItem?.data ?? [];

  @override
  AccordionItem<List<String>>? get currentItem => _currentItem;

  @override
  onItemSelected(AccordionItem<List<String>> item) {
    if (item.isEqualTo(_currentItem)) {
      return;
    }
    final dir = (item.data);
    if (dir != null) {
      item.setOpen = !item.isOpen;
      _currentItem = item;
    }
  }

  initialiseCurrentItem({String? currentAsset}) {
    if (currentAsset != null) {
      _currentItem = items.findByPath(currentAsset);
      _currentItem?.setOpen = true;
    }
    if (_currentItem != null) return;
    final item = items.firstOrNull;
    final subtitle = item?.children.firstOrNull;
    if (item != null && subtitle != null) {
      item.setOpen = true;
      onItemSelected(subtitle);
    }
  }
}
