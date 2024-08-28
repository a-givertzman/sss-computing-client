import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
class BulkheadData {
  final int index;
  final String label;
  ///
  const BulkheadData({
    required this.index,
    required this.label,
  });
}
///
class Bulkheads extends StatelessWidget {
  static const bulkheadHeight = 256.0;
  ///
  const Bulkheads({super.key});
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockPadding = const Setting('blockPadding').toDouble;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        _BulkheadPlaceholdersSection(
          label: const Localized('Сложенные').v,
          bulkheadHeight: bulkheadHeight,
          bulkheadPlaceholders: [
            '${const Localized('Frame').v} #28',
            '${const Localized('Frame').v} #27',
          ],
        ),
        VerticalDivider(
          width: blockPadding,
          thickness: 2.0,
          color: theme.colorScheme.surface,
        ),
        _BulkheadPlaceholdersSection(
          label: const Localized('Трюм').v,
          bulkheadHeight: bulkheadHeight,
          bulkheadPlaceholders: [
            '${const Localized('Frame').v} #51',
            '${const Localized('Frame').v} #113',
          ],
        ),
        VerticalDivider(
          width: blockPadding,
          thickness: 2.0,
          color: theme.colorScheme.surface,
        ),
        _BulkheadRemovedSection(
          label: const Localized('За бортом').v,
          bulkheadHeight: bulkheadHeight,
          dataList: [
            BulkheadData(
              index: 0,
              label: '${const Localized('Зерновая переборка').v} #1',
            ),
            BulkheadData(
              index: 1,
              label: '${const Localized('Зерновая переборка').v} #2',
            ),
          ],
        ),
      ],
    );
  }
}
///
class _BulkheadPlaceholdersSection extends StatelessWidget {
  final String label;
  final double bulkheadHeight;
  final List<String> bulkheadPlaceholders;
  ///
  const _BulkheadPlaceholdersSection({
    required this.label,
    required this.bulkheadHeight,
    required this.bulkheadPlaceholders,
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
              label: bulkheadPlaceholders[index],
              bulkheadHeight: bulkheadHeight,
              margin: placeholderMargin,
              padding: placeholderPadding,
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
  ///
  const _BulkheadRemovedSection({
    required this.label,
    required this.bulkheadHeight,
    this.dataList = const [],
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
  void _removeData(BulkheadData data) {
    setState(() {
      _dataList.removeWhere((item) => item == data);
    });
  }
  //
  void _addData(BulkheadData data) {
    setState(() {
      _dataList.add(data);
    });
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
          child: DragTarget<BulkheadData>(
            onAcceptWithDetails: (details) => setState(() {
              _addData(details.data);
              _willAccept = null;
            }),
            onWillAcceptWithDetails: (details) {
              final willAccept = !_dataList.contains(details.data);
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
                          onDragCompleted: () => _removeData(_dataList[index]),
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
  final void Function()? onDragCompleted;
  ///
  const _BulkheadDraggable({
    required this.data,
    required this.height,
    this.onDragCompleted,
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Draggable<BulkheadData>(
      data: data,
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
            data.label,
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
            data.label,
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
          data.label,
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
    this.label = 'Переборка не установлена',
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
  final String label;
  final double bulkheadHeight;
  final double margin;
  final double padding;
  final BulkheadData? data;
  ///
  const _BulkheadPlaceholder({
    required this.label,
    required this.bulkheadHeight,
    required this.margin,
    required this.padding,
    this.data,
  });
  //
  @override
  State<_BulkheadPlaceholder> createState() => _BulkheadPlaceholderState();
}
class _BulkheadPlaceholderState extends State<_BulkheadPlaceholder> {
  late BulkheadData? _data;
  late bool? _willAccept;
  //
  @override
  void initState() {
    _data = widget.data;
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
          child: DragTarget<BulkheadData>(
            onAcceptWithDetails: (details) => setState(() {
              _data = details.data;
              _willAccept = null;
            }),
            onWillAcceptWithDetails: (details) {
              if (details.data == _data) return false;
              final willAccept = _data == null;
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
              child: switch (_data) {
                final BulkheadData data => _BulkheadDraggable(
                    data: data,
                    height: widget.bulkheadHeight,
                    onDragCompleted: () => setState(() {
                      _data = null;
                    }),
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
                  widget.label,
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
