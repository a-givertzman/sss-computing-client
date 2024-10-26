import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/criterion/pg_draught_criterions.dart';
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
import 'package:sss_computing_client/presentation/stability/widgets/stability_criterions_list.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
/// Body of drafts page.
class DraftsPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates body of drafts page.
  ///
  ///   [appRefreshStream] – stream with events causing data to be updated.
  ///   [apiAddress] – [ApiAddress] of server that interact with database;
  ///   [dbName] – name of the database;
  ///   [authToken] – string authentication token for accessing server;
  const DraftsPageBody({
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
  State<DraftsPageBody> createState() => _DraftsPageBodyState();
}
///
class _DraftsPageBodyState extends State<DraftsPageBody> {
  DraftType _draftType = DraftType.perpendicular;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      backgroundColor: theme.colorScheme.primary.withOpacity(0.75),
    );
    return FutureBuilderWidget(
      refreshStream: widget._appRefreshStream,
      onFuture: FieldRecord<PathProjections>(
        apiAddress: widget._apiAddress,
        dbName: widget._dbName,
        authToken: widget._authToken,
        tableName: 'ship_geometry',
        fieldName: 'hull_beauty_svg',
        toValue: (value) => JsonSvgPathProjections(
          json: json.decode(value),
        ),
        filter: {'id': 1},
      ).fetch,
      caseData: (context, hullProjections, _) => FutureBuilderWidget(
        onFuture: PgDrafts(
          dbName: widget._dbName,
          apiAddress: widget._apiAddress,
          authToken: widget._authToken,
        ).fetchAll,
        caseData: (context, drafts, _) => FutureBuilderWidget(
          refreshStream: widget._appRefreshStream,
          onFuture: PgHeelTrim(
            dbName: widget._dbName,
            apiAddress: widget._apiAddress,
            authToken: widget._authToken,
          ).fetch,
          caseData: (context, heelTrim, _) => Padding(
            padding: EdgeInsets.all(blockPadding),
            child: Column(
              children: [
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
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
                          SchemeLayout(
                            fit: BoxFit.contain,
                            minX: -65.0,
                            maxX: 65.0,
                            minY: -15.0,
                            maxY: 15.0,
                            yAxisReversed: false,
                            buildContent: (context, transform) => Stack(
                              children: [
                                SchemeFigures(
                                  plane: FigurePlane.xy,
                                  figures: [
                                    RectangularCuboidFigure(
                                      paints: [
                                        Paint()
                                          ..color =
                                              Colors.blue.withOpacity(0.25)
                                          ..style = PaintingStyle.fill,
                                      ],
                                      start: Vector3(-65.0, -15.0, 0.0),
                                      end: Vector3(65.0, 15.0, 0.0),
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
                                      start: Vector3(-65.0, 0.0, 0.0),
                                      end: Vector3(65.0, 0.0, 0.0),
                                    ),
                                  ],
                                  layoutTransform: transform,
                                ),
                                SchemeText(
                                  text: const Localized('PS').v,
                                  offset: const Offset(0.0, -15.0),
                                  alignment: const Alignment(0.0, 2.0),
                                  style: labelStyle,
                                  layoutTransform: transform,
                                ),
                                SchemeText(
                                  text: const Localized('SB').v,
                                  offset: const Offset(0.0, 15.0),
                                  alignment: const Alignment(0.0, -2.0),
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
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: blockPadding),
                Expanded(
                  child: FutureBuilderWidget(
                    refreshStream: widget._appRefreshStream,
                    onFuture: PgDraughtCriterions(
                      dbName: widget._dbName,
                      apiAddress: widget._apiAddress,
                      authToken: widget._authToken,
                    ).fetchAll,
                    caseData: (context, criterions, _) {
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: StabilityCriterionsList(
                            criterions: criterions,
                            title: const Localized('Критерии посадки').v,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
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
          return SchemeText(
            text:
                '$localizedLabel ${draft.value.toStringAsFixed(2)} ${const Localized('m').v}',
            style: style,
            offset: Offset(draft.x, draft.y),
            alignment: Alignment(
              0.0,
              draft.y < 0.0 ? -2.0 : 2.0,
            ),
            layoutTransform: layoutTransform,
          );
        },
      ).toList();
}
