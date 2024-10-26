import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/cargo/cargo_type.dart';
///
/// Widget for selecting type of [Cargo].
class CargoTypeDropdown extends StatelessWidget {
  final CargoType _initialValue;
  final List<CargoType> _types;
  final void Function(CargoType)? _onTypeChanged;
  ///
  /// Creates widget for selecting type of [Cargo] from dropdown menu.
  const CargoTypeDropdown({
    super.key,
    required CargoType initialValue,
    required List<CargoType> types,
    void Function(CargoType)? onTypeChanged,
  })  : _onTypeChanged = onTypeChanged,
        _types = types,
        _initialValue = initialValue;
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonCustom<CargoType>(
      onSelected: _onTypeChanged,
      initialValue: _initialValue,
      itemBuilder: (context) => <PopupMenuItem<CargoType>>[
        ..._types.map((type) => PopupMenuItem(
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
                  Localized(_initialValue.label).v,
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
