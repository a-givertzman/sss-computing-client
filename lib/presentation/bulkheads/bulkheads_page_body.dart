import 'package:collection/collection.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/bulkheads/pg_bulkhead_places.dart';
import 'package:sss_computing_client/core/models/bulkheads/pg_bulkheads.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
///
class BulkheadData {
  final int id;
  ///
  const BulkheadData({
    required this.id,
  });
}
///
class BulkheadPlaceData {
  final int id;
  final String label;
  final int? bulkheadId;
  ///
  const BulkheadPlaceData({
    required this.id,
    required this.label,
    this.bulkheadId,
  });
}
///
class BulkheadPlaces extends StatefulWidget {
  const BulkheadPlaces({super.key});
  @override
  State<BulkheadPlaces> createState() => _BulkheadPlacesState();
}
///
class _BulkheadPlacesState extends State<BulkheadPlaces> {
  late final ApiAddress _apiAddress;
  late final String _dbName;
  late final String? _authToken;
  late bool _isLoading;
  static const _bulkheadHeight = 256.0;
  //
  @override
  void initState() {
    _apiAddress = ApiAddress(
      host: const Setting('api-host').toString(),
      port: const Setting('api-port').toInt,
    );
    _dbName = const Setting('api-database').toString();
    _authToken = const Setting('api-auth-token').toString();
    _isLoading = false;
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return FutureBuilderWidget(
      onFuture: PgBulkheadPlaces(
        apiAddress: _apiAddress,
        dbName: _dbName,
        authToken: _authToken,
      ).fetchAll,
      caseData: (context, bulkheadPlaces, refresh) => FutureBuilderWidget(
        onFuture: PgBulkheads(
          apiAddress: _apiAddress,
          dbName: _dbName,
          authToken: _authToken,
        ).fetchAllRemoved,
        caseData: (context, bulkheadsRemoved, _) => Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: _BulkheadPlaceholdersSection(
                      bulkheadHeight: _bulkheadHeight,
                      label: const Localized('Трюм').v,
                      onBulkheadDropped: (bulkheadPlace, bulkhead) {
                        setState(() {
                          _isLoading = true;
                        });
                        PgBulkheadPlaces(
                          apiAddress: _apiAddress,
                          dbName: _dbName,
                          authToken: _authToken,
                        )
                            .installBulkheadWithId(
                              bulkheadPlace.id,
                              bulkhead.id,
                            )
                            .then(
                              (result) => switch (result) {
                                Ok() => setState(() {
                                    _isLoading = false;
                                    refresh();
                                  }),
                                Err() => setState(() {
                                    _isLoading = false;
                                  }),
                              },
                            );
                      },
                      bulkheadPlaceholders: bulkheadPlaces
                          .map((place) => BulkheadPlaceData(
                                id: place.id,
                                bulkheadId: place.bulkheadId,
                                label: place.name,
                              ))
                          .toList(),
                    ),
                  ),
                  Flexible(
                    child: _BulkheadRemovedSection(
                      bulkheadHeight: _bulkheadHeight,
                      label: const Localized('За бортом').v,
                      dataList: [
                        ...bulkheadsRemoved.map((bulkhead) => BulkheadData(
                              id: bulkhead.id,
                            )),
                      ],
                      onBulkheadDropped: (bulkhead) => PgBulkheadPlaces(
                        apiAddress: _apiAddress,
                        dbName: _dbName,
                        authToken: _authToken,
                      )
                          .removeBulkheadWithId(
                            bulkhead.id,
                          )
                          .then(
                            (_) => refresh(),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.grey.withOpacity(0.25),
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
///
class BulkheadsPageBody extends StatelessWidget {
  static const bulkheadHeight = 256.0;
  ///
  const BulkheadsPageBody({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return const BulkheadPlaces();
  }
}
///
class _BulkheadPlaceholdersSection extends StatelessWidget {
  final String label;
  final double bulkheadHeight;
  final List<BulkheadPlaceData> bulkheadPlaceholders;
  final void Function(
    BulkheadPlaceData bulkheadPlace,
    BulkheadData bulkhead,
  )? onBulkheadDropped;
  ///
  const _BulkheadPlaceholdersSection({
    required this.label,
    required this.bulkheadHeight,
    required this.bulkheadPlaceholders,
    this.onBulkheadDropped,
  });
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    const placeholderMargin = 8.0;
    const placeholderPadding = 12.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: padding),
        SizedBox(
          height: bulkheadHeight +
              placeholderMargin * 2.0 +
              placeholderPadding * 2.0,
          child: ListView.builder(
            itemCount: bulkheadPlaceholders.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) => _BulkheadPlaceholder(
              bulkheadPlaceData: bulkheadPlaceholders[index],
              bulkheadData: switch (bulkheadPlaceholders[index].bulkheadId) {
                final int id => BulkheadData(id: id),
                _ => null,
              },
              bulkheadHeight: bulkheadHeight,
              margin: placeholderMargin,
              padding: placeholderPadding,
              onBulkheadDropped: onBulkheadDropped,
            ),
          ),
        ),
      ],
    );
  }
}
///
class _BulkheadRemovedSection extends StatefulWidget {
  final String label;
  final double bulkheadHeight;
  final List<BulkheadData> dataList;
  final void Function(
    BulkheadData bulkhead,
  )? onBulkheadDropped;
  ///
  const _BulkheadRemovedSection({
    required this.label,
    required this.bulkheadHeight,
    this.dataList = const [],
    this.onBulkheadDropped,
  });
  //
  @override
  State<_BulkheadRemovedSection> createState() =>
      _BulkheadRemovedSectionState();
}
class _BulkheadRemovedSectionState extends State<_BulkheadRemovedSection> {
  late List<BulkheadData> _dataList;
  late bool? _willAccept;
  //
  @override
  void initState() {
    _dataList = widget.dataList;
    _willAccept = null;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    const itemsMargin = 8.0;
    const itemsPadding = 12.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: padding),
        Padding(
          padding: const EdgeInsets.all(itemsMargin),
          child: DragTarget<int>(
            onAcceptWithDetails: (details) {
              widget.onBulkheadDropped?.call(BulkheadData(id: details.data));
              setState(() {
                _willAccept = null;
              });
            },
            onWillAcceptWithDetails: (details) {
              final willAccept = _dataList.singleWhereOrNull(
                    (data) => data.id == details.data,
                  ) ==
                  null;
              if (willAccept != _willAccept) {
                setState(() {
                  _willAccept = willAccept;
                });
              }
              return willAccept;
            },
            onLeave: (_) => setState(() {
              _willAccept = null;
            }),
            builder: (context, _, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              padding: const EdgeInsets.all(itemsPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: switch (_willAccept) {
                      true => theme.colorScheme.primary,
                      _ => theme.colorScheme.onSurface,
                    },
                    width: 1.0,
                  ),
                ),
              ),
              child: SizedBox(
                height: widget.bulkheadHeight,
                child: ListView.separated(
                  itemCount: _dataList.length + 1,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: padding),
                  itemBuilder: (context, index) => index != _dataList.length
                      ? _BulkheadDraggable(
                          data: _dataList[index],
                          height: widget.bulkheadHeight,
                          label: 'Зерновая переборка',
                        )
                      : _BulkheadEmpty(
                          height: widget.bulkheadHeight,
                          label: 'Убрать переборку',
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
///
class BulkheadBase extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final double height;
  final Widget child;
  final bool isDragged;
  final Widget? _leading;
  final Widget? _trailing;
  ///
  const BulkheadBase({
    super.key,
    required this.borderColor,
    required this.backgroundColor,
    required this.height,
    required this.child,
    this.isDragged = false,
    Widget? leading,
    Widget? trailing,
  })  : _leading = leading,
        _trailing = trailing;
  //
  @override
  Widget build(BuildContext context) {
    const itemsPadding = 8.0;
    return Container(
      width: 32.0,
      height: height,
      padding: const EdgeInsets.symmetric(
        vertical: itemsPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.fromBorderSide(
          BorderSide(
            color: borderColor,
            width: 1.0,
          ),
        ),
        boxShadow: [
          if (isDragged)
            const BoxShadow(
              color: Colors.black,
              blurRadius: 5.0,
              spreadRadius: -1.0,
            ),
        ],
        color: backgroundColor,
      ),
      child: RotatedBox(
        quarterTurns: -1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_leading != null) _leading,
            const SizedBox(width: itemsPadding),
            child,
            const Spacer(),
            const SizedBox(width: itemsPadding),
            if (_trailing != null) _trailing,
          ],
        ),
      ),
    );
  }
}
///
class _BulkheadDraggable extends StatelessWidget {
  final BulkheadData data;
  final double height;
  final String label;
  final Function()? onDragCompleted;
  ///
  const _BulkheadDraggable({
    required this.data,
    required this.height,
    required this.label,
    this.onDragCompleted,
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Draggable<int>(
      data: data.id,
      onDragCompleted: onDragCompleted,
      feedback: Material(
        type: MaterialType.transparency,
        child: BulkheadBase(
          isDragged: true,
          borderColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primary,
          height: height,
          trailing: Icon(
            Icons.drag_indicator,
            color: theme.colorScheme.onPrimary,
            size: 18.0,
          ),
          child: OverflowableText(
            label,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.25,
        child: BulkheadBase(
          isDragged: false,
          borderColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.primary,
          height: height,
          trailing: Icon(
            Icons.drag_indicator,
            color: theme.colorScheme.onPrimary,
            size: 18.0,
          ),
          child: OverflowableText(
            label,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      child: BulkheadBase(
        isDragged: false,
        borderColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.primary,
        height: height,
        trailing: Icon(
          Icons.drag_indicator,
          color: theme.colorScheme.onPrimary,
          size: 18.0,
        ),
        child: OverflowableText(
          label,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
///
class _BulkheadEmpty extends StatelessWidget {
  final double height;
  final String label;
  ///
  const _BulkheadEmpty({
    required this.height,
    this.label = 'Установить переборку',
  });
  //
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.25,
      child: BulkheadBase(
        borderColor: Colors.white,
        backgroundColor: Colors.transparent,
        height: height,
        child: OverflowableText(
          Localized(label).v,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
///
class _BulkheadPlaceholder extends StatefulWidget {
  final double bulkheadHeight;
  final double margin;
  final double padding;
  final BulkheadPlaceData bulkheadPlaceData;
  final BulkheadData? bulkheadData;
  final void Function(
    BulkheadPlaceData bulkheadPlace,
    BulkheadData bulkhead,
  )? onBulkheadDropped;
  ///
  const _BulkheadPlaceholder({
    required this.bulkheadHeight,
    required this.margin,
    required this.padding,
    required this.bulkheadPlaceData,
    this.onBulkheadDropped,
    this.bulkheadData,
  });
  //
  @override
  State<_BulkheadPlaceholder> createState() => _BulkheadPlaceholderState();
}
class _BulkheadPlaceholderState extends State<_BulkheadPlaceholder> {
  late bool? _willAccept;
  //
  @override
  void initState() {
    _willAccept = null;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(widget.margin),
          child: DragTarget<int>(
            onAcceptWithDetails: (details) {
              widget.onBulkheadDropped?.call(
                widget.bulkheadPlaceData,
                BulkheadData(id: details.data),
              );
              setState(() {
                _willAccept = null;
              });
            },
            onWillAcceptWithDetails: (details) {
              if (details.data == widget.bulkheadData?.id) return false;
              final willAccept = widget.bulkheadData == null;
              if (willAccept != _willAccept) {
                setState(() {
                  _willAccept = willAccept;
                });
              }
              return willAccept;
            },
            onLeave: (_) => setState(() {
              _willAccept = null;
            }),
            builder: (context, _, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56.0,
              padding: EdgeInsets.all(widget.padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.fromBorderSide(
                  BorderSide(
                    color: switch (_willAccept) {
                      true => theme.colorScheme.primary,
                      false => theme.stateColors.error,
                      null => theme.colorScheme.onSurface,
                    },
                    width: 1.0,
                  ),
                ),
              ),
              child: switch (widget.bulkheadData) {
                final BulkheadData data => _BulkheadDraggable(
                    data: data,
                    height: widget.bulkheadHeight,
                    label: 'Зерновая переборка',
                  ),
                null => _BulkheadEmpty(height: widget.bulkheadHeight),
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          child: RotatedBox(
            quarterTurns: -1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.margin + widget.padding,
              ),
              child: Container(
                color: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 4.0,
                ),
                child: Text(
                  widget.bulkheadPlaceData.label,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 12.0,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
