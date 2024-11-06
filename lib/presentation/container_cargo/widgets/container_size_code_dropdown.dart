import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
///
/// Dropdown for selecting [FreightContainerType] length or height code.
class ContainerSizeCodeDropdown extends StatelessWidget {
  final String _initialValue;
  final int _codeIndex;
  final String Function(String code)? _formatCode;
  final void Function(String)? _onTypeChanged;
  ///
  /// Creates a dropdown for selecting [FreightContainerType] length or height code.
  ///
  /// * [initialValue] - initial value.
  /// * [codeIndex] - if 0 - length code, if 1 - height code.
  /// * [formatCode] - function for formatting code.
  /// * [onTypeChanged] - callback that is called when value is changed.
  const ContainerSizeCodeDropdown({
    super.key,
    required String initialValue,
    required int codeIndex,
    String Function(String code)? formatCode,
    void Function(String)? onTypeChanged,
  })  : _initialValue = initialValue,
        _codeIndex = codeIndex,
        _formatCode = formatCode,
        _onTypeChanged = onTypeChanged;
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonCustom<String>(
      onSelected: _onTypeChanged,
      initialValue: _initialValue,
      itemBuilder: (context) => <PopupMenuItem<String>>[
        ...FreightContainerType.values
            .map((v) => v.sizeCode[_codeIndex])
            .toSet()
            .sorted()
            .map((code) => PopupMenuItem(
                  value: code,
                  child: Text(_formatCode?.call(code) ?? code),
                )),
      ],
      color: Theme.of(context).colorScheme.surface,
      customButtonBuilder: (onTap) => FilledButton(
        onPressed: onTap,
        iconAlignment: IconAlignment.end,
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatCode?.call(_initialValue) ?? _initialValue,
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            const Icon(Icons.arrow_drop_down_outlined),
          ],
        ),
      ),
    );
  }
}
