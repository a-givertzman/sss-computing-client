import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// Widget for selecting type of [Cargo].
class CargoTypeDropdown extends StatelessWidget {
  final void Function(String?)? _onTypeChanged;
  final String? _initialValue;
  ///
  /// Creates widget for selecting type of [Cargo].
  const CargoTypeDropdown({
    super.key,
    required void Function(String?)? onTypeChanged,
    required String? initialValue,
  })  : _onTypeChanged = onTypeChanged,
        _initialValue = initialValue;
  //
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
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
              label: type.label,
            ),
          )
          .toList(),
      onSelected: (value) => _onTypeChanged?.call(value),
    );
  }
}
