import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/draft/draft.dart';
import 'package:sss_computing_client/core/models/draft/pg_drafts.dart';
import 'package:sss_computing_client/core/models/figure/figure_plane.dart';
import 'package:sss_computing_client/core/models/figure/json_svg_path_projections.dart';
import 'package:sss_computing_client/core/models/figure/line_segment_3d_figure.dart';
import 'package:sss_computing_client/core/models/figure/path_projections.dart';
import 'package:sss_computing_client/core/models/figure/path_projections_figure.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/heel_trim/heel_trim.dart';
import 'package:sss_computing_client/core/models/heel_trim/pg_heel_trim.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figures.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/draft_type.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/draft_type_dropdown.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
/// Widget that displays drafts on scheme with ship.
class DraftScheme extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  /// Creates widget that displays drafts on scheme with ship.
  ///
  /// * [appRefreshStream] – stream with events causing data to be updated.
  const DraftScheme({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
  //
  @override
  State<DraftScheme> createState() => _DraftSchemeState();
}
///
class _DraftSchemeState extends State<DraftScheme> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  late DraftType _draftType;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
    _draftType = DraftType.perpendicular;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final shipId = const Setting('shipId').toInt;
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      backgroundColor: theme.colorScheme.primary,
    );
    final minX = const Setting('shipMinWithGapX_m').toDouble;
    final maxX = const Setting('shipMaxWithGapX_m').toDouble;
    final minY = const Setting('shipMinWithGapY_m').toDouble;
    final maxY = const Setting('shipMaxWithGapY_m').toDouble;
    final schemeGap = const Setting('shipSchemeGap_m').toDouble;
    return FutureBuilderWidget(
      refreshStream: widget._appRefreshStream,
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
      caseData: (context, hullProjections, _) => FutureBuilderWidget(
        onFuture: PgDrafts(
          dbName: _dbName,
          apiAddress: _apiAddress,
          authToken: _authToken,
        ).fetchAll,
        caseData: (context, drafts, _) => FutureBuilderWidget(
          refreshStream: widget._appRefreshStream,
          onFuture: PgHeelTrim(
            dbName: _dbName,
            apiAddress: _apiAddress,
            authToken: _authToken,
          ).fetch,
          caseData: (context, heelTrim, _) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    const Localized('Drafts').v,
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(
                    width: 300.0,
                    child: DraftTypeDropdown(
                      initialValue: _draftType,
                      onValueChanged: (value) => setState(() {
                        _draftType = value;
                      }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              Expanded(
                child: Center(
                  child: SchemeLayout(
                    fit: BoxFit.contain,
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    yAxisReversed: false,
                    buildContent: (context, transform) => Stack(
                      children: [
                        SchemeFigures(
                          plane: FigurePlane.xy,
                          figures: [
                            RectangularCuboidFigure(
                              paints: [
                                Paint()
                                  ..color = Colors.blue.withOpacity(0.25)
                                  ..style = PaintingStyle.fill,
                              ],
                              start: Vector3(minX * 2, minY * 2, 0.0),
                              end: Vector3(maxX * 2, maxY * 2, 0.0),
                            ),
                            PathProjectionsFigure(
                              paints: [
                                Paint()
                                  ..color = Colors.grey
                                  ..style = PaintingStyle.fill,
                                Paint()
                                  ..color = Colors.white
                                  ..strokeWidth = 2.0
                                  ..style = PaintingStyle.stroke,
                              ],
                              pathProjections: hullProjections,
                            ),
                            LineSegment3DFigure(
                              paints: [
                                Paint()
                                  ..color = Colors.white
                                  ..strokeWidth = 2.0
                                  ..style = PaintingStyle.stroke,
                              ],
                              start: Vector3(minX, 0.0, 0.0),
                              end: Vector3(maxX, 0.0, 0.0),
                            ),
                          ],
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text: const Localized('PS').v,
                          offset: Offset(
                            minX + (maxX - minX) / 2.0,
                            minY + schemeGap,
                          ),
                          alignment: Alignment.bottomCenter,
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        SchemeText(
                          text: const Localized('SB').v,
                          offset: Offset(
                            minX + (maxX - minX) / 2.0,
                            maxY - schemeGap,
                          ),
                          alignment: Alignment.topCenter,
                          style: labelStyle,
                          layoutTransform: transform,
                        ),
                        if (_draftType == DraftType.perpendicular)
                          ..._buildPerpendicularDraftLabels(
                            heelTrim: heelTrim,
                            style: labelStyle,
                            layoutTransform: transform,
                          ),
                        if (_draftType == DraftType.marks)
                          ..._buildMarksDraftLabels(
                            drafts: drafts,
                            style: labelStyle,
                            layoutTransform: transform,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //
  List<SchemeText> _buildPerpendicularDraftLabels({
    required HeelTrim heelTrim,
    required TextStyle? style,
    required Matrix4 layoutTransform,
  }) =>
      [
        SchemeText(
          text:
              '${const Localized('AP').v} ${heelTrim.draftAP.value.toStringAsFixed(2)} ${const Localized('m').v}',
          offset: Offset(heelTrim.draftAP.offset, 0.0),
          style: style,
          layoutTransform: layoutTransform,
        ),
        SchemeText(
          text:
              '${const Localized('Avg').v} ${heelTrim.draftAvg.value.toStringAsFixed(2)} ${const Localized('m').v}',
          offset: Offset(heelTrim.draftAvg.offset, 0.0),
          style: style,
          layoutTransform: layoutTransform,
        ),
        SchemeText(
          text:
              '${const Localized('FP').v} ${heelTrim.draftFP.value.toStringAsFixed(2)} ${const Localized('m').v}',
          offset: Offset(heelTrim.draftFP.offset, 0.0),
          style: style,
          layoutTransform: layoutTransform,
        ),
      ];
  //
  List<SchemeText> _buildMarksDraftLabels({
    required List<Draft> drafts,
    required TextStyle? style,
    required Matrix4 layoutTransform,
  }) =>
      drafts.map(
        (draft) {
          final String localizedLabel =
              draft.label.split(' ').map((word) => Localized(word).v).join(' ');
          final String? value = draft.value?.toStringAsFixed(2);
          return SchemeText(
            text:
                '$localizedLabel ${value != null ? '$value ${const Localized('m').v}' : '—'}',
            style: style,
            offset: Offset(draft.x, draft.y),
            alignment: Alignment.center,
            layoutTransform: layoutTransform,
          );
        },
      ).toList();
}
