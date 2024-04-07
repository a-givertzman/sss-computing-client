import 'dart:math';
import 'package:flutter/material.dart';

///
enum ShipSchemeOption {
  showAxes,
  showGrid,
  showFramesReal,
}

///
class ShipSchemeOptions extends StatefulWidget {
  final Set<ShipSchemeOption> _initialOptions;
  final void Function(Set<ShipSchemeOption>)? _onOptionsChanged;
  final Color? _foregroundColor;
  final Color? _backgroundColor;
  final Color? _selectedForegroundColor;
  final Color? _selectedBackgroundColor;

  ///
  const ShipSchemeOptions({
    super.key,
    required Set<ShipSchemeOption> initialOptions,
    void Function(Set<ShipSchemeOption> newOptions)? onOptionsChanged,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? selectedForegroundColor,
    Color? selectedBackgroundColor,
  })  : _initialOptions = initialOptions,
        _onOptionsChanged = onOptionsChanged,
        _foregroundColor = foregroundColor,
        _backgroundColor = backgroundColor,
        _selectedForegroundColor = selectedForegroundColor,
        _selectedBackgroundColor = selectedBackgroundColor;

  ///
  @override
  State<ShipSchemeOptions> createState() => _ShipSchemeOptionsState();
}

///
class _ShipSchemeOptionsState extends State<ShipSchemeOptions> {
  late Set<ShipSchemeOption> selection;

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
    return SegmentedButton<ShipSchemeOption>(
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
      segments: <ButtonSegment<ShipSchemeOption>>[
        const ButtonSegment<ShipSchemeOption>(
          value: ShipSchemeOption.showAxes,
          label: Text('Axes'),
          icon: Icon(Icons.merge),
        ),
        const ButtonSegment<ShipSchemeOption>(
          value: ShipSchemeOption.showGrid,
          label: Text('Grid'),
          icon: Icon(Icons.grid_4x4),
        ),
        ButtonSegment<ShipSchemeOption>(
          value: ShipSchemeOption.showFramesReal,
          label: const Text('Real Frames'),
          icon: Transform.rotate(
            angle: pi / 2.0,
            child: const Icon(Icons.density_small),
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
