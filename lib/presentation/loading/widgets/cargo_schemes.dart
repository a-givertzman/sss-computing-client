import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
import 'package:sss_computing_client/core/models/chart/chart_axis.dart';
import 'package:sss_computing_client/core/models/figure/combined_figure.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/svg_path_figure.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_scheme.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_scheme_view_options.dart';
import 'package:sss_computing_client/presentation/loading/widgets/cargo_type_dropdown.dart';
///
/// Schemes of ship with cargos with projections on three main planes.
class CargoSchemes extends StatefulWidget {
  final List<Cargo> _cargos;
  final Map<String, dynamic> _hull;
  final Map<String, dynamic> _hullBeauty;
  final void Function(Cargo cargo)? _onCargoTap;
  ///
  const CargoSchemes({
    super.key,
    required List<Cargo> cargos,
    required Map<String, dynamic> hull,
    required Map<String, dynamic> hullBeauty,
    void Function(Cargo)? onCargoTap,
  })  : _cargos = cargos,
        _hull = hull,
        _hullBeauty = hullBeauty,
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
  late String? _cargoType;
  //
  @override
  void initState() {
    _viewOptions = {};
    _cargoType = CargoTypeColorLabel.ballast.label;
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
    _cargoFigures = widget._cargos.map(
      (cargo) {
        final color = CargoType(cargo: cargo).color();
        return (
          figure: SVGPathFigure(
            paints: [
              Paint()
                ..color = color
                ..style = PaintingStyle.stroke,
              Paint()
                ..color = color.withOpacity(0.25)
                ..style = PaintingStyle.fill,
            ],
            pathProjections: {
              FigurePlane.xy: jsonDecode(cargo.path ?? '{}')['xy'],
              FigurePlane.xz: jsonDecode(cargo.path ?? '{}')['xz'],
              FigurePlane.yz: jsonDecode(cargo.path ?? '{}')['yz'],
            },
          ),
          cargo: cargo,
        );
      },
    ).toList();
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
    final cargoFiguresFiltered = _cargoFigures
        .where(
          (cargoFigure) =>
              CargoType(cargo: cargoFigure.cargo).label() == _cargoType,
        )
        .toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: CargoTypeDropdown(
                  initialValue: _cargoType,
                  onTypeChanged: (value) => setState(() {
                    _cargoType = value;
                  }),
                ),
              ),
            ),
            Expanded(
              child: CargoSchemeViewOptions(
                initialOptions: _viewOptions,
                onOptionsChanged: (newOptions) => setState(() {
                  _viewOptions = newOptions;
                }),
              ),
            ),
            const Spacer(),
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
                        minX: -65.0,
                        maxX: 65.0,
                        minY: -5.0,
                        maxY: 20.0,
                        xAxis: axis,
                        yAxis: axis,
                        xAxisReversed: false,
                        yAxisReversed: true,
                        projectionPlane: FigurePlane.xz,
                        hull: _hullFigure,
                        cargoFigures: cargoFiguresFiltered,
                        onCargoTap: widget._onCargoTap,
                      ),
                    ),
                    SizedBox(height: padding),
                    Flexible(
                      flex: 6,
                      child: CargoScheme(
                        minX: -65.0,
                        maxX: 65.0,
                        minY: -15.0,
                        maxY: 15.0,
                        xAxis: axis,
                        yAxis: axis,
                        xAxisReversed: false,
                        yAxisReversed: true,
                        projectionPlane: FigurePlane.xy,
                        hull: _hullFigure,
                        cargoFigures: cargoFiguresFiltered,
                        onCargoTap: widget._onCargoTap,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: padding),
              Flexible(
                flex: 1,
                child: CargoScheme(
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
                  cargoFigures: cargoFiguresFiltered,
                  onCargoTap: widget._onCargoTap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
