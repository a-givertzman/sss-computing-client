import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme.dart';

///
class ShipSchemeBody extends StatefulWidget {
  const ShipSchemeBody({super.key});

  @override
  State<ShipSchemeBody> createState() => _ShipSchemeBodyState();
}

class _ShipSchemeBodyState extends State<ShipSchemeBody> {
  final _minX = -100.0;
  final _maxX = 100.0;
  final _minY = -33.0;
  final _maxY = 17.0;
  final _frameTNumber = 20;
  final _frameRNumber = 100;
  late final List<(double, double, String)> _framesTheoretic;
  late final List<(double, String)> _framesReal;

  /// Testing scale and shift sync
  final _profileController = TransformationController();
  final _topController = TransformationController();
  double _scaleX = 1.0;
  double _scaleY = 1.0;
  double _shiftX = 0.0;

  ///
  void _handleProfileTransform() {
    final (scaleX, scaleY) = (
      _profileController.value[0],
      _profileController.value[5],
    );
    final shiftX = _profileController.value.getTranslation()[0];
    setState(() {
      if (scaleX != _scaleX) {
        _topController.value.scale(scaleX / _scaleX);
        _scaleY = _topController.value[5];
        _scaleX = scaleX;
      }
      if (scaleY != _scaleY) {
        _topController.value.scale(scaleY / _scaleY);
        _scaleX = _topController.value[0];
        _scaleY = scaleY;
      }
      if (shiftX != _shiftX) {
        final oldShift = _topController.value.getTranslation();
        _topController.value.setTranslationRaw(
          shiftX,
          oldShift[1],
          oldShift[2],
        );
        _shiftX = shiftX;
      }
    });
  }

  ///
  void _handleTopTransform() {
    final (scaleX, scaleY) = (
      _topController.value[0],
      _topController.value[5],
    );
    final shiftX = _topController.value.getTranslation()[0];
    setState(() {
      if (scaleX != _scaleX) {
        _profileController.value.scale(scaleX / _scaleX);
        _profileController.notifyListeners();
        _scaleY = _profileController.value[5];
        _scaleX = scaleX;
      }
      if (scaleY != _scaleY) {
        _profileController.value.scale(scaleY / _scaleY);
        _profileController.notifyListeners();
        _scaleX = _profileController.value[0];
        _scaleY = scaleY;
      }
      if (shiftX != _shiftX) {
        final oldShift = _profileController.value.getTranslation();
        _profileController.value.setTranslationRaw(
          shiftX,
          oldShift[1],
          oldShift[2],
        );
        _profileController.notifyListeners();
        _shiftX = shiftX;
      }
    });
  }

  ///
  @override
  // ignore: long-method
  void initState() {
    // _profileController.addListener(_handleProfileTransform);
    // _topController.addListener(_handleTopTransform);
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
  void dispose() {
    // _profileController.removeListener(_handleProfileTransform);
    // _topController.removeListener(_handleTopTransform);
    super.dispose();
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
            width: 1800.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShipScheme(
                  // caption: 'Profile view',
                  minX: _minX,
                  maxX: _maxX,
                  minY: _minY,
                  maxY: _maxY,
                  xAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 25.0,
                    isGridVisible: false,
                  ),
                  yAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 10.0,
                    isGridVisible: false,
                  ),
                  body: ('assets/img/side3.svg', -100.0, 100.0),
                  framesTheoretic: _framesTheoretic,
                  framesReal: _framesReal,
                  trController: _profileController,
                ),
                ShipScheme(
                  // caption: 'Top view',
                  minX: _minX,
                  maxX: _maxX,
                  minY: -30.0,
                  maxY: 30.0,
                  xAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 25.0,
                    isGridVisible: false,
                  ),
                  yAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 10.0,
                    isGridVisible: false,
                  ),
                  body: ('assets/img/top3.svg', -100.0, 100.0),
                  framesTheoretic: _framesTheoretic,
                  framesReal: _framesReal,
                  trController: _profileController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
