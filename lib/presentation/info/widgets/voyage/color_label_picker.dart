import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
/// Widget that displays a color label and allows to change it.
class ColorLabelPicker extends StatefulWidget {
  final Color _color;
  final void Function(Color newColor) _updateColor;
  final ThemeData _themeData;
  final String? _label;
  ///
  /// Creates widget that displays a [color] label and allows to change it,
  /// [updateColor] is called when color is changed.
  ///
  /// [themeData] is used to style the color picker dialog.
  /// [label] is displayed as tooltip for the color label.
  const ColorLabelPicker({
    super.key,
    required Color color,
    required void Function(Color newColor) updateColor,
    required ThemeData themeData,
    String? label,
  })  : _color = color,
        _updateColor = updateColor,
        _label = label,
        _themeData = themeData;
  //
  @override
  State<ColorLabelPicker> createState() => _ColorLabelPickerState();
}
///
class _ColorLabelPickerState extends State<ColorLabelPicker> {
  late Color _pickerColor;
  //
  @override
  void initState() {
    _pickerColor = widget._color;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final borderRadius = const Setting('colorLabelBorderRadius').toDouble;
    final width = const Setting('colorLabelWidth').toDouble;
    final height = const Setting('colorLabelHeight').toDouble;
    //
    return GestureDetector(
      onTap: () => _pickColor(context),
      child: Tooltip(
        message: widget._label ?? '',
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.symmetric(
            vertical: borderRadius,
          ),
          decoration: BoxDecoration(
            color: widget._color,
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
  //
  void _pickColor(BuildContext context) async {
    final blockPadding = const Setting('blockPadding').toDouble;
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Theme(
        data: widget._themeData,
        child: AlertDialog(
          content: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: blockPadding),
              child: ColorPicker(
                enableAlpha: false,
                hexInputBar: true,
                pickerColor: widget._color,
                onColorChanged: (color) => setState(() {
                  _pickerColor = color;
                }),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(const Localized('Cancel').v),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget._updateColor(_pickerColor);
              },
              child: Text(const Localized('Ok').v),
            ),
          ],
        ),
      ),
    );
  }
}
