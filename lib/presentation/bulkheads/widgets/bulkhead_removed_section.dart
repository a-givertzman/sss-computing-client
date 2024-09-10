import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_draggable_widget.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_empty_widget.dart';
///
/// Widget displaying section with removed grain bulkhead.
class BulkheadRemovedSection extends StatefulWidget {
  final String _label;
  final double _bulkheadHeight;
  final List<int> _bulkheadIds;
  final void Function(int bulkheadId)? _onBulkheadDropped;
  /// Creates widget displaying section with removed grain bulkhead.
  ///
  ///   `bulkheadIds` - list with id of removed bulkhead.
  ///   `onBulkheadDropped` - callback that will be called when
  /// bulkhead draggable widget is dropped and accepted by [BulkheadRemovedSection].
  const BulkheadRemovedSection({
    super.key,
    required String label,
    required double bulkheadHeight,
    List<int> bulkheadIds = const [],
    void Function(int)? onBulkheadDropped,
  })  : _label = label,
        _bulkheadHeight = bulkheadHeight,
        _bulkheadIds = bulkheadIds,
        _onBulkheadDropped = onBulkheadDropped;
  //
  @override
  State<BulkheadRemovedSection> createState() => _BulkheadRemovedSectionState();
}
class _BulkheadRemovedSectionState extends State<BulkheadRemovedSection> {
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
    final padding = const Setting('padding').toDouble;
    const itemsMargin = 8.0;
    const itemsPadding = 12.0;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget._label,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: padding),
        Padding(
          padding: const EdgeInsets.all(itemsMargin),
          child: DragTarget<int>(
            onAcceptWithDetails: _onAcceptWithDetails,
            onWillAcceptWithDetails: _onWillAcceptWithDetails,
            onLeave: (_) => _onLeave(),
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
                height: widget._bulkheadHeight,
                child: ListView.separated(
                  itemCount: widget._bulkheadIds.length + 1,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(
                    width: padding,
                  ),
                  itemBuilder: (context, index) =>
                      index != widget._bulkheadIds.length
                          ? BulkheadDraggableWidget(
                              data: widget._bulkheadIds[index],
                              height: widget._bulkheadHeight,
                              label: const Localized('Grain bulkhead').v,
                            )
                          : BulkheadEmptyWidget(
                              height: widget._bulkheadHeight,
                              label: const Localized('Remove bulkhead').v,
                            ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  //
  void _onAcceptWithDetails(DragTargetDetails<int> details) {
    widget._onBulkheadDropped?.call(details.data);
    setState(() {
      _willAccept = null;
    });
  }
  //
  bool _onWillAcceptWithDetails(DragTargetDetails<int> details) {
    final willAccept = !widget._bulkheadIds.contains(details.data);
    if (willAccept != _willAccept) {
      setState(() {
        _willAccept = willAccept;
      });
    }
    return willAccept;
  }
  //
  void _onLeave() {
    setState(() {
      _willAccept = null;
    });
  }
}
