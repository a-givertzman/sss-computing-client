import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/core/widgets/buttons/dropdown_multiselect_button.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/figures_test.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme.dart';
import 'package:sss_computing_client/core/widgets/buttons/segmented_button_options.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_test.dart';

///
enum ShipSchemeViewOptions {
  showAxes,
  showGrid,
  showRealFrames,
  showTheoreticFrames,
  showWaterline,
}

///
const Set<ShipSchemeViewOptions> _initialViewOptions = {
  ShipSchemeViewOptions.showGrid,
  ShipSchemeViewOptions.showAxes,
};

///
enum ShipSchemeInteractOptions {
  view,
  select,
}

///
const Set<ShipSchemeInteractOptions> _initialInteractOptions = {
  ShipSchemeInteractOptions.select,
};

///
class ShipSchemes extends StatefulWidget {
  // final List<Cargo> _cargos;
  // final Cargo? _selectedCargo;
  // final void Function(Cargo)? _onCargoSelect;
  final ShipCargoModel _shipCargoNotifier;

  ///
  const ShipSchemes({
    super.key,
    // required List<Cargo> cargos,
    // Cargo? selectedCargo,
    // void Function(Cargo cargo)? onCargoSelect,
    required ShipCargoModel shipCargoNotifier,
  }) : _shipCargoNotifier = shipCargoNotifier;
  // _cargos = cargos,
  // _selectedCargo = selectedCargo,
  // _onCargoSelect = onCargoSelect;

  ///
  @override
  State<ShipSchemes> createState() => _ShipSchemesState();
}

///
class _ShipSchemesState extends State<ShipSchemes> {
  Set<ShipSchemeViewOptions> _viewOptions = _initialViewOptions;
  Set<ShipSchemeInteractOptions> _interactOptions = _initialInteractOptions;
  Map<String, bool> _cargoTypeFilter = {
    'BALLAST': true,
    'FRESH_WATER': false,
    'OILS_AND_FUELS': false,
    'ACIDS_AND_ALKALIS': false,
    'POLLUTED_LIQUIDS': false,
    'CARGO': false,
  };
  static const _axesSpaceReserved = 25.0;
  static const _minX = -65.0;
  static const _maxX = 65.0;
  static const _minZ = -2.5;
  static const _maxZ = 20.0;
  static const _minY = -11.0;
  static const _maxY = 11.0;
  static const _shipLeft = -60.0;
  static const _shipRight = 60.0;
  late final Figure _body;
  late final Figure? _bodyPretty;
  late final List<(double, double, int)> _framesTheoretic;
  late final List<(double, int)> _framesReal;
  static const _frameTNumber = 20;
  static const _frameRNumber = 100;
  static const _framesRealIdxShift = -10;
  late int _defaultRFrameIdx;

  ///
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
    _bodyPretty = shipBodyPretty;
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget._shipCargoNotifier,
      builder: (context, _) {
        final padding = const Setting('padding').toDouble;
        final xAxis = ChartAxis(
          caption: 'm',
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible:
              _viewOptions.contains(ShipSchemeViewOptions.showAxes),
          valueInterval: 10.0,
          isGridVisible: _viewOptions.contains(ShipSchemeViewOptions.showGrid),
        );
        final yAxis = ChartAxis(
          caption: 'm',
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible:
              _viewOptions.contains(ShipSchemeViewOptions.showAxes),
          valueInterval: 10.0,
          isGridVisible: _viewOptions.contains(ShipSchemeViewOptions.showGrid),
        );
        final zAxis = ChartAxis(
          caption: 'm',
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible:
              _viewOptions.contains(ShipSchemeViewOptions.showAxes),
          valueInterval: 10.0,
          isGridVisible: _viewOptions.contains(ShipSchemeViewOptions.showGrid),
        );
        final framesRealAxis = ChartAxis(
          caption: 'F',
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible:
              _viewOptions.contains(ShipSchemeViewOptions.showRealFrames),
          valueInterval: 10.0,
        );
        final framesTheoreticAxis = ChartAxis(
          caption: 'FT',
          labelsSpaceReserved: _axesSpaceReserved / 2.0,
          isLabelsVisible:
              _viewOptions.contains(ShipSchemeViewOptions.showTheoreticFrames),
        );
        final cargos = widget._shipCargoNotifier.cargos.where((cargo) {
          if (_cargoTypeFilter.containsKey(cargo.type)) {
            return _cargoTypeFilter[cargo.type]!;
          }
          return false;
        }).toList();
        final cargoFigures = _mapShipCargosToFigures(
          cargos,
          shipBody,
        );
        final selectedCargoFigures = _mapShipCargosToFigures(
          [
            if (widget._shipCargoNotifier.selectedCargo != null)
              widget._shipCargoNotifier.selectedCargo!,
          ],
          _body,
          borderColor: Colors.amber,
          fillColor: Colors.amber.withOpacity(0.25),
        );
        var currentRFrameIdx = widget._shipCargoNotifier.selectedCargo != null
            ? _framesReal.indexWhere(
                (frame) {
                  final (offset, _) = frame;
                  final leftBound = widget._shipCargoNotifier.selectedCargo!
                      .asMap()['bound_x1'] as double;
                  final rightBound = widget._shipCargoNotifier.selectedCargo!
                      .asMap()['bound_x2'] as double;
                  return (offset >= leftBound && offset <= rightBound);
                },
              )
            : _defaultRFrameIdx;
        currentRFrameIdx =
            (currentRFrameIdx == -1 ? _defaultRFrameIdx : currentRFrameIdx);
        final sectionedCargos = _extractShipCargosFromSection(
          cargoFigures,
          _framesReal[currentRFrameIdx].$1,
        );
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: DropdownMultiselectButton(
                      itemHeight: 50.0,
                      label: const Localized('Cargos').v,
                      items: _cargoTypeFilter,
                      onChanged: (newFilter) => setState(() {
                        _cargoTypeFilter = newFilter;
                      }),
                    ),
                  ),
                ),
                SegmentedButtonOptions<ShipSchemeViewOptions>(
                  multiSelectionEnabled: true,
                  emptySelectionEnabled: true,
                  initialOptions: _viewOptions,
                  availableOptions: {
                    ShipSchemeViewOptions.showAxes: SegmentedButtonOption(
                      label: const Localized('Axes').v,
                      tooltip: const Localized('Show axes').v,
                      icon: Icons.merge,
                    ),
                    ShipSchemeViewOptions.showGrid: SegmentedButtonOption(
                      label: const Localized('Grid').v,
                      tooltip: const Localized('Show grid').v,
                      icon: Icons.grid_4x4,
                    ),
                    ShipSchemeViewOptions.showRealFrames: SegmentedButtonOption(
                      label: const Localized('Fr. R.').v,
                      tooltip: const Localized('Show real frames').v,
                      icon: Icons.horizontal_distribute_outlined,
                    ),
                    ShipSchemeViewOptions.showTheoreticFrames:
                        SegmentedButtonOption(
                      label: const Localized('Fr. Th.').v,
                      tooltip: const Localized('Show theoretic frames').v,
                      icon: Icons.horizontal_distribute_outlined,
                    ),
                  },
                  onOptionsChanged: (newOptions) => setState(() {
                    _viewOptions = newOptions;
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SegmentedButtonOptions<ShipSchemeInteractOptions>(
                      initialOptions: _interactOptions,
                      availableOptions: {
                        ShipSchemeInteractOptions.view: SegmentedButtonOption(
                          icon: Icons.open_with,
                          tooltip: const Localized('View tool').v,
                        ),
                        ShipSchemeInteractOptions.select: SegmentedButtonOption(
                          icon: Icons.highlight_alt_outlined,
                          tooltip: const Localized('Select tool').v,
                        ),
                      },
                      onOptionsChanged: (newOptions) => setState(() {
                        _interactOptions = newOptions;
                      }),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: padding * 2,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ShipScheme(
                            caption: 'Side View',
                            projection: (FigureAxes.x, FigureAxes.z),
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
                            shipBodyPretty: _bodyPretty,
                            cargos: _getSortedShipCargos(
                              cargoFigures,
                              FigureAxes.y,
                            ),
                            onCargoTap: (cargo) =>
                                widget._shipCargoNotifier.toggleSelected(cargo),
                            selectedCargos: _getSortedShipCargos(
                              selectedCargoFigures,
                              FigureAxes.y,
                            ),
                            isViewInteractive: _interactOptions.contains(
                              ShipSchemeInteractOptions.view,
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: padding,
                        ),
                        Flexible(
                          flex: 1,
                          child: ShipScheme(
                            caption: 'Top View',
                            projection: (FigureAxes.x, FigureAxes.y),
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
                            shipBodyPretty: _bodyPretty,
                            cargos: _getSortedShipCargos(
                              cargoFigures,
                              FigureAxes.z,
                            ),
                            onCargoTap: (cargo) =>
                                widget._shipCargoNotifier.toggleSelected(cargo),
                            selectedCargos: _getSortedShipCargos(
                              selectedCargoFigures,
                              FigureAxes.z,
                            ),
                            isViewInteractive: _interactOptions.contains(
                              ShipSchemeInteractOptions.view,
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: padding,
                  ),
                  Flexible(
                    flex: 1,
                    child: ShipScheme(
                      caption:
                          '${currentRFrameIdx + _framesRealIdxShift} Fr. AFT→FWD',
                      projection: (FigureAxes.y, FigureAxes.z),
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
                      shipBodyPretty: _bodyPretty,
                      cargos: _getSortedShipCargos(
                        sectionedCargos,
                        FigureAxes.x,
                      ),
                      onCargoTap: (cargo) =>
                          widget._shipCargoNotifier.toggleSelected(cargo),
                      selectedCargos: _getSortedShipCargos(
                        selectedCargoFigures,
                        FigureAxes.x,
                      ),
                      isViewInteractive: _interactOptions.contains(
                        ShipSchemeInteractOptions.view,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<(Cargo, Figure)> _mapShipCargosToFigures(
    List<Cargo> cargos,
    Figure bounder, {
    Color? borderColor,
    Color? fillColor,
  }) {
    return cargos.map((cargo) {
      final pathJson = cargo.path;
      if (pathJson != null) {
        final path = json.decode(pathJson);
        return (
          cargo,
          PathFigure(
            borderColor: borderColor ?? mapCargoToColor(cargo),
            fillColor: fillColor ?? mapCargoToColor(cargo).withOpacity(0.15),
            pathProjection: {
              (FigureAxes.x, FigureAxes.y): path['xy'] ?? '',
              (FigureAxes.x, FigureAxes.z): path['xz'] ?? '',
              (FigureAxes.y, FigureAxes.z): path['yz'] ?? '',
            },
          )
        );
      }
      return (
        cargo,
        BoundedFigure(
          figure: RectFigure(
            borderColor: borderColor ?? mapCargoToColor(cargo),
            fillColor: fillColor ?? mapCargoToColor(cargo).withOpacity(0.15),
            dx1: cargo.x1,
            dx2: cargo.x2,
            dy1: cargo.y1,
            dy2: cargo.y2,
            dz1: cargo.z1,
            dz2: cargo.z2,
          ),
          bounder: bounder,
        )
      );
    }).toList();
  }

  List<(Cargo, Figure)> _extractShipCargosFromSection(
    List<(Cargo, Figure)> cargosFigures,
    double dx,
  ) {
    return cargosFigures.where((cargoFigure) {
      final (_, figure) = cargoFigure;
      final bounds = figure
          .getOrthoProjection(
            FigureAxes.x,
            FigureAxes.y,
          )
          .getBounds();
      return (dx > bounds.left && dx <= bounds.right);
    }).toList();
  }

  List<(Cargo, Figure)> _getSortedShipCargos(
    List<(Cargo, Figure)> cargos,
    FigureAxes axis, {
    int direction = 1,
  }) {
    final int Function(Cargo, Cargo) compareCargos = switch (axis) {
      FigureAxes.x => (one, other) => direction > 0
          ? (one.x2 - other.x2).toInt()
          : (other.x1 - one.x1).toInt(),
      FigureAxes.y => (one, other) => direction > 0
          ? (one.y2 - other.y2).toInt()
          : (other.y1 - one.y1).toInt(),
      FigureAxes.z => (one, other) => direction > 0
          ? (one.z2 - other.z2).toInt()
          : (other.z1 - one.z1).toInt(),
    };
    return [...cargos]..sort((one, other) {
        final (oneCargo, _) = one;
        final (otherCargo, _) = other;
        return compareCargos(oneCargo, otherCargo);
      });
  }
}
