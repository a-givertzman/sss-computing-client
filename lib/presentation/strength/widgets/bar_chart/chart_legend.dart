import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
class ChartLegend extends StatelessWidget {
  final List<String> _names;
  final List<Color> _colors;
  final double _height;
  final TextAlign? _textAlign;

  ///
  const ChartLegend({
    super.key,
    required List<String> names,
    required List<Color> colors,
    required double height,
    TextAlign? textAlign,
  })  : _names = names,
        _colors = colors,
        _height = height,
        _textAlign = textAlign;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding', factor: 0.5).toDouble;
    return SizedBox(
      height: _height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (_, i) => Container(
          padding: EdgeInsets.symmetric(
            vertical: padding * 0.5,
            horizontal: padding,
          ),
          color: _colors.elementAt(i).withOpacity(0.5),
          child: Text(
            _names.elementAt(i),
            softWrap: false,
            overflow: TextOverflow.fade,
            textAlign: _textAlign,
          ),
        ),
        separatorBuilder: (_, __) => SizedBox(width: padding),
        itemCount: _names.length,
      ),
    );
  }
}
