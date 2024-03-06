import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

class ScrollableBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool isScrollable) builder;
  final ScrollController controller;
  const ScrollableBuilder({
    super.key,
    required this.builder,
    required this.controller,
  });
  @override
  State<ScrollableBuilder> createState() => _ScrollableBuilderState();
}

class _ScrollableBuilderState extends State<ScrollableBuilder> {
  bool _isScrollEnabled = false;
  BoxConstraints? _constraints;

  void _checkIsScrollEnabled() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final position = widget.controller.position;
        final isScrollEnabled =
            position.maxScrollExtent != 0.0 || position.minScrollExtent != 0.0;
        Log('$runtimeType | position.minScrollExtent')
            .debug('${position.minScrollExtent}');
        Log('$runtimeType | position.maxScrollExtent')
            .debug('${position.maxScrollExtent}');
        Log('$runtimeType | isScrollEnabled').debug('$_isScrollEnabled');
        if (_isScrollEnabled == isScrollEnabled) return;
        setState(() {
          Log('$runtimeType | isScrollEnabled is set to')
              .debug('$isScrollEnabled');
          _isScrollEnabled = isScrollEnabled;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (_constraints != constraints) {
        _checkIsScrollEnabled();
        _constraints = constraints;
      }
      return Builder(
        builder: (context) => widget.builder(context, _isScrollEnabled),
      );
    });
  }
}
