import 'dart:math';
import 'package:flutter/material.dart';

///
enum ShipSchemeViewOption {
  showAxes,
  showGrid,
  showRealFrames,
  showTheoreticFrames,
  showWaterline,
}

///
class ShipSchemeViewOptions extends StatefulWidget {
  final Set<ShipSchemeViewOption> _initialOptions;
  final Set<ShipSchemeViewOption> _availableOptions;
  final void Function(Set<ShipSchemeViewOption>)? _onOptionsChanged;
  final Color? _foregroundColor;
  final Color? _backgroundColor;
  final Color? _selectedForegroundColor;
  final Color? _selectedBackgroundColor;

  ///
  const ShipSchemeViewOptions({
    super.key,
    required Set<ShipSchemeViewOption> initialOptions,
    required Set<ShipSchemeViewOption> availableOptions,
    void Function(Set<ShipSchemeViewOption> newOptions)? onOptionsChanged,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? selectedForegroundColor,
    Color? selectedBackgroundColor,
  })  : _initialOptions = initialOptions,
        _availableOptions = availableOptions,
        _onOptionsChanged = onOptionsChanged,
        _foregroundColor = foregroundColor,
        _backgroundColor = backgroundColor,
        _selectedForegroundColor = selectedForegroundColor,
        _selectedBackgroundColor = selectedBackgroundColor;

  ///
  @override
  State<ShipSchemeViewOptions> createState() => _ShipSchemeViewOptionsState();
}

///
class _ShipSchemeViewOptionsState extends State<ShipSchemeViewOptions> {
  late Set<ShipSchemeViewOption> selection;

  ///
  @override
  void initState() {
    selection = widget._initialOptions;
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SegmentedButton<ShipSchemeViewOption>(
      style: SegmentedButton.styleFrom(
        selectedForegroundColor:
            widget._selectedForegroundColor ?? theme.colorScheme.primary,
        selectedBackgroundColor: widget._selectedBackgroundColor ??
            theme.colorScheme.primary.withOpacity(0.25),
        foregroundColor: widget._foregroundColor ?? Colors.white,
        backgroundColor: widget._backgroundColor ?? Colors.transparent,
        side: BorderSide(
          color: theme.colorScheme.primary,
        ),
        textStyle: TextStyle(
          fontSize: theme.textTheme.labelMedium?.fontSize,
          fontWeight: FontWeight.bold,
        ),
        visualDensity: VisualDensity.compact,
      ),
      segments: <ButtonSegment<ShipSchemeViewOption>>[
        if (widget._availableOptions.contains(ShipSchemeViewOption.showAxes))
          const ButtonSegment<ShipSchemeViewOption>(
            value: ShipSchemeViewOption.showAxes,
            label: Text('Axes'),
            icon: Tooltip(message: 'Show axes', child: Icon(Icons.merge)),
          ),
        if (widget._availableOptions.contains(ShipSchemeViewOption.showGrid))
          const ButtonSegment<ShipSchemeViewOption>(
            value: ShipSchemeViewOption.showGrid,
            label: Text('Grid'),
            icon: Tooltip(message: 'Show grid', child: Icon(Icons.grid_4x4)),
          ),
        if (widget._availableOptions
            .contains(ShipSchemeViewOption.showRealFrames))
          ButtonSegment<ShipSchemeViewOption>(
            value: ShipSchemeViewOption.showRealFrames,
            label: const Text('Frames R.'),
            icon: Tooltip(
              message: 'Show real frames',
              child: Transform.rotate(
                angle: pi / 2.0,
                child: const Icon(Icons.density_small),
              ),
            ),
          ),
        if (widget._availableOptions
            .contains(ShipSchemeViewOption.showTheoreticFrames))
          ButtonSegment<ShipSchemeViewOption>(
            value: ShipSchemeViewOption.showTheoreticFrames,
            label: const Text('Frames Th.'),
            icon: Tooltip(
              message: 'Show theoretic frames',
              child: Transform.rotate(
                angle: pi / 2.0,
                child: const Icon(Icons.density_small),
              ),
            ),
          ),
        if (widget._availableOptions
            .contains(ShipSchemeViewOption.showWaterline))
          const ButtonSegment<ShipSchemeViewOption>(
            value: ShipSchemeViewOption.showWaterline,
            label: Text('Waterline'),
            icon: Tooltip(
              message: 'Show waterline',
              child: Icon(Icons.sailing_rounded),
            ),
          ),
      ],
      selected: selection,
      onSelectionChanged: (newSelection) {
        setState(() {
          selection = newSelection;
        });
        widget._onOptionsChanged?.call(newSelection);
      },
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
      showSelectedIcon: false,
    );
  }
}
