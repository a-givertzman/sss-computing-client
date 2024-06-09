import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/widgets/segmented_button_options.dart';
///
/// Options for cargo scheme view.
enum CargoSchemeViewOption {
  showAxes,
  showGrid,
  showRealFrames,
  showTheoreticFrames,
}
///
/// Widget for selecting view options for cargo scheme view.
class CargoSchemeViewOptions extends StatelessWidget {
  final Set<CargoSchemeViewOption> _initialOptions;
  final void Function(Set<CargoSchemeViewOption>) _onOptionsChanged;
  ///
  /// Creates widget for selecting view options for cargo scheme view.
  const CargoSchemeViewOptions({
    super.key,
    required Set<CargoSchemeViewOption> initialOptions,
    required void Function(Set<CargoSchemeViewOption>) onOptionsChanged,
  })  : _initialOptions = initialOptions,
        _onOptionsChanged = onOptionsChanged;
  ///
  @override
  Widget build(BuildContext context) {
    return SegmentedButtonOptions<CargoSchemeViewOption>(
      multiSelectionEnabled: true,
      emptySelectionEnabled: true,
      initialOptions: _initialOptions,
      availableOptions: {
        CargoSchemeViewOption.showAxes: SegmentedButtonOption(
          label: const Localized('Axes').v,
          tooltip: const Localized('Show axes').v,
          icon: Icons.merge,
        ),
        CargoSchemeViewOption.showGrid: SegmentedButtonOption(
          label: const Localized('Grid').v,
          tooltip: const Localized('Show grid').v,
          icon: Icons.grid_4x4,
        ),
        CargoSchemeViewOption.showRealFrames: SegmentedButtonOption(
          label: const Localized('Fr. R.').v,
          tooltip: const Localized('Show real frames').v,
          icon: Icons.horizontal_distribute_outlined,
        ),
        CargoSchemeViewOption.showTheoreticFrames: SegmentedButtonOption(
          label: const Localized('Fr. Th.').v,
          tooltip: const Localized('Show theoretic frames').v,
          icon: Icons.horizontal_distribute_outlined,
        ),
      },
      onOptionsChanged: _onOptionsChanged,
    );
  }
}
