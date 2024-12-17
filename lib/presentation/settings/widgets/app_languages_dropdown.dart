import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
///
/// Dropdown for selecting [AppLang] value.
class AppLanguagesDropdown extends StatelessWidget {
  final AppLang? _initialValue;
  final List<AppLang> _values;
  final void Function(AppLang value) _onValueChanged;
  ///
  /// Creates dropdown for selecting [AppLang] value,
  /// with [initialValue] selected and [values] available.
  ///
  /// [onValueChanged] is called when new value is selected.
  const AppLanguagesDropdown({
    super.key,
    required AppLang? initialValue,
    required List<AppLang> values,
    required void Function(AppLang language) onValueChanged,
  })  : _initialValue = initialValue,
        _values = values,
        _onValueChanged = onValueChanged;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopupMenuButtonCustom<AppLang>(
      color: theme.colorScheme.surface,
      initialValue: _initialValue,
      onSelected: _onValueChanged,
      itemBuilder: (context) => <PopupMenuItem<AppLang>>[
        ..._values.map((v) => PopupMenuItem(
              value: v,
              child: _AppLanguagePreview(v),
            )),
      ],
      customButtonBuilder: (onTap) => FilledButton.icon(
        onPressed: onTap,
        iconAlignment: IconAlignment.start,
        icon: const Icon(Icons.language_outlined),
        label: Row(
          children: [
            Expanded(child: _AppLanguagePreview(_initialValue)),
            const Icon(Icons.arrow_drop_down_outlined),
          ],
        ),
      ),
    );
  }
}
///
/// Preview widget for [AppLang]
class _AppLanguagePreview extends StatelessWidget {
  final AppLang? _language;
  ///
  /// Creates preview widget for [AppLang]
  const _AppLanguagePreview(this._language);
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _language != null
        ? Text(Localized(_language.name).v)
        : Text(
            const Localized('Unknown language').v,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.stateColors.error,
            ),
          );
  }
}
