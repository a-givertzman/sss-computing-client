import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/subscripting/subscripting.dart';
import 'package:sss_computing_client/core/models/voyage/voyage.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/widgets/edit_on_tap_widget/edit_on_tap_field.dart';
import 'package:sss_computing_client/core/widgets/table/table_nullable_cell.dart';
import 'package:sss_computing_client/core/widgets/zebra_stripped_list/zebra_stripped_list.dart';

/// The widget that displays the details of the voyage
class VoyageDetailsWidget extends StatefulWidget {
  const VoyageDetailsWidget({super.key, required this.details});
  final Voyage details;

  @override
  State<VoyageDetailsWidget> createState() => _VoyageDetailsWidgetState();
}

class _VoyageDetailsWidgetState extends State<VoyageDetailsWidget> {
  late ScrollController _scrollController;

  //
  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          Localized('general').v,
          textAlign: TextAlign.start,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: padding),
        Expanded(
          child: ZebraStripedListView<MapEntry<String, String>>(
            scrollController: _scrollController,
            scrollbarThickness: 0.0,
            items: widget.details.toMap().entries.toList(),
            buildItem: (context, item, stripped) => Padding(
              padding: EdgeInsets.all(padding / 2),
              child: Row(
                children: [
                  if (!widget.details.isFieldDescription(item.key))
                    Expanded(
                      child: Text(
                        '${Localized(item.key).v} ${AppSubscripting.getMathsExpression(
                          widget.details.unitsBy(item.key),
                        )}',
                      ),
                    ),
                  Flexible(
                    child: _buildValueWidget(item, padding: padding),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueWidget(MapEntry<String, String?> item,
      {double padding = 0}) {
    switch (item.key) {
      case 'intake_water_density':
        return EditOnTapField(
          initialValue: item.value ?? '',
          onSubmitted: (value) => Ok(value),
          validator: const Validator(
            cases: [
              ///todo: add more cases e.g min, max
              RealValidationCase(),
            ],
          ),
          onSubmit: (String value) async {
            return Ok(value);
          },
        );

      case 'voyage_description':
        return EditOnTapField(
          initialValue: item.value ?? '',
          onSubmitted: (value) => Ok(value),
          onSubmit: (String value) async {
            return Ok(value);
          },
        );
      case 'load_line':
        return _BuildDropdownButton(
          items: LoadLine.values.map((e) => e.name).toList(),
          initialValue: LoadLine.fromString(item.value).name,
          onChanged: (value) async => Ok(value),
        );
      case 'water_area':
        return _BuildDropdownButton(
          items: WaterArea.values.map((e) => e.name).toList(),
          initialValue: WaterArea.fromString(item.value).name,
          onChanged: (value) async => Ok(value),
        );
      case 'icing':
        return _BuildDropdownButton(
          items: Icing.values.map((e) => e.name).toList(),
          initialValue: Icing.fromString(item.value).name,
          onChanged: (value) async => Ok(value),
        );
      case 'wetting_deck':
        return _BuildDropdownButton(
          items: const ["Нет", "Да"],
          initialValue: item.value,
          onChanged: (value) async => Ok(value),
        );
      default:
        return NullableCellWidget(value: item.value);
    }
  }
}

class _BuildDropdownButton extends StatefulWidget {
  const _BuildDropdownButton(
      {required this.items, this.initialValue, required this.onChanged});
  final String? initialValue;
  final List<String> items;
  final Future<ResultF<String>> Function(String) onChanged;

  @override
  State<_BuildDropdownButton> createState() => _BuildDropdownButtonState();
}

class _BuildDropdownButtonState extends State<_BuildDropdownButton> {
  late String _initialValue;

  @override
  void initState() {
    _initialValue = widget.initialValue ?? widget.items.firstOrNull ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: _initialValue,
        isDense: true,
        padding: EdgeInsets.zero,
        isExpanded: true,
        items: widget.items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(Localized(e).v),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          _initialValue = value;
          widget.onChanged(_initialValue).then((value) {
            setState(() {});
          });
        },
      ),
    );
  }
}
