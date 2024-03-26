import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

/// Builds a widget tree that can be depend on the scrollable
/// widget (e.g., [ListView], [GridView] or [SingleChildScrollView]) state.
///
/// Provide information about ability to scroll content.
class ScrollableBuilderWiddget extends StatefulWidget {
  final Widget Function(BuildContext context, bool isScrollEnabled) builder;
  final ScrollController controller;

  /// Creates a widget that provides information about ability to scroll
  /// content of widget with passed [ScrollController].
  ///
  /// * [builder] - called to construct widget tree;
  /// * [controller] - [ScrollController] of tracked scrollable widget;
  ///
  /// To correct work, scrollable widget must be a direct child of
  /// [ScrollableBuilderWiddget]
  const ScrollableBuilderWiddget({
    super.key,
    required this.builder,
    required this.controller,
  });
  @override
  State<ScrollableBuilderWiddget> createState() =>
      _ScrollableBuilderWiddgetState();
}

class _ScrollableBuilderWiddgetState extends State<ScrollableBuilderWiddget> {
  bool _isScrollEnabled = false;
  BoxConstraints? _layoutConstraints;

  void _checkIsScrollEnabled() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final position = widget.controller.position;
        final isScrollEnabled =
            position.maxScrollExtent != 0.0 || position.minScrollExtent != 0.0;
        Log('$runtimeType | position.minScrollExtent')
            .warning('${position.minScrollExtent}');
        Log('$runtimeType | position.maxScrollExtent')
            .warning('${position.maxScrollExtent}');
        Log('$runtimeType | isScrollEnabled').debug('$_isScrollEnabled');
        if (_isScrollEnabled == isScrollEnabled) return;
        setState(() {
          Log('$runtimeType | isScrollEnabled is set to')
              .warning('$isScrollEnabled');
          _isScrollEnabled = isScrollEnabled;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (_layoutConstraints != constraints) {
        _checkIsScrollEnabled();
        _layoutConstraints = constraints;
      }
      return Builder(
        builder: (context) => widget.builder(context, _isScrollEnabled),
      );
    });
  }
}
