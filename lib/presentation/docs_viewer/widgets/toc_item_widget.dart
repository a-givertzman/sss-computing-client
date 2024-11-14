import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// Table of contents item widget
class TocItemWidget extends StatefulWidget {
  const TocItemWidget(
      {super.key,
      required this.data,
      required this.tocController,
      required this.currentToc,
      required this.onSelected});

  /// Table of contents item data
  final TocItemBuilderData data;

  /// TOC controller
  final TocController tocController;

  /// Currently selected TOC
  final Toc currentToc;

  /// Callback when TOC item is selected
  final ValueChanged<Toc> onSelected;

  @override
  State<TocItemWidget> createState() => _TocItemWidgetState();
}

class _TocItemWidgetState extends State<TocItemWidget> {
  final AutoScrollController controller = AutoScrollController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final isCurrentToc = widget.currentToc.selfIndex == widget.data.index;
      final node = widget.currentToc.node.copy(
        headingConfig: _TocHeadingConfig(
          TextStyle(
            fontSize: 16,
            color: isCurrentToc ? Colors.blue : null,
            fontWeight: isCurrentToc ? FontWeight.bold : FontWeight.normal,
          ),
          widget.currentToc.node.headingConfig.tag,
        ),
      );
      final child = ListTile(
        contentPadding: EdgeInsets.zero,
        title: Container(
          margin: EdgeInsets.only(
              left: 20.0 * (headingTag2Level[node.headingConfig.tag] ?? 0)),
          child: ProxyRichText(node.build()),
        ),
        onTap: () {
          widget.tocController.jumpToIndex(widget.currentToc.widgetIndex);
        },
      );
      return wrapByAutoScroll(widget.data.index, child, controller);
    });
  }
}

class _TocHeadingConfig extends HeadingConfig {
  @override
  final TextStyle style;
  @override
  final String tag;

  _TocHeadingConfig(this.style, this.tag);
}
