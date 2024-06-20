import 'package:flutter/material.dart';
///
/// Builds a widget tree that can be depend on the scrollable
/// widget (e.g., [ListView], [GridView] or [SingleChildScrollView]) state.
///
/// Provide information about ability to scroll content.
class ScrollableBuilderWiddget extends StatefulWidget {
  final Widget Function(BuildContext context, bool isScrollEnabled) _builder;
  final ScrollController _controller;
  ///
  /// Creates a widget that provides information about ability to scroll
  /// content of widget with passed [ScrollController].
  ///
  /// `builder` - called to construct widget tree.
  /// `controller` - [ScrollController] of tracked scrollable widget.
  ///
  /// To correct work, scrollable widget must be a direct child of
  /// [ScrollableBuilderWiddget].
  const ScrollableBuilderWiddget({
    super.key,
    required Widget Function(BuildContext, bool) builder,
    required ScrollController controller,
  })  : _builder = builder,
        _controller = controller;
  ///
  @override
  State<ScrollableBuilderWiddget> createState() =>
      _ScrollableBuilderWiddgetState(
        builder: _builder,
      );
}
///
class _ScrollableBuilderWiddgetState extends State<ScrollableBuilderWiddget> {
  bool _isScrollEnabled = false;
  BoxConstraints? _layoutConstraints;
  final Widget Function(BuildContext context, bool isScrollEnabled) _builder;
  ///
  _ScrollableBuilderWiddgetState({
    required Widget Function(BuildContext, bool) builder,
  }) : _builder = builder;
  ///
  void _checkIsScrollEnabled() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = widget._controller.position;
      final isScrollEnabled =
          (position.maxScrollExtent != 0.0 || position.minScrollExtent != 0.0);
      if (_isScrollEnabled == isScrollEnabled) return;
      setState(() {
        _isScrollEnabled = isScrollEnabled;
      });
    });
  }
  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (_layoutConstraints != constraints) {
        _checkIsScrollEnabled();
        _layoutConstraints = constraints;
      }
      return _builder(context, _isScrollEnabled);
    });
  }
}
