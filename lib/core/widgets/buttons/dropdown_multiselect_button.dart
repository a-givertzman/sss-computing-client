import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/widgets/buttons/action_button.dart';
import 'package:sss_computing_client/core/widgets/buttons/multiselect_items_list_widget.dart';
///
class DropdownMultiselectButton extends StatefulWidget {
  final double? _height;
  final double? _width;
  final double _itemHeight;
  final double _menuWidth;
  final double _labelLineHeight;
  final String? _label;
  final Map<String, bool> _items;
  final void Function(Map<String, bool>)? _onChanged;
  ///
  const DropdownMultiselectButton({
    super.key,
    required Map<String, bool> items,
    String? label,
    double? height,
    double? width,
    double itemHeight = 20.0,
    double menuWidth = 200.0,
    double labelLineHeight = 1.0,
    void Function(Map<String, bool> items)? onChanged,
  })  : _labelLineHeight = labelLineHeight,
        _onChanged = onChanged,
        _menuWidth = menuWidth,
        _itemHeight = itemHeight,
        _height = height,
        _width = width,
        _label = label,
        _items = items;
  ///
  @override
  State<DropdownMultiselectButton> createState() =>
      _DropdownMultiselectButtonState(
        items: _items,
        label: _label,
        labelLineHeight: _labelLineHeight,
        height: _height,
        width: _width,
        itemHeight: _itemHeight,
        menuWidth: _menuWidth,
        onChanged: _onChanged,
      );
}
///
class _DropdownMultiselectButtonState extends State<DropdownMultiselectButton> {
  final double? _height;
  final double? _width;
  final double _itemHeight;
  final double _menuWidth;
  final String? _label;
  final void Function(Map<String, bool>)? _onChanged;
  final Map<String, bool> _items;
  OverlayEntry? _overlayEntry;
  ///
  _DropdownMultiselectButtonState({
    required Map<String, bool> items,
    String? label,
    required double labelLineHeight,
    double? height,
    double? width,
    required double itemHeight,
    required double menuWidth,
    void Function(Map<String, bool> items)? onChanged,
  })  : _items = items,
        _label = label,
        _width = width,
        _height = height,
        _itemHeight = itemHeight,
        _menuWidth = menuWidth,
        _onChanged = onChanged;
  ///
  @override
  void dispose() {
    _removeOverlayEntry();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      width: _width,
      child: ActionButton(
        onPressed: () => _toggleMenu(context),
        label: _label ?? '',
        icon: (_overlayEntry == null
            ? Icons.arrow_drop_down
            : Icons.arrow_drop_up),
        iconAlignment: IconAlignment.start,
      ),
    );
  }
  ///
  void _toggleMenu(BuildContext context) {
    if (_overlayEntry != null) {
      _removeOverlayEntry();
    } else {
      final overlayState = Overlay.of(context);
      final RenderBox box = context.findRenderObject()! as RenderBox;
      final Offset position = box.localToGlobal(
        box.size.bottomLeft(Offset.zero),
        ancestor: overlayState.context.findRenderObject(),
      );
      setState(() {
        _overlayEntry = OverlayEntry(
          builder: (context) => Stack(
            children: [
              ModalBarrier(
                onDismiss: _removeOverlayEntry,
              ),
              Positioned(
                top: position.dy,
                left: position.dx,
                child: MultiselectItemsListWidget(
                  multiselectItems: _items,
                  width: _menuWidth,
                  itemHeight: _itemHeight,
                  onChanged: (items) {
                    _onChanged?.call(items);
                  },
                ),
              ),
            ],
          ),
        );
      });
      overlayState.insert(_overlayEntry!);
    }
  }
  ///
  void _removeOverlayEntry() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    Future.delayed(
      Duration.zero,
      () {
        if (mounted) {
          setState(() {
            _overlayEntry = null;
          });
        }
      },
    );
  }
}
