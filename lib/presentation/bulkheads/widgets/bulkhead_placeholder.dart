import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/bulkheads/bulkhead_place.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_draggable_widget.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_empty_widget.dart';
///
class BulkheadPlaceholder extends StatefulWidget {
  final double _bulkheadHeight;
  final double _margin;
  final double _padding;
  final BulkheadPlace _bulkheadPlace;
  final int? _bulkheadId;
  final void Function(
    BulkheadPlace bulkheadPlace,
    int bulkheadId,
  )? _onBulkheadDropped;
  ///
  const BulkheadPlaceholder({
    super.key,
    required double bulkheadHeight,
    required double margin,
    required double padding,
    required BulkheadPlace bulkheadPlace,
    void Function(BulkheadPlace, int)? onBulkheadDropped,
    int? bulkheadId,
  })  : _bulkheadHeight = bulkheadHeight,
        _margin = margin,
        _padding = padding,
        _bulkheadPlace = bulkheadPlace,
        _bulkheadId = bulkheadId,
        _onBulkheadDropped = onBulkheadDropped;
  //
  @override
  State<BulkheadPlaceholder> createState() => _BulkheadPlaceholderState();
}
class _BulkheadPlaceholderState extends State<BulkheadPlaceholder> {
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
          padding: EdgeInsets.all(widget._margin),
          child: DragTarget<int>(
            onAcceptWithDetails: _onAcceptWithDetails,
            onWillAcceptWithDetails: _onWillAcceptWithDetails,
            onLeave: (_) => _onLeave(),
            builder: (context, _, __) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56.0,
              padding: EdgeInsets.all(widget._padding),
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
              child: switch (widget._bulkheadId) {
                final int data => BulkheadDraggableWidget(
                    data: data,
                    height: widget._bulkheadHeight,
                    label: const Localized('Grain bulkhead').v,
                  ),
                null => BulkheadEmptyWidget(
                    height: widget._bulkheadHeight,
                    label: const Localized('Install bulkhead').v,
                  ),
              },
            ),
          ),
        ),
        _PlaceName(
          margin: widget._margin,
          padding: widget._padding,
          name: widget._bulkheadPlace.name,
        ),
      ],
    );
  }
  //
  void _onAcceptWithDetails(DragTargetDetails<int> details) {
    widget._onBulkheadDropped?.call(
      widget._bulkheadPlace,
      details.data,
    );
    setState(() {
      _willAccept = null;
    });
  }
  //
  bool _onWillAcceptWithDetails(DragTargetDetails<int> details) {
    if (details.data == widget._bulkheadId) return false;
    final willAccept = widget._bulkheadId == null;
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
///
class _PlaceName extends StatelessWidget {
  final double _margin;
  final double _padding;
  final String _name;
  ///
  const _PlaceName({
    required double margin,
    required double padding,
    required String name,
  })  : _margin = margin,
        _padding = padding,
        _name = name;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      child: RotatedBox(
        quarterTurns: -1,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: _margin + _padding),
          child: Container(
            color: theme.colorScheme.surface,
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
            child: Text(
              _name,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 12.0,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
