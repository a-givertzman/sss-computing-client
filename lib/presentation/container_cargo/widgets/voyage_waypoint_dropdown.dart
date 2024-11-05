import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/stowage/voyage/waypoint.dart';
///
/// TODO
class VoyageWaypointDropdown extends StatelessWidget {
  final Waypoint? _initialValue;
  final List<Waypoint> _values;
  final void Function(Waypoint)? _onWaypointChanged;
  ///
  /// TODO
  const VoyageWaypointDropdown({
    super.key,
    required List<Waypoint> values,
    Waypoint? initialValue,
    void Function(Waypoint)? onWaypointChanged,
  })  : _initialValue = initialValue,
        _values = values,
        _onWaypointChanged = onWaypointChanged;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButtonCustom<Waypoint>(
      color: theme.colorScheme.surface,
      onSelected: _onWaypointChanged,
      initialValue: _initialValue,
      itemBuilder: (context) => <PopupMenuItem<Waypoint>>[
        ..._values.map((v) => PopupMenuItem(
              value: v,
              child: _WaypointPreview(v),
            )),
      ],
      customButtonBuilder: (onTap) => FilledButton(
        onPressed: onTap,
        iconAlignment: IconAlignment.end,
        child: Row(
          children: [
            Expanded(child: _WaypointPreview(_initialValue)),
            const Icon(Icons.arrow_drop_down_outlined),
          ],
        ),
      ),
    );
  }
}
///
class _WaypointPreview extends StatelessWidget {
  final Waypoint? _waypoint;
  ///
  const _WaypointPreview(this._waypoint);
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final waypoint = _waypoint;
    return waypoint == null
        ? const Text('-')
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 12.0,
                height: 24.0,
                margin: const EdgeInsets.symmetric(vertical: 2.0),
                decoration: BoxDecoration(
                  color: waypoint.color,
                  borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
              SizedBox(width: padding),
              Expanded(
                child: Text(
                  waypoint.portCode,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
            ],
          );
  }
}
