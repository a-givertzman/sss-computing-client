import 'package:flutter/material.dart';
///
/// Read only text field that display some value based on
/// other text fields values.
class ReadOnlyTextField extends StatefulWidget {
  final String _label;
  final String Function() _getValue;
  final List<TextEditingController> _toListen;
  ///
  /// Creates read only text field that display some value based on
  /// other text fields values.
  ///
  /// * [label] - label for text field.
  /// * [getValue] - function that returns value to display.
  /// * [toListen] - list of text controllers to listen changes.
  const ReadOnlyTextField({
    super.key,
    required String label,
    required String Function() getValue,
    List<TextEditingController> toListen = const [],
  })  : _label = label,
        _getValue = getValue,
        _toListen = toListen;
  ///
  @override
  State<ReadOnlyTextField> createState() => _ReadOnlyTextFieldState();
}
///
class _ReadOnlyTextFieldState extends State<ReadOnlyTextField> {
  late TextEditingController _controller;
  late List<TextEditingController> _toListen;
  //
  @override
  void initState() {
    _toListen = widget._toListen;
    _controller = TextEditingController(text: widget._getValue());
    for (final controller in _toListen) {
      controller.addListener(_onValueChange);
    }
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _toListen) {
      controller.removeListener(_onValueChange);
    }
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      canRequestFocus: false,
      mouseCursor: SystemMouseCursors.basic,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget._label,
      ),
    );
  }
  //
  void _onValueChange() {
    _controller.text = widget._getValue();
  }
}
