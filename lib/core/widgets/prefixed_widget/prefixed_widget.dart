import 'package:flutter/material.dart';

/// Widget that prefixes widget with an [icon].
class IconPrefixedWidget extends StatelessWidget {
  const IconPrefixedWidget({
    super.key,
    required this.builder,
    this.icon = Icons.edit,
    this.showDivider = false,
  });

  /// Build the prefixed widget
  final WidgetBuilder builder;

  /// The [icon] to be prefixed
  final IconData icon;

  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: builder(context)),
        if (showDivider)
           Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 18.0,
            child: const VerticalDivider(),
          ),
        Icon(
          icon,
          size: 16.0,
        ),
      ],
    );
  }
}
