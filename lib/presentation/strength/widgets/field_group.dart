import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/presentation/core/scrollable_builder.dart';
import 'package:sss_computing_client/presentation/strength/widgets/cancelable_field.dart';

class FieldGroup extends StatefulWidget {
  final String _groupName;
  final void Function()? _onChanged;
  final void Function()? _onCancelled;
  final void Function()? _onSaved;
  final List<FieldData> _fieldsData;

  ///
  const FieldGroup({
    super.key,
    required String groupName,
    required List<FieldData> fieldsData,
    void Function()? onChanged,
    void Function()? onCancelled,
    void Function()? onSaved,
  })  : _groupName = groupName,
        _onCancelled = onCancelled,
        _onChanged = onChanged,
        _onSaved = onSaved,
        _fieldsData = fieldsData;

  @override
  State<FieldGroup> createState() => _FieldGroupState();
}

class _FieldGroupState extends State<FieldGroup> {
  final _scrollController = ScrollController();
  //

  CancelableField _mapDataToField(FieldData data) => CancelableField(
        label: data.label,
        suffixText: data.unit,
        initialValue: data.initialValue,
        fieldType: data.type,
        controller: data.controller,
        onChanged: (value) {
          data.controller.value = TextEditingValue(
            text: value,
            selection: TextSelection.fromPosition(
              TextPosition(offset: data.controller.selection.base.offset),
            ),
          );
          widget._onChanged?.call();
        },
        onCanceled: (_) {
          data.cancel();
          widget._onCancelled?.call();
        },
        onSaved: (_) {
          widget._onSaved?.call();
          return Future.value(const Ok(""));
        },
      );

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Column(
      children: [
        Text(
          widget._groupName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: blockPadding),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ScrollableBuilder(
                controller: _scrollController,
                builder: (_, isScrollable) => SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      for (int i = 0; i < widget._fieldsData.length; i++) ...[
                        Padding(
                          padding: EdgeInsets.only(
                            right: isScrollable ? padding * 2 : 0.0,
                          ),
                          child: _mapDataToField(widget._fieldsData[i]),
                        ),
                        if (i == widget._fieldsData.length - 1)
                          SizedBox(height: padding),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
