import 'package:flutter/material.dart';

///
enum ShipSchemeInteractOption {
  view,
  select,
}

///
class ShipSchemeInteractOptions extends StatefulWidget {
  final Set<ShipSchemeInteractOption> _initialOptions;
  final Set<ShipSchemeInteractOption> _availableOptions;
  final void Function(Set<ShipSchemeInteractOption>)? _onOptionsChanged;
  final Color? _foregroundColor;
  final Color? _backgroundColor;
  final Color? _selectedForegroundColor;
  final Color? _selectedBackgroundColor;

  ///
  const ShipSchemeInteractOptions({
    super.key,
    required Set<ShipSchemeInteractOption> initialOptions,
    required Set<ShipSchemeInteractOption> availableOptions,
    void Function(Set<ShipSchemeInteractOption> newOptions)? onOptionsChanged,
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
  State<ShipSchemeInteractOptions> createState() =>
      _ShipSchemeInteractOptionsState();
}

///
class _ShipSchemeInteractOptionsState extends State<ShipSchemeInteractOptions> {
  late Set<ShipSchemeInteractOption> selection;

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
    return SegmentedButton<ShipSchemeInteractOption>(
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
      segments: <ButtonSegment<ShipSchemeInteractOption>>[
        if (widget._availableOptions.contains(ShipSchemeInteractOption.view))
          const ButtonSegment<ShipSchemeInteractOption>(
            value: ShipSchemeInteractOption.view,
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Tooltip(
                message: 'Interactive view tool',
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.open_with),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.pan_tool_alt),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (widget._availableOptions.contains(ShipSchemeInteractOption.select))
          const ButtonSegment<ShipSchemeInteractOption>(
            value: ShipSchemeInteractOption.select,
            icon: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Tooltip(
                message: 'Select tool',
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.crop_16_9_sharp),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.pan_tool_alt),
                    ),
                  ],
                ),
              ),
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
      showSelectedIcon: false,
    );
  }
}
