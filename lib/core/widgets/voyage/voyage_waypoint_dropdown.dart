import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/voyage/waypoint.dart';
import 'package:sss_computing_client/core/widgets/voyage/voyage_waypoint_preview.dart';
///
/// Dropdown for selecting [Waypoint] value.
class VoyageWaypointDropdown extends StatelessWidget {
  final Waypoint? _initialValue;
  final List<Waypoint> _values;
  final void Function(Waypoint)? _onWaypointChanged;
  final Widget Function(void Function()? onTap)? _buildCustomButton;
  final Color? _dropdownBackgroundColor;
  final Color? _waypointLabelColor;
  ///
  /// Creates dropdown for selecting [Waypoint] value.
  ///
  /// * [values] - list of available [Waypoint] values.
  /// * [initialValue] - [Waypoint] that will be selected by default.
  /// * [onWaypointChanged] - callback that will be called when [Waypoint] is changed.
  /// * [buildCustomButton] - callback that will be called to build custom button.
  /// * [dropdownBackgroundColor] - background color of dropdown.
  /// * [waypointLabelColor] - color for [Waypoint] label.
  const VoyageWaypointDropdown({
    super.key,
    required List<Waypoint> values,
    Waypoint? initialValue,
    void Function(Waypoint)? onWaypointChanged,
    Widget Function(void Function()? onTap)? buildCustomButton,
    Color? dropdownBackgroundColor,
    Color? waypointLabelColor,
  })  : _initialValue = initialValue,
        _values = values,
        _onWaypointChanged = onWaypointChanged,
        _buildCustomButton = buildCustomButton,
        _dropdownBackgroundColor = dropdownBackgroundColor,
        _waypointLabelColor = waypointLabelColor;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dropdownBackgroundColor =
        _dropdownBackgroundColor ?? theme.colorScheme.surface;
    final waypointLabelColor =
        _waypointLabelColor ?? theme.colorScheme.onSurface;
    return PopupMenuButtonCustom<Waypoint>(
      color: dropdownBackgroundColor,
      onSelected: _onWaypointChanged,
      initialValue: _initialValue,
      itemBuilder: (context) => <PopupMenuItem<Waypoint>>[
        ..._values.map((v) => PopupMenuItem(
              value: v,
              child: VoyageWaypointPreview(
                waypoint: v,
                color: waypointLabelColor,
              ),
            )),
      ],
      customButtonBuilder: (onTap) =>
          _buildCustomButton?.call(onTap) ??
          FilledButton(
            onPressed: onTap,
            iconAlignment: IconAlignment.end,
            child: Row(
              children: [
                Expanded(
                  child: VoyageWaypointPreview(
                    waypoint: _initialValue,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_outlined),
              ],
            ),
          ),
    );
  }
}
