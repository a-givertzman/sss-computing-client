import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_figure.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/figure/combined_figure.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/svg_path_figure.dart';
import 'package:sss_computing_client/core/models/frame/frame.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_scheme.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_scheme_view_options.dart';
///
/// Ship schemes with cargos projections on three main planes.
class CargoSchemes extends StatefulWidget {
  final List<Cargo> _cargos;
  final Cargo? _selectedCargo;
  final Map<String, dynamic> _hull;
  final Map<String, dynamic> _hullBeauty;
  final List<Frame> _framesReal;
  final List<Frame> _framesTheoretical;
  final void Function(Cargo cargo)? _onCargoTap;
  ///
  /// Creates widget of ship schemes with cargos projections on three main planes.
  ///
  /// `cargos` - [List] of ship's [Cargo] to be display.
  ///
  /// `framesReal` and `framesTheoretical` are displayed as additional axes
  /// in foreground.
  ///
  /// `hull` and 'hullBeauty' - [Map] with svg path projections of ship's hull
  /// which used to display ship's hull on background.
  ///
  /// `onCargoTap` - called when clicking on rendered cargo.
  const CargoSchemes({
    super.key,
    required List<Cargo> cargos,
    Cargo? selectedCargo,
    required Map<String, dynamic> hull,
    required Map<String, dynamic> hullBeauty,
    required List<Frame> framesReal,
    required List<Frame> framesTheoretical,
    void Function(Cargo)? onCargoTap,
  })  : _cargos = cargos,
        _selectedCargo = selectedCargo,
        _hull = hull,
        _hullBeauty = hullBeauty,
        _framesReal = framesReal,
        _framesTheoretical = framesTheoretical,
        _onCargoTap = onCargoTap;
  //
  @override
  State<CargoSchemes> createState() => _CargoSchemesState();
}
///
class _CargoSchemesState extends State<CargoSchemes> {
  late final Figure _hullFigure;
  late final List<({Figure figure, Cargo cargo})> _cargoFigures;
  late Set<CargoSchemeViewOption> _viewOptions;
  //
  @override
  void initState() {
    _viewOptions = {CargoSchemeViewOption.showGrid};
    _hullFigure = CombinedFigure(
      paints: [
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      ],
      figureOne: SVGPathFigure(
        paints: [],
        pathProjections: {
          FigurePlane.xy: widget._hull['xy'],
          FigurePlane.xz: widget._hull['xz'],
          FigurePlane.yz: widget._hull['yz'],
        },
      ),
      figureTwo: SVGPathFigure(
        paints: [],
        pathProjections: {
          FigurePlane.xy: widget._hullBeauty['xy'],
          FigurePlane.xz: widget._hullBeauty['xz'],
          FigurePlane.yz: widget._hullBeauty['yz'],
        },
      ),
    );
    _cargoFigures = widget._cargos
        .map((cargo) => (
              figure: CargoFigure(cargo: cargo).figure(),
              cargo: cargo,
            ))
        .toList();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    final axis = ChartAxis(
      valueInterval: 10.0,
      isLabelsVisible: _viewOptions.contains(CargoSchemeViewOption.showAxes),
      isGridVisible: _viewOptions.contains(CargoSchemeViewOption.showGrid),
      valueUnit: const Localized('m').v,
    );
    final selectedCargoFigure = widget._selectedCargo != null
        ? (
            cargo: widget._selectedCargo!,
            figure: CargoFigure(cargo: widget._selectedCargo!).figure(),
          )
        : null;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 2),
            SizedBox(width: padding),
            Expanded(
              flex: 3,
              child: CargoSchemeViewOptions(
                initialOptions: _viewOptions,
                onOptionsChanged: (newOptions) => setState(() {
                  _viewOptions = newOptions;
                }),
              ),
            ),
            SizedBox(width: padding),
            const Spacer(flex: 2),
          ],
        ),
        SizedBox(height: blockPadding),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 5,
                      child: CargoScheme(
                        caption: const Localized('Side').v,
                        minX: -65.0,
                        maxX: 65.0,
                        minY: -5.0,
                        maxY: 20.0,
                        xAxis: axis,
                        yAxis: axis,
                        framesTheoretical: _viewOptions.contains(
                          CargoSchemeViewOption.showTheoreticFrames,
                        )
                            ? widget._framesTheoretical
                            : null,
                        framesReal: _viewOptions.contains(
                          CargoSchemeViewOption.showRealFrames,
                        )
                            ? widget._framesReal
                            : null,
                        xAxisReversed: false,
                        yAxisReversed: true,
                        projectionPlane: FigurePlane.xz,
                        hull: _hullFigure,
                        cargoFigures: _SortedFigures(
                          cargoFigures: _cargoFigures,
                          axis: _FigureAxis.y,
                        ).sorted(),
                        onCargoTap: widget._onCargoTap,
                        selectedCargoFigure: selectedCargoFigure,
                      ),
                    ),
                    SizedBox(height: padding),
                    Flexible(
                      flex: 6,
                      child: CargoScheme(
                        caption: const Localized('Top').v,
                        minX: -65.0,
                        maxX: 65.0,
                        minY: -15.0,
                        maxY: 15.0,
                        xAxis: axis,
                        yAxis: axis,
                        framesTheoretical: _viewOptions.contains(
                          CargoSchemeViewOption.showTheoreticFrames,
                        )
                            ? widget._framesTheoretical
                            : null,
                        framesReal: _viewOptions.contains(
                          CargoSchemeViewOption.showRealFrames,
                        )
                            ? widget._framesReal
                            : null,
                        xAxisReversed: false,
                        yAxisReversed: false,
                        projectionPlane: FigurePlane.xy,
                        hull: _hullFigure,
                        cargoFigures: _SortedFigures(
                          cargoFigures: _cargoFigures,
                          axis: _FigureAxis.z,
                        ).sorted(),
                        onCargoTap: widget._onCargoTap,
                        selectedCargoFigure: selectedCargoFigure,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: padding),
              Flexible(
                flex: 1,
                child: CargoScheme(
                  caption:
                      '${const Localized('AFT').v}→${const Localized('FWD').v}',
                  minX: -10.0,
                  maxX: 10.0,
                  minY: -5.0,
                  maxY: 20.0,
                  xAxis: axis,
                  yAxis: axis,
                  xAxisReversed: false,
                  yAxisReversed: true,
                  projectionPlane: FigurePlane.yz,
                  hull: _hullFigure,
                  cargoFigures: _SortedFigures(
                    cargoFigures: _cargoFigures,
                    axis: _FigureAxis.x,
                    ascendingOrder: false,
                  ).sorted(),
                  onCargoTap: widget._onCargoTap,
                  selectedCargoFigure: selectedCargoFigure,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
///
/// Axes of planes on which figures can be drawn.
enum _FigureAxis { x, y, z }
///
/// Object for sorting figures along given axis.
class _SortedFigures {
  final List<({Figure figure, Cargo cargo})> _cargoFigures;
  final _FigureAxis _axis;
  final bool _ascendingOrder;
  ///
  /// Create object for sorting figures along given axis.
  ///
  /// `cargoFigures` - [List] of [Cargo] and its [Figure] for sorting.
  /// `axis` - axis along which figures are sorted
  /// `ascendingOrder` - if true figures are sorted in ascending order
  /// along given axis, and in descending order otherwise.
  const _SortedFigures({
    required List<({Figure figure, Cargo cargo})> cargoFigures,
    required _FigureAxis axis,
    bool ascendingOrder = true,
  })  : _cargoFigures = cargoFigures,
        _axis = axis,
        _ascendingOrder = ascendingOrder;
  ///
  List<({Figure figure, Cargo cargo})> sorted() {
    return List.from(_cargoFigures)
      ..sort((one, other) => _compareCargo(one.cargo, other.cargo));
  }
  //
  int _compareCargo(Cargo one, Cargo other) => switch (_axis) {
        _FigureAxis.x => _ascendingOrder
            ? (one.x2 - other.x2).sign.toInt()
            : (other.x1 - one.x1).sign.toInt(),
        _FigureAxis.y => _ascendingOrder
            ? (one.y2 - other.y2).sign.toInt()
            : (other.y1 - one.y1).sign.toInt(),
        _FigureAxis.z => _ascendingOrder
            ? (one.z2 - other.z2).sign.toInt()
            : (other.z1 - one.z1).sign.toInt(),
      };
}
