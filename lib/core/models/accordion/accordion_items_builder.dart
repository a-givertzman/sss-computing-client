import 'package:flutter/foundation.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';
import 'package:sss_computing_client/core/widgets/accordion/accordion_item.dart';

///
abstract interface class AccordionItems<T, A> {
  ///
  int get deep;
  List<T> get items;
  List<AccordionItem<A>> build();
  @protected
  AccordionItem<A> createFrom(T item, {int parents = 0});
}

class AssetsAccordions
    implements AccordionItems<AssetsDirectoryInfo, List<String>> {
  @override
  final List<AssetsDirectoryInfo> items;

  @override
  final int deep;

  AssetsAccordions(this.items, {this.deep = 1});

  @override
  List<AccordionItem<List<String>>> build() {
    return items.map(createFrom).toList();
  }

  @override
  AccordionItem<List<String>> createFrom(
    AssetsDirectoryInfo item, {
    int parents = 0,
  }) {
    final includeChildren = parents < deep;
    var children = switch (includeChildren) {
      false => <AccordionItem<List<String>>>[],
      true =>
        item.subs.map((e) => createFrom(e, parents: parents + 1)).toList(),
    };

    if (children.isEmpty && parents == 0) {
      children = [
        AccordionItem<List<String>>(
          title: item.name,
          data: item.allAssets,
        ),
      ];
    }

    return AccordionItem<List<String>>(
      title: item.name,
      data: item.allAssets,
      children: children,
    );
  }
}
