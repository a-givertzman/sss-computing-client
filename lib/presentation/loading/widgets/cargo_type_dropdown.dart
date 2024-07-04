import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// Widget for selecting type of [Cargo].
class CargoTypeDropdown extends StatefulWidget {
  final CargoType _initialValue;
  final void Function(CargoType)? _onTypeChanged;
  ///
  /// Creates widget for selecting type of [Cargo] from dropdown menu.
  const CargoTypeDropdown({
    super.key,
    required CargoType initialValue,
    void Function(CargoType)? onTypeChanged,
  })  : _onTypeChanged = onTypeChanged,
        _initialValue = initialValue;
  //
  @override
  State<CargoTypeDropdown> createState() => _CargoTypeDropdownState();
}
///
class _CargoTypeDropdownState extends State<CargoTypeDropdown> {
  late CargoType _selected;
  //
  @override
  void initState() {
    _selected = widget._initialValue;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonCustom<CargoType>(
      onSelected: (value) {
        setState(() {
          _selected = value;
        });
        widget._onTypeChanged?.call(value);
      },
      initialValue: widget._initialValue,
      itemBuilder: (context) => <PopupMenuItem<CargoType>>[
        ...CargoType.values.map((type) => PopupMenuItem(
              value: type,
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
              Expanded(
                child: Text(
                  Localized(_selected.label).v,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              const Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
