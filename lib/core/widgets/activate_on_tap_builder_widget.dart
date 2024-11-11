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
  ) _builder;
  final bool? Function()? _onActivate;
  final bool? Function()? _onDeactivate;
  final bool _useDoubleTap;
  final MouseCursor _cursor;
  ///
  /// Creates widget that becomes active when clicked
  /// and deactivates when clicked outside its area or press ESC key.
  ///
  /// Current state can be obtained via parameters of [builder]
  /// that used to build this widget.
  ///
  /// [onActivate] and [onDeactivate] callbacks can be used
  /// to handle activation and deactivation events. If they return
  /// `true`, then activating/deactivating will be cancelled.
  ///
  /// If [useDoubleTap] is `true`, then widget becomes active
  /// on double tap instead of single tap.
  ///
  /// [cursor] specifies mouse cursor when mouse dragged over this widget.
  const ActivateOnTapBuilderWidget({
    super.key,
    required Widget Function(BuildContext, bool, void Function()) builder,
    bool? Function()? onActivate,
    bool? Function()? onDeactivate,
    bool useDoubleTap = false,
    MouseCursor cursor = SystemMouseCursors.click,
  })  : _builder = builder,
        _onActivate = onActivate,
        _onDeactivate = onDeactivate,
        _useDoubleTap = useDoubleTap,
        _cursor = cursor;
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
    if (widget._onActivate?.call() ?? false) return;
    setState(() {
      _isActivated = true;
    });
  }
  //
  void _handleDeactivate() {
    if (widget._onDeactivate?.call() ?? false) return;
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
                    widget._builder(context, _isActivated, _handleDeactivate),
              ),
            ),
          )
        : MouseRegion(
            cursor: widget._cursor,
            child: GestureDetector(
              onTap: widget._useDoubleTap ? null : _handleActivate,
              onDoubleTap: widget._useDoubleTap ? _handleActivate : null,
              child: Builder(
                builder: (context) => widget._builder(
                  context,
                  _isActivated,
                  _handleDeactivate,
                ),
              ),
            ),
          );
  }
}
