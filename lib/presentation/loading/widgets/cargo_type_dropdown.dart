import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// Widget for selecting type of [Cargo].
class CargoTypeDropdown extends StatelessWidget {
  final double? _width;
  final void Function(String?)? _onTypeChanged;
  final String? _initialValue;
  ///
  /// Creates widget for selecting type of [Cargo].
  const CargoTypeDropdown({
    super.key,
    double? width,
    required void Function(String?)? onTypeChanged,
    required String? initialValue,
  })  : _width = width,
        _onTypeChanged = onTypeChanged,
        _initialValue = initialValue;
  //
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: _width,
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateColor.resolveWith(
          (_) => Theme.of(context).colorScheme.surface,
        ),
      ),
      initialSelection: _initialValue,
      dropdownMenuEntries: CargoTypeColorLabel.values
          .map<DropdownMenuEntry<String>>(
            (type) => DropdownMenuEntry(
              value: type.label,
              label: Localized(type.label).v,
            ),
          )
          .toList(),
      onSelected: (value) => _onTypeChanged?.call(value),
    );
  }
}
