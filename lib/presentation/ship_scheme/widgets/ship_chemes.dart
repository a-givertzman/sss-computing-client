import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/figures_test.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_interact_options.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_view_options.dart';
///
const Set<ShipSchemeViewOption> _initialViewOptions = {
  ShipSchemeViewOption.showGrid,
  ShipSchemeViewOption.showAxes,
};
const Set<ShipSchemeInteractOption> _initialInteractOptions = {
  ShipSchemeInteractOption.select,
};
///
class ShipSchemes extends StatefulWidget {
  final List<Cargo> _cargos;
  final Cargo? _selectedCargo;
  final void Function(Cargo)? _onCargoSelect;
  ///
  const ShipSchemes({
    super.key,
    required List<Cargo> cargos,
    Cargo? selectedCargo,
    void Function(Cargo cargo)? onCargoSelect,
  })  : _cargos = cargos,
        _selectedCargo = selectedCargo,
        _onCargoSelect = onCargoSelect;
  //
  @override
  State<ShipSchemes> createState() => _ShipSchemesState();
}
///
class _ShipSchemesState extends State<ShipSchemes> {
  Set<ShipSchemeViewOption> _viewOptions = _initialViewOptions;
  Set<ShipSchemeInteractOption> _interactOptions = _initialInteractOptions;
  static const _axesSpaceReserved = 25.0;
  static const _minX = -65.0;
  static const _maxX = 65.0;
  static const _minZ = -5.0;
  static const _maxZ = 15.0;
  static const _minY = -11.0;
  static const _maxY = 11.0;
  static const _shipLeft = -60.0;
  static const _shipRight = 60.0;
  late final Figure _body;
  late final List<(double, double, int)> _framesTheoretic;
  late final List<(double, int)> _framesReal;
  static const _frameTNumber = 20;
  static const _frameRNumber = 100;
  static const _framesRealIdxShift = -10;
  late int _defaultRFrameIdx;
  //
  @override
  // ignore: long-method
  void initState() {
    _framesTheoretic = List<(double, double, int)>.generate(
      _frameTNumber,
      (index) {
        const width = (_shipRight - _shipLeft) / _frameTNumber;
        return (
          _shipLeft + index * width,
          _shipLeft + (index + 1) * width,
          index,
        );
      },
    );
    _framesReal = [
      ...List<(double, int)>.generate(25, (index) {
        const width = (_shipRight - _shipLeft) / 2 / _frameRNumber;
        return (_shipLeft + index * width, index + _framesRealIdxShift);
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_shipRight - _shipLeft) / _frameRNumber;
        return (
          _shipLeft +
              ((_shipRight - _shipLeft) / 2 / _frameRNumber) * 25 +
              (index) * width,
          index + 25 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(50, (index) {
        const width = (_shipRight - _minX) / 2 / _frameRNumber;
        return (
          _shipLeft +
              ((_shipRight - _shipLeft) / 2 / _frameRNumber) * 25 +
              ((_shipRight - _shipLeft) / _frameRNumber) * 25 +
              (index) * width,
          index + 50 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_shipRight - _minX) / _frameRNumber;
        return (
          _shipLeft +
              ((_shipRight - _shipLeft) / 2 / _frameRNumber) * 75 +
              ((_shipRight - _shipLeft) / _frameRNumber) * 25 +
              (index) * width,
          index + 100 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        const width = (_shipRight - _shipLeft) / 2 / _frameRNumber;
        return (
          _shipLeft +
              ((_shipRight - _shipLeft) / 2 / _frameRNumber) * 25 +
              ((_shipRight - _shipLeft) / _frameRNumber) * 75 +
              (index) * width,
          index + 125 + _framesRealIdxShift,
        );
      }),
    ];
    _defaultRFrameIdx = (_framesReal.length / 2.0).ceil();
    _body = shipBody;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final xAxis = ChartAxis(
      caption: 'm',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _viewOptions.contains(ShipSchemeViewOption.showAxes),
      valueInterval: 10.0,
      isGridVisible: _viewOptions.contains(ShipSchemeViewOption.showGrid),
    );
    final yAxis = ChartAxis(
      caption: 'm',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _viewOptions.contains(ShipSchemeViewOption.showAxes),
      valueInterval: 10.0,
      isGridVisible: _viewOptions.contains(ShipSchemeViewOption.showGrid),
    );
    final zAxis = ChartAxis(
      caption: 'm',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible: _viewOptions.contains(ShipSchemeViewOption.showAxes),
      valueInterval: 10.0,
      isGridVisible: _viewOptions.contains(ShipSchemeViewOption.showGrid),
    );
    final framesRealAxis = ChartAxis(
      caption: 'F',
      labelsSpaceReserved: _axesSpaceReserved,
      isLabelsVisible:
          _viewOptions.contains(ShipSchemeViewOption.showRealFrames),
      valueInterval: 10.0,
    );
    final framesTheoreticAxis = ChartAxis(
      caption: 'FT',
      labelsSpaceReserved: _axesSpaceReserved / 2.0,
      isLabelsVisible:
          _viewOptions.contains(ShipSchemeViewOption.showTheoreticFrames),
    );
    final cargos = _mapShipCargosToFigures(
      widget._cargos,
      Colors.brown,
      Colors.brown.withOpacity(0.15),
      shipBody,
    );
    final selectedCargo = _mapShipCargosToFigures(
      [if (widget._selectedCargo != null) widget._selectedCargo!],
      Colors.amber,
      Colors.amber.withOpacity(0.15),
      _body,
    );
    final currentRFrameIdx = widget._selectedCargo != null
        ? _framesReal.indexWhere(
            (frame) {
              final (offset, _) = frame;
              final leftBound =
                  widget._selectedCargo!.asMap()['bound_x1'] as double;
              final rightBound =
                  widget._selectedCargo!.asMap()['bound_x2'] as double;
              return (offset >= leftBound && offset <= rightBound);
            },
          )
        : _defaultRFrameIdx;
    final sectionedCargos = _extractShipCargosFromSection(
      cargos,
      _framesReal[currentRFrameIdx].$1,
    );
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShipSchemeInteractOptions(
                          initialOptions: _interactOptions,
                          availableOptions: const {
                            ShipSchemeInteractOption.view,
                            ShipSchemeInteractOption.select,
                          },
                          onOptionsChanged: (newOptions) => setState(() {
                            _interactOptions = newOptions;
                          }),
                        ),
                      ],
                    ),
                  ),
                  ShipSchemeViewOptions(
                    initialOptions: _viewOptions,
                    availableOptions: const {
                      ShipSchemeViewOption.showAxes,
                      ShipSchemeViewOption.showGrid,
                      ShipSchemeViewOption.showRealFrames,
                      ShipSchemeViewOption.showTheoreticFrames,
                    },
                    onOptionsChanged: (newOptions) => setState(() {
                      _viewOptions = newOptions;
                    }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget._selectedCargo?.name ?? '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: padding * 2,
              ),
              Flexible(
                flex: 1,
                child: ShipScheme(
                  caption: 'Side View',
                  projection: (FigureAxis.x, FigureAxis.z),
                  minX: _minX,
                  maxX: _maxX,
                  xAxis: xAxis,
                  invertHorizontal: false,
                  minY: _minZ,
                  maxY: _maxZ,
                  yAxis: zAxis,
                  invertVertical: true,
                  framesReal: _framesReal,
                  framesRealAxis: framesRealAxis,
                  framesTheoretic: _framesTheoretic,
                  framesTheoreticAxis: framesTheoreticAxis,
                  shipBody: _body,
                  cargos: [...cargos]..sort(
                      (one, other) => (one.$1.y2 - other.$1.y2).toInt(),
                    ),
                  onCargoTap: (cargo) => widget._onCargoSelect?.call(cargo),
                  selectedCargos: selectedCargo,
                  isViewInteractive: _interactOptions.contains(
                    ShipSchemeInteractOption.view,
                  ),
                ),
              ),
              SizedBox(
                height: padding,
              ),
              Flexible(
                flex: 1,
                child: ShipScheme(
                  caption: 'Top View',
                  projection: (FigureAxis.x, FigureAxis.y),
                  minX: _minX,
                  maxX: _maxX,
                  xAxis: xAxis,
                  invertHorizontal: false,
                  minY: _minY,
                  maxY: _maxY,
                  yAxis: zAxis,
                  invertVertical: false,
                  framesReal: _framesReal,
                  framesRealAxis: framesRealAxis,
                  framesTheoretic: _framesTheoretic,
                  framesTheoreticAxis: framesTheoreticAxis,
                  shipBody: _body,
                  cargos: cargos,
                  onCargoTap: (cargo) => widget._onCargoSelect?.call(cargo),
                  selectedCargos: selectedCargo,
                  isViewInteractive: _interactOptions.contains(
                    ShipSchemeInteractOption.view,
                  ),
                ),
              ),
              SizedBox(
                height: padding,
              ),
              Flexible(
                flex: 1,
                child: ShipScheme(
                  caption:
                      '${currentRFrameIdx + _framesRealIdxShift} Fr. FWD→AFT',
                  projection: (FigureAxis.y, FigureAxis.z),
                  minX: _minY,
                  maxX: _maxY,
                  xAxis: yAxis,
                  invertHorizontal: true,
                  minY: _minZ,
                  maxY: _maxZ,
                  yAxis: zAxis,
                  invertVertical: true,
                  framesReal: _framesReal,
                  framesRealAxis: const ChartAxis(
                    isLabelsVisible: false,
                  ),
                  framesTheoretic: _framesTheoretic,
                  framesTheoreticAxis: const ChartAxis(
                    isLabelsVisible: false,
                  ),
                  shipBody: _body,
                  cargos: sectionedCargos,
                  onCargoTap: (cargo) => widget._onCargoSelect?.call(cargo),
                  selectedCargos: selectedCargo,
                  isViewInteractive: _interactOptions.contains(
                    ShipSchemeInteractOption.view,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<(Cargo, Figure)> _mapShipCargosToFigures(
    List<Cargo> cargos,
    Color borderColor,
    Color fillColor,
    Figure bounder,
  ) {
    return cargos
        .map(
          (cargo) => (
            cargo,
            BoundedFigure(
              figure: RectFigure(
                borderColor: borderColor,
                fillColor: fillColor,
                dx1: cargo.asMap()['bound_x1'],
                dx2: cargo.asMap()['bound_x2'],
                dy1: cargo.asMap()['bound_y1'],
                dy2: cargo.asMap()['bound_y2'],
                dz1: cargo.asMap()['bound_z1'],
                dz2: cargo.asMap()['bound_z2'],
              ),
              bounder: bounder,
            )
          ),
        )
        .toList();
  }
  List<(Cargo, Figure)> _extractShipCargosFromSection(
    List<(Cargo, Figure)> cargosFigures,
    double dx,
  ) {
    return cargosFigures.where((cargo) {
      final (_, figure) = cargo;
      final bounds = figure
          .getOrthoProjection(
            FigureAxis.x,
            FigureAxis.y,
          )
          .getBounds();
      return (dx > bounds.left && dx <= bounds.right);
    }).toList();
  }
}
