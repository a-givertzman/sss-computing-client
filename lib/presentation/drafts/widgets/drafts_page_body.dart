import 'dart:convert';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/draft/draft.dart';
import 'package:sss_computing_client/core/models/draft/pg_drafts.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/line_segment_3d_figure.dart';
import 'package:sss_computing_client/core/models/figure/rectangular_cuboid_figure.dart';
import 'package:sss_computing_client/core/models/figure/svg_path_figure.dart';
import 'package:sss_computing_client/core/models/heel_trim/pg_heel_trim.dart';
import 'package:sss_computing_client/core/models/record/field_record.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figures.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
///
class DraftsPageBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
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
  @override
  State<DraftsPageBody> createState() => _DraftsPageBodyState();
}
class _DraftsPageBodyState extends State<DraftsPageBody> {
  int _draftTypeIndex = 0;
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilderWidget(
      refreshStream: widget._appRefreshStream,
      onFuture: FieldRecord<Map<String, dynamic>>(
        tableName: 'ship_parameters',
        fieldName: 'value',
        dbName: widget._dbName,
        apiAddress: widget._apiAddress,
        authToken: widget._authToken,
        toValue: (value) => jsonDecode(value),
        filter: {'key': 'hull_beauty_svg'},
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
          caseData: (context, heelTrim, _) {
            final theme = Theme.of(context);
            final padding = const Setting('padding').toDouble;
            final blockPadding = const Setting('blockPadding').toDouble;
            final labelStyle = theme.textTheme.labelLarge?.copyWith(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.75),
            );
            return Padding(
              padding: EdgeInsets.all(blockPadding),
              child: Column(
                children: [
                  Card(
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
                                const Localized('Осадка').v,
                                style: theme.textTheme.bodyLarge,
                              ),
                              SizedBox(
                                width: 300.0,
                                child: _DraftTypeDropdown(
                                  initialValue: _draftTypeIndex,
                                  onTypeChanged: (newType) => setState(() {
                                    _draftTypeIndex = newType;
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
                                    SVGPathFigure(
                                      paints: [
                                        Paint()
                                          ..color = Colors.grey
                                          ..style = PaintingStyle.fill,
                                        Paint()
                                          ..color = Colors.white
                                          ..strokeWidth = 2.0
                                          ..style = PaintingStyle.stroke,
                                      ],
                                      pathProjections: {
                                        FigurePlane.xy: hullProjections['xy'],
                                        FigurePlane.xz: hullProjections['xz'],
                                        FigurePlane.yz: hullProjections['yz'],
                                      },
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
                                  offset: const Offset(0.0, 15.0),
                                  alignment: const Alignment(0.0, 2.0),
                                  style: labelStyle,
                                  layoutTransform: transform,
                                ),
                                SchemeText(
                                  text: const Localized('SB').v,
                                  offset: const Offset(0.0, -15.0),
                                  alignment: const Alignment(0.0, -2.0),
                                  style: labelStyle,
                                  layoutTransform: transform,
                                ),
                                if (_draftTypeIndex == 0) ...[
                                  SchemeText(
                                    text:
                                        '${const Localized('AP').v} ${heelTrim.draftAP.value.toStringAsFixed(2)} ${const Localized('m').v}',
                                    offset:
                                        Offset(heelTrim.draftAP.offset, 0.0),
                                    style: labelStyle,
                                    layoutTransform: transform,
                                  ),
                                  SchemeText(
                                    text:
                                        '${const Localized('Avg').v} ${heelTrim.draftAvg.value.toStringAsFixed(2)} ${const Localized('m').v}',
                                    offset:
                                        Offset(heelTrim.draftAvg.offset, 0.0),
                                    style: labelStyle,
                                    layoutTransform: transform,
                                  ),
                                  SchemeText(
                                    text:
                                        '${const Localized('FP').v} ${heelTrim.draftFP.value.toStringAsFixed(2)} ${const Localized('m').v}',
                                    offset:
                                        Offset(heelTrim.draftFP.offset, 0.0),
                                    style: labelStyle,
                                    layoutTransform: transform,
                                  ),
                                ],
                                if (_draftTypeIndex == 1)
                                  ..._buildDraftLabels(
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
                  const Spacer(flex: 1),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  //
  List<SchemeText> _buildDraftLabels({
    required List<Draft> drafts,
    required TextStyle? style,
    required Matrix4 layoutTransform,
  }) =>
      drafts
          .map(
            (draft) => SchemeText(
              text:
                  '${draft.label} ${draft.value.toStringAsFixed(2)} ${const Localized('m').v}',
              style: style,
              offset: Offset(draft.x, draft.y),
              alignment: Alignment(
                0.0,
                draft.y < 0.0 ? -2.0 : 2.0,
              ),
              layoutTransform: layoutTransform,
            ),
          )
          .toList();
}
///
enum _DraftTypeEnum {
  ///
  perpendicular(idx: 0, label: 'На перпендикуляре'),
  marks(idx: 1, label: 'На марках углубления');
  ///
  final int idx;
  ///
  final String label;
  const _DraftTypeEnum({required this.idx, required this.label});
  ///
  factory _DraftTypeEnum.from({required int idx}) => switch (idx) {
        0 => _DraftTypeEnum.perpendicular,
        1 => _DraftTypeEnum.marks,
        _ => throw UnimplementedError(),
      };
}
///
class _DraftTypeDropdown extends StatelessWidget {
  final int _initialValue;
  final void Function(int)? _onTypeChanged;
  ///
  const _DraftTypeDropdown({
    required int initialValue,
    void Function(int)? onTypeChanged,
  })  : _onTypeChanged = onTypeChanged,
        _initialValue = initialValue;
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonCustom<int>(
      onSelected: (value) {
        _onTypeChanged?.call(value);
      },
      initialValue: _initialValue,
      itemBuilder: (context) => <PopupMenuItem<int>>[
        PopupMenuItem(
          value: _DraftTypeEnum.perpendicular.idx,
          child: Text(
            Localized(_DraftTypeEnum.perpendicular.label).v,
          ),
        ),
        PopupMenuItem(
          value: _DraftTypeEnum.marks.idx,
          child: Text(
            Localized(_DraftTypeEnum.marks.label).v,
          ),
        ),
      ],
      color: Theme.of(context).colorScheme.surface,
      customButtonBuilder: (onTap) => FilledButton(
        onPressed: onTap,
        iconAlignment: IconAlignment.end,
        child: Row(
          children: [
            Expanded(
              child: Text(
                Localized(_DraftTypeEnum.from(idx: _initialValue).label).v,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            const Icon(Icons.arrow_drop_down_outlined),
          ],
        ),
      ),
    );
  }
}
