import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/stowage_plan/slot/slot.dart';
import 'package:sss_computing_client/presentation/loading/widgets/containers_configurator/bay_pair_title.dart';
///
/// Widget to display bay pair number.
class BayPairNumber extends StatelessWidget {
  final bool _isVisible;
  final int? _oddBayNumber;
  final int? _evenBayNumber;
  final List<Slot> _slots;
  ///
  /// Creates Widget to display bay pair number (sibling [oddBayNumber] and [evenBayNumber]).
  ///
  /// [isVisible] indicates whether to show the widget in active state or not.
  /// [slots] used to determine whether to display title in 40 foots mode or not.
  const BayPairNumber({
    super.key,
    bool isVisible = false,
    int? oddBayNumber,
    int? evenBayNumber,
    List<Slot> slots = const [],
  })  : _isVisible = isVisible,
        _oddBayNumber = oddBayNumber,
        _evenBayNumber = evenBayNumber,
        _slots = slots;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      color: theme.colorScheme.onSurface,
    );
    const activeColor = Colors.amber;
    final defaultColor = theme.colorScheme.primary;
    final opacity = const Setting('opacityLow').toDouble;
    final padding = const Setting('padding', factor: 0.25).toDouble;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _isVisible
                ? activeColor.withOpacity(opacity)
                : defaultColor.withOpacity(opacity),
          ),
        ),
        padding: EdgeInsets.all(padding),
        child: Text(
          BayPairTitle(
            withFortyFoots: _slots.any(
              (slot) => slot.bay.isEven && slot.containerId != null,
            ),
            oddBayNumber: _oddBayNumber,
            evenBayNumber: _evenBayNumber,
          ).title(),
          style: labelStyle,
        ),
      ),
    );
  }
}
