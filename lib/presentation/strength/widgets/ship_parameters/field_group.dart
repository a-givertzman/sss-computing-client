import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:sss_computing_client/models/field/field_data.dart';
import 'package:sss_computing_client/presentation/strength/widgets/ship_parameters/cancelable_field.dart';
import 'package:sss_computing_client/widgets/core/scrollable_builder.dart';

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
  late final ScrollController _scrollController;
  //

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  CancelableField _mapDataToField(FieldData data, {Failure? err}) =>
      CancelableField(
        label: data.label,
        suffixText: data.unit,
        initialValue: data.initialValue,
        fieldType: data.type,
        controller: data.controller,
        sendError: err != null ? '${err.message}' : null,
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
                builder: (_, isScrollEnabled) => SingleChildScrollView(
                  controller: _scrollController,
                  child: FutureBuilder(
                    future: Future.wait(widget._fieldsData.map(
                      (field) => field.isSynced
                          ? Future<ResultF>.value(const Ok(null))
                          : field.fetch(),
                    )),
                    builder: (_, result) => result.hasData
                        ? Column(
                            children: [
                              for (int i = 0;
                                  i < widget._fieldsData.length;
                                  i++) ...[
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: isScrollEnabled ? padding * 2 : 0.0,
                                  ),
                                  child: switch (result.data![i]) {
                                    Ok() =>
                                      _mapDataToField(widget._fieldsData[i]),
                                    Err(:final error) => _mapDataToField(
                                        widget._fieldsData[i],
                                        err: error,
                                      ),
                                  },
                                ),
                                if (i == widget._fieldsData.length - 1)
                                  SizedBox(height: padding),
                              ],
                            ],
                          )
                        : const CupertinoActivityIndicator(),
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
