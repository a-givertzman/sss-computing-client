import 'dart:convert';
import 'dart:math';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/figure/line_segment_figure.dart';
import 'package:sss_computing_client/core/models/figure/path_projections_figure.dart';
import 'package:sss_computing_client/core/models/figure/transformed_projection_figure.dart';
import 'package:sss_computing_client/core/models/heel_trim/pg_heel_trim.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figures.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
/// Shows ship hull and its drafts with heel and trim.
class ShipDraughtsScheme extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates widget that showing ship hull
  /// and its drafts with heel and trim.
  const ShipDraughtsScheme({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required ApiAddress apiAddress,
    required String dbName,
    required String? authToken,
  })  : _appRefreshStream = appRefreshStream,
        _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Widget build(BuildContext context) {
    final shipId = const Setting('shipId').toInt;
    final minX = const Setting('shipMinWithGapX_m').toDouble;
    final maxX = const Setting('shipMaxWithGapX_m').toDouble;
    final minY = const Setting('shipMinWithGapY_m').toDouble;
    final maxY = const Setting('shipMaxWithGapY_m').toDouble;
    final minZ = const Setting('shipMinWithGapZ_m').toDouble;
    final maxZ = const Setting('shipMaxWithGapZ_m').toDouble;
    final draftGapZ = const Setting('shipDraftGap_m').toDouble;
    final schemeGap = const Setting('shipSchemeGap_m').toDouble;
    final padding = const Setting('padding').toDouble;
    return FutureBuilderWidget(
      refreshStream: _appRefreshStream,
      onFuture: FieldRecord<PathProjections>(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
        tableName: 'ship_geometry',
        fieldName: 'hull_beauty_svg',
        toValue: (value) => JsonSvgPathProjections(
          json: json.decode(value),
        ),
        filter: {'id': shipId},
      ).fetch,
      caseData: (context, hullProjections, _) {
        return FutureBuilderWidget(
          refreshStream: _appRefreshStream,
          onFuture: PgHeelTrim(
            dbName: _dbName,
            apiAddress: _apiAddress,
            authToken: _authToken,
          ).fetch,
          caseData: (context, heelTrim, _) {
            final draught = heelTrim.draftAvg.value;
            final massShiftX = heelTrim.draftAvg.offset;
            final trimAngle = heelTrim.trim;
            final heelAngle = heelTrim.heel;
            final shipBody = PathProjectionsFigure(
              paints: [
                Paint()
                  ..color = Colors.grey
                  ..style = PaintingStyle.fill,
              ],
              pathProjections: hullProjections,
            );
            final waterlineFigure = RectangularCuboidFigure(
              start: Vector3(minX * 2, minY * 2, (minZ - draftGapZ) * 2),
              end: Vector3(maxX * 2, maxY * 2, 0.0),
              paints: [
                Paint()
                  ..color = Colors.blue.withOpacity(0.25)
                  ..style = PaintingStyle.fill,
                Paint()
                  ..color = Colors.blue
                  ..style = PaintingStyle.stroke,
              ],
            );
            final trimTransform = Matrix4.identity()
              ..translate(0.0, -draught)
              ..translate(massShiftX, draught)
              ..rotateZ(-degrees2Radians * trimAngle)
              ..translate(-massShiftX, -draught);
            final heelTransform = Matrix4.identity()
              ..translate(0.0, -draught)
              ..translate(0.0, draught)
              ..rotateZ(-degrees2Radians * heelAngle)
              ..translate(0.0, -draught);
            final theme = Theme.of(context);
            final labelStyle = theme.textTheme.labelLarge?.copyWith(
              backgroundColor: theme.colorScheme.primary,
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: SchemeLayout(
                    fit: BoxFit.contain,
                    minX: minY,
                    maxX: maxY,
                    minY: minZ - draftGapZ,
                    maxY: maxZ,
                    yAxisReversed: true,
                    buildContent: (ctx, transform) => Stack(
                      children: [
                        SchemeFigures(
                          plane: FigurePlane.yz,
                          figures: [
                            TransformedProjectionFigure(
                              figure: shipBody,
                              transform: heelTransform,
                            ),
                            waterlineFigure,
                            TransformedProjectionFigure(
                              figure: LineSegmentFigure(
                                start: Offset(minY * 2, 0.0),
                                end: Offset(maxY * 2, 0.0),
                                paints: [
                                  Paint()
                                    ..color = Colors.white
                                    ..style = PaintingStyle.stroke,
                                ],
                              ),
                              transform: heelTransform,
                            ),
                          ],
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text:
                              '${const Localized('Heel').v} ${heelAngle.toStringAsFixed(2)}${const Localized('deg').v}',
                          alignment: Alignment.bottomCenter,
                          offset: Offset(
                            minY + (maxY - minY) / 2,
                            maxZ - schemeGap,
                          ),
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text: const Localized('PS').v,
                          offset: Offset(
                            minY + schemeGap,
                            minZ - draftGapZ + schemeGap,
                          ),
                          alignment: Alignment.topRight,
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text: const Localized('SB').v,
                          offset: Offset(
                            maxY - schemeGap,
                            minZ - draftGapZ + schemeGap,
                          ),
                          alignment: Alignment.topLeft,
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        _DraughtLabel(
                          draught: draught,
                          draughtShift: 0.0,
                          massShift: 0.0,
                          angle: heelAngle,
                          layoutTransform: transform,
                          draughtsTransform: heelTransform,
                          label:
                              '${heelTrim.draftAvg.value.toStringAsFixed(2)} ${const Localized('m').v}',
                          labelStyle: labelStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: padding),
                Flexible(
                  flex: 5,
                  child: SchemeLayout(
                    fit: BoxFit.contain,
                    minX: minX,
                    maxX: maxX,
                    minY: minZ - draftGapZ,
                    maxY: maxZ,
                    yAxisReversed: true,
                    buildContent: (ctx, transform) => Stack(
                      children: [
                        SchemeFigures(
                          plane: FigurePlane.xz,
                          figures: [
                            TransformedProjectionFigure(
                              figure: shipBody,
                              transform: trimTransform,
                            ),
                            waterlineFigure,
                            TransformedProjectionFigure(
                              figure: LineSegmentFigure(
                                start: Offset(minX * 2, 0.0),
                                end: Offset(maxX * 2, 0.0),
                                paints: [
                                  Paint()
                                    ..color = Colors.white
                                    ..style = PaintingStyle.stroke,
                                ],
                              ),
                              transform: trimTransform,
                            ),
                          ],
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text:
                              '${const Localized('Trim').v} ${trimAngle.toStringAsFixed(2)}${const Localized('deg').v}',
                          alignment: Alignment.bottomCenter,
                          offset: Offset(
                            minX + (maxX - minX) / 2,
                            maxZ - schemeGap,
                          ),
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text: const Localized('AFT').v,
                          offset: Offset(
                            minX + schemeGap,
                            minZ - draftGapZ + schemeGap,
                          ),
                          alignment: Alignment.topRight,
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text: const Localized('FWD').v,
                          offset: Offset(
                            maxX - schemeGap,
                            minZ - draftGapZ + schemeGap,
                          ),
                          alignment: Alignment.topLeft,
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        _DraughtLabel(
                          draught: draught,
                          draughtShift: heelTrim.draftAP.offset,
                          massShift: massShiftX,
                          angle: trimAngle,
                          layoutTransform: transform,
                          draughtsTransform: trimTransform,
                          label:
                              '${const Localized('AP').v} ${heelTrim.draftAP.value.toStringAsFixed(2)} ${const Localized('m').v}',
                          labelStyle: labelStyle,
                        ),
                        _DraughtLabel(
                          draught: draught,
                          draughtShift: heelTrim.draftAvg.offset,
                          massShift: massShiftX,
                          angle: trimAngle,
                          layoutTransform: transform,
                          draughtsTransform: trimTransform,
                          label:
                              '${const Localized('Avg').v} ${heelTrim.draftAvg.value.toStringAsFixed(2)} ${const Localized('m').v}',
                          labelStyle: labelStyle,
                        ),
                        _DraughtLabel(
                          draught: draught,
                          draughtShift: heelTrim.draftFP.offset,
                          massShift: massShiftX,
                          angle: trimAngle,
                          layoutTransform: transform,
                          draughtsTransform: trimTransform,
                          label:
                              '${const Localized('FP').v} ${heelTrim.draftFP.value.toStringAsFixed(2)} ${const Localized('m').v}',
                          labelStyle: labelStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
///
class _DraughtLabel extends StatelessWidget {
  final double draught;
  final double draughtShift;
  final double massShift;
  final double angle;
  final Matrix4 layoutTransform;
  final Matrix4 draughtsTransform;
  final String label;
  final TextStyle? labelStyle;
  ///
  const _DraughtLabel({
    required this.draught,
    required this.draughtShift,
    required this.massShift,
    required this.angle,
    required this.layoutTransform,
    required this.draughtsTransform,
    required this.label,
    this.labelStyle,
  });
  @override
  Widget build(BuildContext context) {
    final radians = -degrees2Radians * angle;
    final dy = tan(radians) * (draughtShift - massShift);
    final cosine = cos(radians);
    final dx = cosine != 0.0 ? draughtShift / cosine : 0.0;
    return Stack(
      children: [
        SchemeFigure(
          plane: FigurePlane.xz,
          figure: TransformedProjectionFigure(
            figure: LineSegmentFigure(
              paints: [
                Paint()
                  ..color = Colors.white
                  ..style = PaintingStyle.stroke,
              ],
              start: Offset(dx, 0.0),
              end: Offset(dx, draught - dy),
            ),
            transform: draughtsTransform,
          ),
          layoutTransform: layoutTransform,
        ),
        SchemeText(
          text: label,
          offset: Offset(dx, 0.0),
          alignment: const Alignment(0.0, -2.0),
          layoutTransform: layoutTransform,
          style: labelStyle,
        ),
      ],
    );
  }
}
