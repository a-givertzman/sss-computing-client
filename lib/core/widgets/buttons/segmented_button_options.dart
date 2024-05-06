import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
class SegmentedButtonOption {
  final String? _label;
  final String? _tooltip;
  final IconData? _icon;
  const SegmentedButtonOption({String? label, String? tooltip, IconData? icon})
      : _label = label,
        _tooltip = tooltip,
        _icon = icon;
}
///
class SegmentedButtonOptions<T extends Enum> extends StatefulWidget {
  final Set<T> _initialOptions;
  final Map<T, SegmentedButtonOption> _availableOptions;
  final void Function(Set<T>) _onOptionsChanged;
  final Color? _foregroundColor;
  final Color? _backgroundColor;
  final Color? _selectedForegroundColor;
  final Color? _selectedBackgroundColor;
  final TextStyle? _textStyle;
  final bool _multiSelectionEnabled;
  final bool _emptySelectionEnabled;
  ///
  const SegmentedButtonOptions({
    super.key,
    required Set<T> initialOptions,
    required Map<T, SegmentedButtonOption> availableOptions,
    required void Function(Set<T> newOptions) onOptionsChanged,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? selectedForegroundColor,
    Color? selectedBackgroundColor,
    TextStyle? textStyle,
    bool multiSelectionEnabled = false,
    bool emptySelectionEnabled = false,
  })  : _initialOptions = initialOptions,
        _availableOptions = availableOptions,
        _onOptionsChanged = onOptionsChanged,
        _foregroundColor = foregroundColor,
        _backgroundColor = backgroundColor,
        _selectedForegroundColor = selectedForegroundColor,
        _selectedBackgroundColor = selectedBackgroundColor,
        _textStyle = textStyle,
        _multiSelectionEnabled = multiSelectionEnabled,
        _emptySelectionEnabled = emptySelectionEnabled;
  ///
  @override
  State<SegmentedButtonOptions<T>> createState() =>
      _SegmentedButtonOptionsState<T>(
        initialOptions: _initialOptions,
        availableOptions: _availableOptions,
        onOptionsChanged: _onOptionsChanged,
        foregroundColor: _foregroundColor,
        backgroundColor: _backgroundColor,
        selectedForegroundColor: _selectedForegroundColor,
        selectedBackgroundColor: _selectedBackgroundColor,
        textStyle: _textStyle,
        multiSelectionEnabled: _multiSelectionEnabled,
        emptySelectionEnabled: _emptySelectionEnabled,
      );
}
///
class _SegmentedButtonOptionsState<T extends Enum>
    extends State<SegmentedButtonOptions<T>> {
  final Set<T> _initialOptions;
  final Map<T, SegmentedButtonOption> _availableOptions;
  final void Function(Set<T>) _onOptionsChanged;
  final Color? _foregroundColor;
  final Color? _backgroundColor;
  final Color? _selectedForegroundColor;
  final Color? _selectedBackgroundColor;
  final TextStyle? _textStyle;
  final bool _multiSelectionEnabled;
  final bool _emptySelectionEnabled;
  late Set<T> selection;
  //
  _SegmentedButtonOptionsState({
    required Set<T> initialOptions,
    required Map<T, SegmentedButtonOption> availableOptions,
    required void Function(Set<T> newOptions) onOptionsChanged,
    Color? foregroundColor,
    Color? backgroundColor,
    Color? selectedForegroundColor,
    Color? selectedBackgroundColor,
    TextStyle? textStyle,
    bool multiSelectionEnabled = false,
    bool emptySelectionEnabled = false,
  })  : _initialOptions = initialOptions,
        _availableOptions = availableOptions,
        _onOptionsChanged = onOptionsChanged,
        _foregroundColor = foregroundColor,
        _backgroundColor = backgroundColor,
        _selectedForegroundColor = selectedForegroundColor,
        _selectedBackgroundColor = selectedBackgroundColor,
        _textStyle = textStyle,
        _multiSelectionEnabled = multiSelectionEnabled,
        _emptySelectionEnabled = emptySelectionEnabled;
  //
  @override
  void initState() {
    selection = _initialOptions;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding', factor: 3.0).toDouble;
    final entries = _availableOptions.entries.toList();
    return Material(
      borderRadius: BorderRadius.circular(20.0),
      elevation: 2.0,
      child: SegmentedButton<T>(
        multiSelectionEnabled: _multiSelectionEnabled,
        emptySelectionAllowed: _emptySelectionEnabled,
        style: SegmentedButton.styleFrom(
          selectedForegroundColor:
              _selectedForegroundColor ?? theme.colorScheme.onPrimary,
          selectedBackgroundColor:
              _selectedBackgroundColor ?? theme.colorScheme.primary,
          foregroundColor: _foregroundColor ?? theme.colorScheme.primary,
          backgroundColor: _backgroundColor ?? theme.colorScheme.surface,
          side: BorderSide.none,
          textStyle: _textStyle ??
              TextStyle(
                fontSize: theme.textTheme.labelLarge?.fontSize,
              ),
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(0.0),
        ),
        segments: <ButtonSegment<T>>[
          for (int i = 0; i < entries.length; i++)
            ButtonSegment(
              value: entries[i].key,
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(width: padding),
                  Expanded(
                    flex: 1,
                    child: _SegmentedButtonOption(
                      entries[i].value._label,
                      entries[i].value._tooltip,
                      entries[i].value._icon,
                    ),
                  ),
                  SizedBox(width: padding),
                  if (entries[i] != entries.last)
                    VerticalDivider(
                      color: selection.contains(entries[i].key)
                          ? theme.colorScheme.surface
                          : theme.colorScheme.primary,
                      thickness: 1.0,
                      width: 1.0,
                    ),
                ],
              ),
            ),
        ],
        selected: selection,
        onSelectionChanged: (newSelection) {
          setState(() {
            selection = newSelection;
          });
          _onOptionsChanged(newSelection);
        },
        showSelectedIcon: false,
      ),
    );
  }
}
///
class _SegmentedButtonOption extends StatelessWidget {
  final String? _label;
  final String? _tooltip;
  final IconData? _icon;
  ///
  const _SegmentedButtonOption(
    this._label,
    this._tooltip,
    this._icon,
  );
  //
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _tooltip ?? '',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (_icon != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              child: Center(
                child: Icon(_icon),
              ),
            ),
          if (_label != null)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: Center(
                  child: Text(_label),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
