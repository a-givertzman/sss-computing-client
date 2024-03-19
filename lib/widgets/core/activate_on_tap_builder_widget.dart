import 'package:flutter/material.dart';

class ActivateOnTapBuilderWidget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    bool isActivated,
    void Function() deactivate,
  ) builder;
  final bool? Function()? onActivate;
  final bool? Function()? onDeactivate;
  const ActivateOnTapBuilderWidget({
    super.key,
    required this.builder,
    this.onActivate,
    this.onDeactivate,
  });

  @override
  State<ActivateOnTapBuilderWidget> createState() =>
      _ActivateOnTapBuilderWidgetState();
}

class _ActivateOnTapBuilderWidgetState
    extends State<ActivateOnTapBuilderWidget> {
  bool _isActivated = false;

  void _handleActivate() {
    setState(() {
      if (widget.onActivate?.call() ?? false) return;
      _isActivated = true;
    });
  }

  void _handleDeactivate() {
    setState(() {
      if (widget.onDeactivate?.call() ?? false) return;
      _isActivated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isActivated
        ? TapRegion(
            onTapOutside: (_) => _handleDeactivate(),
            child: Builder(
              builder: (context) => widget.builder(
                context,
                _isActivated,
                _handleDeactivate,
              ),
            ),
          )
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _handleActivate(),
              child: Builder(
                builder: (context) => widget.builder(
                  context,
                  _isActivated,
                  _handleDeactivate,
                ),
              ),
            ),
          );
  }
}
