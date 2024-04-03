import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/core/models/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme_refactored/widgets/ship_scheme.dart';

///
class ShipSchemeBody extends StatefulWidget {
  ///
  const ShipSchemeBody({super.key});

  ///
  @override
  State<ShipSchemeBody> createState() => _ShipSchemeBodyState();
}

///
class _ShipSchemeBodyState extends State<ShipSchemeBody> {
  final _minX = -50.0;
  final _maxX = 50.0;
  final _minY = 0.0;
  final _maxY = 100.0;
  final _frameTNumber = 20;
  final _frameRNumber = 100;
  final _controller = TransformationController();
  late final List<(double, double, String)> _framesTheoretic;
  late final List<(double, String)> _framesReal;

  ///
  @override
  // ignore: long-method
  void initState() {
    _framesTheoretic = List<(double, double, String)>.generate(
      _frameTNumber,
      (index) {
        final width = (_maxX - _minX) / _frameTNumber;
        return (
          _minX + index * width,
          _minX + (index + 1) * width,
          // '$index${index == 0 ? 'FT' : ''}'
          '${index}FT'
        );
      },
    );
    _framesReal = [
      ...List<(double, String)>.generate(25, (index) {
        final width = (_maxX - _minX) / 2 / _frameRNumber;
        // return (minX + index * width, '$index${index == 0 ? 'FR' : ''}');
        return (_minX + index * width, '${index}FR');
      }),
      ...List<(double, String)>.generate(25, (index) {
        final width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX + ((_maxX - _minX) / 2 / _frameRNumber) * 25 + (index) * width,
          '${index + 25}FR'
        );
      }),
      ...List<(double, String)>.generate(50, (index) {
        final width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          '${index + 50}FR'
        );
      }),
      ...List<(double, String)>.generate(25, (index) {
        final width = (_maxX - _minX) / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 75 +
              ((_maxX - _minX) / _frameRNumber) * 25 +
              (index) * width,
          '${index + 100}FR'
        );
      }),
      ...List<(double, String)>.generate(25, (index) {
        final width = (_maxX - _minX) / 2 / _frameRNumber;
        return (
          _minX +
              ((_maxX - _minX) / 2 / _frameRNumber) * 25 +
              ((_maxX - _minX) / _frameRNumber) * 75 +
              (index) * width,
          '${index + 125}FR'
        );
      }),
    ];
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: SizedBox(
            width: 500.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShipScheme(
                  minX: _minX,
                  maxX: _maxX,
                  minY: _minY,
                  maxY: _maxY,
                  xAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 25.0,
                    isGridVisible: true,
                  ),
                  yAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 25.0,
                    isGridVisible: true,
                  ),
                  body: ('assets/img/side3.svg', -100.0, 100.0),
                  framesTheoretic: _framesTheoretic,
                  framesReal: _framesReal,
                  transformationController: _controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
