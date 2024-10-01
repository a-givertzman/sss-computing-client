import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
///
/// Creates widget that becomes active when clicked
/// and deactivates when clicked outside its area.
/// State can be obtained via builder parameters.
class ActivateOnTapBuilderWidget extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    bool isActivated,
    void Function() deactivate,
  ) builder;
  final bool? Function()? onActivate;
  final bool? Function()? onDeactivate;
  final MouseCursor cursor;
  ///
  const ActivateOnTapBuilderWidget({
    super.key,
    required this.builder,
    this.onActivate,
    this.onDeactivate,
    this.cursor = SystemMouseCursors.click,
  });
  ///
  @override
  State<ActivateOnTapBuilderWidget> createState() =>
      _ActivateOnTapBuilderWidgetState();
}
///
class _ActivateOnTapBuilderWidgetState
    extends State<ActivateOnTapBuilderWidget> {
  late final FocusNode _focusNode;
  bool _isActivated = false;
  //
  void _handleActivate() {
    if (widget.onActivate?.call() ?? false) return;
    setState(() {
      _isActivated = true;
    });
  }
  //
  void _handleDeactivate() {
    if (widget.onDeactivate?.call() ?? false) return;
    setState(() {
      _isActivated = false;
    });
  }
  //
  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }
  //
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return _isActivated
        ? TapRegion(
            onTapOutside: (_) => _handleDeactivate(),
            child: KeyboardListener(
              focusNode: _focusNode,
              autofocus: true,
              onKeyEvent: (event) {
                if (event.physicalKey == PhysicalKeyboardKey.escape) {
                  _handleDeactivate();
                }
              },
              child: Builder(
                builder: (context) =>
                    widget.builder(context, _isActivated, _handleDeactivate),
              ),
            ),
          )
        : MouseRegion(
            cursor: widget.cursor,
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
