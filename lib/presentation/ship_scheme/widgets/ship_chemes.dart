import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/ship_scheme/chart_axis.dart';
import 'package:sss_computing_client/core/models/ship_scheme/figure.dart';
import 'package:sss_computing_client/core/widgets/buttons/dropdown_multiselect_button.dart';
import 'package:sss_computing_client/core/widgets/buttons/segmented_button_options.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/figures_test.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme_test.dart';
///
class ShipSchemes extends StatefulWidget {
  final ShipCargoModel _shipCargoNotifier;
  ///
  const ShipSchemes({
    super.key,
    required ShipCargoModel shipCargoNotifier,
  }) : _shipCargoNotifier = shipCargoNotifier;
  ///
  @override
  State<ShipSchemes> createState() => _ShipSchemesState(
        shipCargoNotifier: _shipCargoNotifier,
      );
}
///
class _ShipSchemesState extends State<ShipSchemes> {
  final ShipCargoModel _shipCargoNotifier;
  Set<_ShipSchemeViewOptions> _viewOptions = _initialViewOptions;
  Set<_ShipSchemeInteractOptions> _interactOptions = _initialInteractOptions;
  Map<String, bool> _cargoTypeFilter = {
    'BALLAST': true,
    'FRESH_WATER': false,
    'OILS_AND_FUELS': false,
    'ACIDS_AND_ALKALIS': false,
    'POLLUTED_LIQUIDS': false,
    'CARGO': false,
  };
  static const _axesSpaceReserved = 25.0;
  late final Figure _body;
  late final Figure? _bodyPretty;
  late final List<(double, double, int)> _framesTheoretic;
  late final List<(double, int)> _framesReal;
  static const _frameTNumber = 20;
  static const _frameRNumber = 100;
  static const _framesRealIdxShift = -10;
  late int _defaultRFrameIdx;
  ///
  _ShipSchemesState({
    required ShipCargoModel shipCargoNotifier,
  }) : _shipCargoNotifier = shipCargoNotifier;
  //
  @override
  // ignore: long-method
  void initState() {
    _body = shipBody;
    _bodyPretty = shipBodyPretty;
    final shipLeft = _body
        .getOrthoProjection(
          FigureAxes.x,
          FigureAxes.z,
        )
        .getBounds()
        .left;
    final shipRight = _body
        .getOrthoProjection(
          FigureAxes.x,
          FigureAxes.z,
        )
        .getBounds()
        .right;
    _framesTheoretic = List<(double, double, int)>.generate(
      _frameTNumber,
      (index) {
        final width = (shipRight - shipLeft) / _frameTNumber;
        return (
          shipLeft + index * width,
          shipLeft + (index + 1) * width,
          index,
        );
      },
    );
    _framesReal = [
      ...List<(double, int)>.generate(25, (index) {
        final width = (shipRight - shipLeft) / 2 / _frameRNumber;
        return (shipLeft + index * width, index + _framesRealIdxShift);
      }),
      ...List<(double, int)>.generate(25, (index) {
        final width = (shipRight - shipLeft) / _frameRNumber;
        return (
          shipLeft +
              ((shipRight - shipLeft) / 2 / _frameRNumber) * 25 +
              (index) * width,
          index + 25 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(50, (index) {
        final width = (shipRight - shipLeft) / 2 / _frameRNumber;
        return (
          shipLeft +
              ((shipRight - shipLeft) / 2 / _frameRNumber) * 25 +
              ((shipRight - shipLeft) / _frameRNumber) * 25 +
              (index) * width,
          index + 50 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        final width = (shipRight - shipLeft) / _frameRNumber;
        return (
          shipLeft +
              ((shipRight - shipLeft) / 2 / _frameRNumber) * 75 +
              ((shipRight - shipLeft) / _frameRNumber) * 25 +
              (index) * width,
          index + 100 + _framesRealIdxShift,
        );
      }),
      ...List<(double, int)>.generate(25, (index) {
        final width = (shipRight - shipLeft) / 2 / _frameRNumber;
        return (
          shipLeft +
              ((shipRight - shipLeft) / 2 / _frameRNumber) * 25 +
              ((shipRight - shipLeft) / _frameRNumber) * 75 +
              (index) * width,
          index + 125 + _framesRealIdxShift,
        );
      }),
    ];
    _defaultRFrameIdx = (_framesReal.length / 2.0).ceil();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _shipCargoNotifier,
      builder: (context, _) {
        final padding = const Setting('padding').toDouble;
        final xAxis = ChartAxis(
          caption: const Localized('m').v,
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showAxes,
          ),
          valueInterval: 10.0,
          isGridVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showGrid,
          ),
        );
        final yAxis = ChartAxis(
          caption: const Localized('m').v,
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showAxes,
          ),
          valueInterval: 5.0,
          isGridVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showGrid,
          ),
        );
        final zAxis = ChartAxis(
          caption: const Localized('m').v,
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showAxes,
          ),
          valueInterval: 5.0,
          isGridVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showGrid,
          ),
        );
        final framesRealAxis = ChartAxis(
          caption: const Localized('F').v,
          labelsSpaceReserved: _axesSpaceReserved,
          isLabelsVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showRealFrames,
          ),
          valueInterval: 10.0,
        );
        final framesTheoreticAxis = ChartAxis(
          caption: const Localized('FT').v,
          labelsSpaceReserved: _axesSpaceReserved / 2.0,
          isLabelsVisible: _viewOptions.contains(
            _ShipSchemeViewOptions.showTheoreticFrames,
          ),
        );
        final cargos = _shipCargoNotifier.cargos.where((cargo) {
          if (_cargoTypeFilter.containsKey(cargo.type)) {
            return _cargoTypeFilter[cargo.type]!;
          }
          return false;
        }).toList();
        final cargoFigures = _mapCargosToFigures(cargos, shipBody);
        final selectedCargo = _shipCargoNotifier.selectedCargo;
        final selectedCargoFigures = _mapCargosToFigures(
          [if (selectedCargo != null) selectedCargo],
          _body,
          borderColor: Colors.amber,
          fillColor: Colors.amber.withOpacity(0.25),
        );
        final currentRealFrameIdx = selectedCargo != null
            ? _getCargoRealFrameIdx(selectedCargo) ?? _defaultRFrameIdx
            : _defaultRFrameIdx;
        final sectionedCargoFigures = _extractCargosFromSection(
          cargoFigures,
          _framesReal[currentRealFrameIdx].$1,
        );
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildControlsWidget(),
            SizedBox(height: padding * 2),
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
                          child: _buildSideViewWiget(
                            (xAxis, zAxis),
                            framesRealAxis,
                            framesTheoreticAxis,
                            (cargoFigures, selectedCargoFigures),
                          ),
                        ),
                        SizedBox(height: padding),
                        Flexible(
                          flex: 1,
                          child: _buildTopViewWidget(
                            (xAxis, yAxis),
                            framesRealAxis,
                            framesTheoreticAxis,
                            (cargoFigures, selectedCargoFigures),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: padding),
                  Flexible(
                    flex: 1,
                    child: _buildFrontViewWidget(
                      (yAxis, zAxis),
                      framesRealAxis,
                      framesTheoreticAxis,
                      (sectionedCargoFigures, selectedCargoFigures),
                      currentRealFrameIdx,
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
  Widget _buildControlsWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: DropdownMultiselectButton(
              itemHeight: 50.0,
              label: const Localized('Cargo types').v,
              items: _cargoTypeFilter,
              onChanged: (newFilter) => setState(() {
                _cargoTypeFilter = newFilter;
              }),
            ),
          ),
        ),
        _ViewOptions(
          initialOptions: _initialViewOptions,
          onOptionsChanged: (options) => setState(() {
            _viewOptions = options;
          }),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: _InteractOptions(
              initialOptions: _interactOptions,
              onOptionsChanged: (options) => setState(() {
                _interactOptions = options;
              }),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildSideViewWiget(
    (ChartAxis, ChartAxis) axes,
    ChartAxis framesRealAxis,
    ChartAxis framesTheoreticAxis,
    (List<(Cargo, Figure)>, List<(Cargo, Figure)>) cargoFigures,
  ) {
    final (xAxis, zAxis) = axes;
    final (allCargoFigures, selectedCargoFigures) = cargoFigures;
    return ShipScheme(
      valuesPadding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 5.0),
      caption: const Localized('Side View').v,
      projection: (FigureAxes.x, FigureAxes.z),
      xAxis: xAxis,
      invertHorizontal: false,
      yAxis: zAxis,
      invertVertical: true,
      framesReal: _framesReal,
      framesRealAxis: framesRealAxis,
      framesTheoretic: _framesTheoretic,
      framesTheoreticAxis: framesTheoreticAxis,
      shipBody: _body,
      shipBodyPretty: _bodyPretty,
      cargos: _getSortedCargos(allCargoFigures, FigureAxes.y),
      onCargoTap: (cargo) => _shipCargoNotifier.toggleSelected(cargo),
      selectedCargos: _getSortedCargos(selectedCargoFigures, FigureAxes.y),
      isViewInteractive: _interactOptions.contains(
        _ShipSchemeInteractOptions.view,
      ),
      fit: BoxFit.fitWidth,
    );
  }
  Widget _buildTopViewWidget(
    (ChartAxis, ChartAxis) axes,
    ChartAxis framesRealAxis,
    ChartAxis framesTheoreticAxis,
    (List<(Cargo, Figure)>, List<(Cargo, Figure)>) cargoFigures,
  ) {
    final (xAxis, yAxis) = axes;
    final (allCargoFigures, selectedCargoFigures) = cargoFigures;
    return ShipScheme(
      valuesPadding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
      caption: const Localized('Top View').v,
      projection: (FigureAxes.x, FigureAxes.y),
      xAxis: xAxis,
      invertHorizontal: false,
      yAxis: yAxis,
      invertVertical: false,
      framesReal: _framesReal,
      framesRealAxis: framesRealAxis,
      framesTheoretic: _framesTheoretic,
      framesTheoreticAxis: framesTheoreticAxis,
      shipBody: _body,
      shipBodyPretty: _bodyPretty,
      cargos: _getSortedCargos(allCargoFigures, FigureAxes.z),
      onCargoTap: (cargo) => _shipCargoNotifier.toggleSelected(cargo),
      selectedCargos: _getSortedCargos(selectedCargoFigures, FigureAxes.z),
      isViewInteractive: _interactOptions.contains(
        _ShipSchemeInteractOptions.view,
      ),
      fit: BoxFit.fitWidth,
    );
  }
  Widget _buildFrontViewWidget(
    (ChartAxis, ChartAxis) axes,
    ChartAxis framesRealAxis,
    ChartAxis framesTheoreticAxis,
    (List<(Cargo, Figure)>, List<(Cargo, Figure)>) cargoFigures,
    int frameIdx,
  ) {
    final (yAxis, zAxis) = axes;
    final (allCargoFigures, selectedCargoFigures) = cargoFigures;
    return ShipScheme(
      valuesPadding: const EdgeInsets.all(1.0),
      caption:
          '${frameIdx + _framesRealIdxShift} ${const Localized('Fr. AFT→FWD').v}',
      projection: (FigureAxes.y, FigureAxes.z),
      xAxis: yAxis,
      invertHorizontal: true,
      yAxis: zAxis,
      invertVertical: true,
      framesReal: _framesReal,
      framesRealAxis: const ChartAxis(isLabelsVisible: false),
      framesTheoretic: _framesTheoretic,
      framesTheoreticAxis: const ChartAxis(isLabelsVisible: false),
      shipBody: _body,
      shipBodyPretty: _bodyPretty,
      cargos: _getSortedCargos(allCargoFigures, FigureAxes.x),
      onCargoTap: (cargo) => _shipCargoNotifier.toggleSelected(cargo),
      selectedCargos: _getSortedCargos(selectedCargoFigures, FigureAxes.x),
      isViewInteractive: _interactOptions.contains(
        _ShipSchemeInteractOptions.view,
      ),
      fit: BoxFit.contain,
    );
  }
  int? _getCargoRealFrameIdx(Cargo cargo) {
    final frameIndex = _framesReal.indexWhere((frame) {
      final (offset, _) = frame;
      final (leftBound, rightBound) = (cargo.x1, cargo.x2);
      return offset >= leftBound && offset <= rightBound;
    });
    return frameIndex != -1 ? frameIndex : null;
  }
  List<(Cargo, Figure)> _mapCargosToFigures(
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
          SVGPathFigure(
            borderColor: borderColor ?? mapCargoToColor(cargo),
            fillColor: fillColor ?? mapCargoToColor(cargo).withOpacity(0.15),
            projectionPath: {
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
            dx1: cargo.x1, dx2: cargo.x2, //
            dy1: cargo.y1, dy2: cargo.y2, //
            dz1: cargo.z1, dz2: cargo.z2, //
          ),
          bounder: bounder,
        )
      );
    }).toList();
  }
  List<(Cargo, Figure)> _extractCargosFromSection(
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
  List<(Cargo, Figure)> _getSortedCargos(
    List<(Cargo, Figure)> cargos,
    FigureAxes axis, {
    int direction = 1,
  }) {
    final int Function(Cargo, Cargo) compareCargos = switch (axis) {
      FigureAxes.x => (one, other) => direction > 0
          ? (one.x2 - other.x2).sign.toInt()
          : (other.x1 - one.x1).sign.toInt(),
      FigureAxes.y => (one, other) => direction > 0
          ? (one.y2 - other.y2).sign.toInt()
          : (other.y1 - one.y1).sign.toInt(),
      FigureAxes.z => (one, other) => direction > 0
          ? (one.z2 - other.z2).sign.toInt()
          : (other.z1 - one.z1).sign.toInt(),
    };
    return List.from(cargos)
      ..sort((one, other) {
        final (oneCargo, _) = one;
        final (otherCargo, _) = other;
        return compareCargos(oneCargo, otherCargo);
      });
  }
}
///
class _ViewOptions extends StatelessWidget {
  final Set<_ShipSchemeViewOptions> initialOptions;
  final void Function(Set<_ShipSchemeViewOptions>) onOptionsChanged;
  ///
  const _ViewOptions({
    required this.initialOptions,
    required this.onOptionsChanged,
  });
  ///
  @override
  Widget build(BuildContext context) {
    return SegmentedButtonOptions<_ShipSchemeViewOptions>(
      multiSelectionEnabled: true,
      emptySelectionEnabled: true,
      initialOptions: initialOptions,
      availableOptions: {
        _ShipSchemeViewOptions.showAxes: SegmentedButtonOption(
          label: const Localized('Axes').v,
          tooltip: const Localized('Show axes').v,
          icon: Icons.merge,
        ),
        _ShipSchemeViewOptions.showGrid: SegmentedButtonOption(
          label: const Localized('Grid').v,
          tooltip: const Localized('Show grid').v,
          icon: Icons.grid_4x4,
        ),
        _ShipSchemeViewOptions.showRealFrames: SegmentedButtonOption(
          label: const Localized('Fr. R.').v,
          tooltip: const Localized('Show real frames').v,
          icon: Icons.horizontal_distribute_outlined,
        ),
        _ShipSchemeViewOptions.showTheoreticFrames: SegmentedButtonOption(
          label: const Localized('Fr. Th.').v,
          tooltip: const Localized('Show theoretic frames').v,
          icon: Icons.horizontal_distribute_outlined,
        ),
      },
      onOptionsChanged: onOptionsChanged,
    );
  }
}
///
class _InteractOptions extends StatelessWidget {
  final Set<_ShipSchemeInteractOptions> initialOptions;
  final void Function(Set<_ShipSchemeInteractOptions>) onOptionsChanged;
  ///
  const _InteractOptions({
    required this.initialOptions,
    required this.onOptionsChanged,
  });
  ///
  @override
  Widget build(BuildContext context) {
    return SegmentedButtonOptions<_ShipSchemeInteractOptions>(
      initialOptions: initialOptions,
      availableOptions: {
        _ShipSchemeInteractOptions.view: SegmentedButtonOption(
          icon: Icons.open_with,
          tooltip: const Localized('View tool').v,
        ),
        _ShipSchemeInteractOptions.select: SegmentedButtonOption(
          icon: Icons.highlight_alt_outlined,
          tooltip: const Localized('Select tool').v,
        ),
      },
      onOptionsChanged: onOptionsChanged,
    );
  }
}
///
enum _ShipSchemeViewOptions {
  showAxes,
  showGrid,
  showRealFrames,
  showTheoreticFrames,
}
///
const Set<_ShipSchemeViewOptions> _initialViewOptions = {
  _ShipSchemeViewOptions.showGrid,
  _ShipSchemeViewOptions.showAxes,
};
///
enum _ShipSchemeInteractOptions {
  view,
  select,
}
///
const Set<_ShipSchemeInteractOptions> _initialInteractOptions = {
  _ShipSchemeInteractOptions.select,
};
