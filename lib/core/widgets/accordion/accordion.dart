import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/accordion/accordion_item.dart';

/// The Accordion widget. It displays a list of [AccordionItem]s.
/// Each item has a title and a list of children.
class AccordionWidget<T> extends StatefulWidget {
  const AccordionWidget({
    super.key,
    required this.items,
    required this.onSelected,
    this.current,
  });
  final List<AccordionItem<T>> items;
  final AccordionItem<T>? current;
  final ValueChanged<AccordionItem<T>> onSelected;
  @override
  State<AccordionWidget<T>> createState() => _AccordionWidgetState<T>();
}

class _AccordionWidgetState<T> extends State<AccordionWidget<T>> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (_, index) {
        return _BuildItem<T>(
          selected: widget.current,
          item: widget.items[index],
          onSelected: (item) {
            widget.onSelected(item);
          },
          onOpened: (item) {
            setState(() {
              item.setOpen = !item.isOpen;
            });
          },
        );
      },
    );
  }
}

/// Builds an Accordion [item] widget and its children.
/// And handles all edge cases.
class _BuildItem<T> extends StatelessWidget {
  const _BuildItem({
    required this.item,
    required this.onSelected,
    this.parents = 0,
    required this.selected,
    required this.onOpened,
  });

  /// The item to build
  final AccordionItem<T> item;

  /// The currently selected item
  final AccordionItem? selected;

  /// The number of [parents]. Used to determine if the item is a parent
  /// or a child.
  final int parents;

  /// Called when an item is selected
  final ValueChanged<AccordionItem<T>> onSelected;

  /// Called when an item is opened
  final ValueChanged<AccordionItem<T>> onOpened;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    final isParent = parents == 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () {
            if (item.hasChildren) {
              onOpened(item);
            } else {
              onSelected(item);
            }
          },
          minVerticalPadding: 0.0,
          contentPadding: EdgeInsets.symmetric(
            horizontal: padding,
          ),
          title: Text(
            Localized(item.title).v,
            style: _buildTextStyle(isParent: isParent, theme: theme),
          ),
          leading: _buildLeading(isParent: isParent, padding: padding),
          trailing: _buildTrailing(isParent),
        ),
        if (item.isOpen)
          Padding(
            padding: EdgeInsets.only(
              left: parents * padding,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: item.children.length,
              itemBuilder: (_, index) {
                final child = item.children[index];
                return _BuildItem<T>(
                  item: child,
                  selected: selected,
                  onSelected: onSelected,
                  onOpened: onOpened,
                  parents: parents + 1,
                );
              },
            ),
          ),
      ],
    );
  }

  Widget? _buildLeading({required bool isParent, double? padding}) {
    return switch (isParent) {
      true => null,
      false => switch (item.hasChildren) {
          true => Icon(item.isOpen ? Icons.arrow_drop_down : Icons.arrow_right),
          false => SizedBox(
              width: padding,
            )
        },
    };
  }

  TextStyle? _buildTextStyle({
    required bool isParent,
    required ThemeData theme,
  }) {
    return switch (isParent) {
      true => theme.textTheme.titleMedium,
      false => theme.textTheme.bodySmall?.copyWith(
          color: item.isEqualTo(selected) ? theme.primaryColor : null,
        )
    };
  }

  Widget? _buildTrailing(bool isParent) {
    return switch (!isParent || !item.hasChildren) {
      true => null,
      false => Icon(
          item.isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        )
    };
  }
}
