import 'package:flutter/foundation.dart';
import 'package:sss_computing_client/core/models/directory/directory_info.dart';
import 'package:sss_computing_client/core/widgets/accordion/accordion_item.dart';

/// A builder for creating [AccordionItem]s
abstract interface class AccordionItems<T, A> {
  /// How deep to go into subdirectories
  int get deep;

  /// List of items
  List<T> get items;

  /// Creates [AccordionItem]s
  List<AccordionItem<A>> build();

  @protected
  AccordionItem<A> createFrom(T item, {int parents = 0});
}

/// Typedef for a list of [AccordionItem] with [List<String>]
typedef AssetsAccordionsList = List<AccordionItem<List<String>>>;

/// Creates [AccordionItem]s from [AssetsDirectoryInfo]s
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
    List<String>? data,
  }) {
    final includeChildren = parents < deep;
    data ??= item.allAssets;

    var children = switch (includeChildren) {
      false => <AccordionItem<List<String>>>[],
      true => item.subs
          .map(
            (e) => createFrom(e, parents: parents + 1, data: data),
          )
          .toList(),
    };

    if (children.isEmpty && parents == 0) {
      children = [
        AccordionItem<List<String>>(
          title: item.title,
          data: data,
          localisationError: item.titleError,
        ),
      ];
    }

    return AccordionItem<List<String>>(
      localisationError: item.titleError,
      title: item.title,
      data: data,
      children: children,
    );
  }
}
