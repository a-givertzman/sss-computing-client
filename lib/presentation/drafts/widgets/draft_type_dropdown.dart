import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/draft_type.dart';
///
/// Dropdown for selecting [DraftType] value.
class DraftTypeDropdown extends StatelessWidget {
  final DraftType _initialValue;
  final void Function(DraftType) _onValueChanged;
  ///
  /// Creates dropdown for selecting [DraftType] value.
  ///
  ///   [intialValue] – starting value of dropdown.
  ///   [onValueChanged] – callback that will be called on value changed.
  const DraftTypeDropdown({
    super.key,
    required DraftType initialValue,
    required void Function(DraftType) onValueChanged,
  })  : _onValueChanged = onValueChanged,
        _initialValue = initialValue;
  //
  @override
  Widget build(BuildContext context) {
    return PopupMenuButtonCustom<DraftType>(
      onSelected: (value) => _onValueChanged.call(value),
      initialValue: _initialValue,
      itemBuilder: (context) => <PopupMenuItem<DraftType>>[
        PopupMenuItem(
          value: DraftType.perpendicular,
          child: Text(
            Localized(DraftType.perpendicular.label).v,
          ),
        ),
        PopupMenuItem(
          value: DraftType.marks,
          child: Text(
            Localized(DraftType.marks.label).v,
          ),
        ),
      ],
      color: Theme.of(context).colorScheme.surface,
      customButtonBuilder: (onTap) => FilledButton(
        onPressed: onTap,
        iconAlignment: IconAlignment.end,
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
    );
  }
}
