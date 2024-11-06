import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
///
/// Preview of voyage [Waypoint].
class VoyageWaypointPreview extends StatelessWidget {
  final Waypoint? _waypoint;
  final Color? _color;
  ///
  /// Creates widget with preview of voyage [Waypoint].
  ///
  /// * [waypoint] - [Waypoint] to display.
  /// * [color] - color for [Waypoint] label.
  const VoyageWaypointPreview({
    super.key,
    Waypoint? waypoint,
    Color? color,
  })  : _waypoint = waypoint,
        _color = color;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: _color ?? theme.colorScheme.onPrimary,
    );
    final padding = const Setting('padding').toDouble;
    final waypoint = _waypoint;
    return waypoint == null
        ? Text(
            '-',
            style: textStyle,
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Tooltip(
                message: waypoint.portName,
                child: Container(
                  width: 12.0,
                  height: 24.0,
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  decoration: BoxDecoration(
                    color: waypoint.color,
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                  ),
                ),
              ),
              SizedBox(width: padding),
              Expanded(
                child: Text(
                  waypoint.portCode,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: textStyle,
                ),
              ),
            ],
          );
  }
}
