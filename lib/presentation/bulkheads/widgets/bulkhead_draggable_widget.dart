import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_base_widget.dart';
///
class BulkheadDraggableWidget extends StatelessWidget {
  final int _data;
  final double _height;
  final String _label;
  final Function()? _onDragCompleted;
  ///
  const BulkheadDraggableWidget({
    super.key,
    required int data,
    required double height,
    required String label,
    dynamic Function()? onDragCompleted,
  })  : _data = data,
        _height = height,
        _label = label,
        _onDragCompleted = onDragCompleted;
  //
  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: _data,
      onDragCompleted: _onDragCompleted,
      feedback: _FeedbackWidget(height: _height, label: _label),
      childWhenDragging: _WhileDraggedWidget(height: _height, label: _label),
      child: _DefaultWidget(height: _height, label: _label),
    );
  }
}
///
class _WhileDraggedWidget extends StatelessWidget {
  final double _height;
  final String _label;
  ///
  const _WhileDraggedWidget({
    required double height,
    required String label,
  })  : _height = height,
        _label = label;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: 0.25,
      child: BulkheadBaseWidget(
        isDragged: true,
        borderColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.primary,
        height: _height,
        trailing: Icon(
          Icons.drag_indicator,
          color: theme.colorScheme.onPrimary,
          size: 18.0,
        ),
        child: OverflowableText(
          _label,
          style: TextStyle(color: theme.colorScheme.onPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
///
class _FeedbackWidget extends StatelessWidget {
  final double _height;
  final String _label;
  ///
  const _FeedbackWidget({
    required double height,
    required String label,
  })  : _height = height,
        _label = label;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: BulkheadBaseWidget(
        isDragged: true,
        borderColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.primary,
        height: _height,
        trailing: Icon(
          Icons.drag_indicator,
          color: theme.colorScheme.onPrimary,
          size: 18.0,
        ),
        child: OverflowableText(
          _label,
          style: TextStyle(color: theme.colorScheme.onPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
///
class _DefaultWidget extends StatelessWidget {
  final double _height;
  final String _label;
  ///
  const _DefaultWidget({
    required double height,
    required String label,
  })  : _height = height,
        _label = label;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BulkheadBaseWidget(
      isDragged: false,
      borderColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary,
      height: _height,
      trailing: Icon(
        Icons.drag_indicator,
        color: theme.colorScheme.onPrimary,
        size: 18.0,
      ),
      child: OverflowableText(
        _label,
        style: TextStyle(color: theme.colorScheme.onPrimary),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
