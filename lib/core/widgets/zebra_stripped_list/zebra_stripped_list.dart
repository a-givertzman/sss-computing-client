import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/scrollable_builder_widget.dart';

/// A widget that displays a list of items with alternating stripes
class ZebraStripedListView<T> extends StatelessWidget {
  final List<T> _items;
  final Widget Function(BuildContext context, T item, bool stripped) _buildItem;
  final ScrollController _scrollController;
  final double _scrollbarThickness;

  ///
  const ZebraStripedListView({
    super.key,
    required List<T> items,
    required Widget Function(BuildContext, T, bool stripped) buildItem,
    required ScrollController scrollController,
    double scrollbarThickness = 8.0,
  })  : _items = items,
        _buildItem = buildItem,
        _scrollController = scrollController,
        _scrollbarThickness = scrollbarThickness;
  //
  @override
  Widget build(BuildContext context) {
    final itemPadding = const Setting('padding').toDouble;
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: _scrollbarThickness,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ScrollableBuilderWidget(
          controller: _scrollController,
          builder: (context, isScrollable) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final stripped = index.isEven;
                return Container(
                  padding: EdgeInsets.all(itemPadding),
                  decoration: BoxDecoration(
                    color: stripped
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.only(
                      right: isScrollable ? _scrollbarThickness : 0.0,
                    ),
                    child: Builder(
                      builder: (context) =>
                          _buildItem(context, _items[index], stripped),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
