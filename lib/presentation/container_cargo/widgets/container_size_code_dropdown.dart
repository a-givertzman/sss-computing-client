import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
///
/// TODO
class ContainerSizeCodeDropdown extends StatelessWidget {
  final String _initialValue;
  final int _codeIndex;
  final String Function(String code)? _formatCode;
  final void Function(String)? _onTypeChanged;
  ///
  /// TODO
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
