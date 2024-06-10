import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// Widget for selecting type of [Cargo].
class CargoTypeDropdown extends StatefulWidget {
  final String _initialValue;
  final void Function(String)? _onTypeChanged;
  ///
  /// Creates widget for selecting type of [Cargo].
  const CargoTypeDropdown({
    super.key,
    required String initialValue,
    void Function(String)? onTypeChanged,
  })  : _onTypeChanged = onTypeChanged,
        _initialValue = initialValue;
  @override
  State<CargoTypeDropdown> createState() => _CargoTypeDropdownState();
}
class _CargoTypeDropdownState extends State<CargoTypeDropdown> {
  late String _selectedValue;
  //
  @override
  void initState() {
    _selectedValue = widget._initialValue;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonCustom<String>(
      onSelected: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget._onTypeChanged?.call(value);
      },
      initialValue: widget._initialValue,
      itemBuilder: (context) => <PopupMenuItem<String>>[
        ...CargoTypeColorLabel.values.map((type) => PopupMenuItem(
              value: type.label,
              child: Text(Localized(type.label).v),
            )),
      ],
      color: Theme.of(context).colorScheme.surface,
      customButtonBuilder: (onTap) => FilledButton(
        onPressed: onTap,
        iconAlignment: IconAlignment.end,
        child: Tooltip(
          message: const Localized('Select cargo type to display').v,
          child: Row(
            children: [
              Expanded(child: OverflowableText(Localized(_selectedValue).v)),
              const Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
