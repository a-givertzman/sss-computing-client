import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

class ScrollableBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool isScrollable) builder;
  final ScrollController controller;
  final bool sizeChangedBubbling;
  const ScrollableBuilder({
    super.key,
    required this.builder,
    required this.controller,
    this.sizeChangedBubbling = false,
  });
  @override
  State<ScrollableBuilder> createState() => _ScrollableBuilderState();
}

class _ScrollableBuilderState extends State<ScrollableBuilder> {
  bool _isScrollable = false;
  void _checkIsScrollable() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final position = widget.controller.position;
        final isScrollable =
            position.maxScrollExtent != 0.0 || position.minScrollExtent != 0.0;
        Log('$runtimeType | isScrollable').debug('$isScrollable');
        Log('$runtimeType | position.minScrollExtent')
            .debug('${position.minScrollExtent}');
        Log('$runtimeType | position.maxScrollExtent')
            .debug('${position.maxScrollExtent}');
        if (_isScrollable == isScrollable) return;
        setState(() {
          _isScrollable = isScrollable;
        });
      },
    );
  }

  @override
  void initState() {
    _checkIsScrollable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _checkIsScrollable();
        return !widget.sizeChangedBubbling;
      },
      child: SizeChangedLayoutNotifier(
        child: Builder(
          builder: (context) => widget.builder(context, _isScrollable),
        ),
      ),
    );
  }
}
