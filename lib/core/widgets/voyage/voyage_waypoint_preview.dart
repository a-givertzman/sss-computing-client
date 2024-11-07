import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
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
    final padding = const Setting('padding').toDouble;
    final width = const Setting('colorLabelWidth').toDouble;
    final height = const Setting('colorLabelHeight').toDouble;
    final borderRadius = const Setting('colorLabelBorderRadius').toDouble;
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: _color ?? theme.colorScheme.onPrimary,
    );
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
                  width: width,
                  height: height,
                  margin: EdgeInsets.symmetric(
                    vertical: borderRadius,
                  ),
                  decoration: BoxDecoration(
                    color: waypoint.color,
                    borderRadius: BorderRadius.all(Radius.circular(
                      borderRadius,
                    )),
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
