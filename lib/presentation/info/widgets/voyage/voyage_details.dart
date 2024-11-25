import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/models/options_field/options_field.dart';
import 'package:sss_computing_client/core/models/subscripting/subscripting.dart';
import 'package:sss_computing_client/core/models/voyage/pg_voyage_details.dart';
import 'package:sss_computing_client/core/models/voyage/voyage_details.dart';
import 'package:sss_computing_client/core/validation/real_validation_case.dart';
import 'package:sss_computing_client/core/validation/required_validation_case.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/core/widgets/edit_on_tap_widget/edit_on_tap_field.dart';
import 'package:sss_computing_client/core/widgets/table/table_nullable_cell.dart';
import 'package:sss_computing_client/core/widgets/zebra_stripped_list/zebra_stripped_list.dart';
///
/// The widget that displays the details of the voyage
class VoyageDetailsWidget extends StatefulWidget {
  final PgVoyageDetails _detailsCollection;
  final VoyageDetails _details;
  final void Function()? _onDetailsUpdate;
  ///
  /// Creates a widget that displays the [details] of the voyage
  /// and allows to edit them using provided [detailsCollection].
  ///
  /// Calls [onDetailsChange] when the details are changed.
  const VoyageDetailsWidget({
    super.key,
    required PgVoyageDetails detailsCollection,
    required VoyageDetails details,
    void Function()? onDetailsChange,
  })  : _detailsCollection = detailsCollection,
        _details = details,
        _onDetailsUpdate = onDetailsChange;
  //
  @override
  State<VoyageDetailsWidget> createState() => _VoyageDetailsWidgetState();
}
///
class _VoyageDetailsWidgetState extends State<VoyageDetailsWidget> {
  late ScrollController _scrollController;
  late bool _isLoading;
  //
  @override
  void initState() {
    _scrollController = ScrollController();
    _isLoading = false;
    super.initState();
  }
  //
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          const Localized('general').v,
          textAlign: TextAlign.start,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: padding),
        Expanded(
          child: DisabledWidget(
            disabled: _isLoading,
            child: ZebraStripedListView<MapEntry<String, dynamic>>(
              scrollController: _scrollController,
              scrollbarThickness: 0.0,
              items: widget._details.toMap().entries.toList(),
              buildItem: (context, item, stripped) => Padding(
                padding: EdgeInsets.all(padding / 2),
                child: Row(
                  children: [
                    if (!widget._details.isFieldDescription(item.key))
                      Expanded(
                        child: Text(
                          '${Localized(item.key).v} ${AppSubscripting.getMathsExpression(
                            widget._details.unitsBy(item.key),
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
        ),
      ],
    );
  }
  // ignore: long-method
  Widget _buildValueWidget(
    MapEntry<String, dynamic> item, {
    double padding = 0,
  }) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.primary;
    final errorColor = theme.alarmColors.class3;
    switch (item.key) {
      case 'voyageCode':
        return EditOnTapField(
          iconColor: iconColor,
          errorColor: errorColor,
          initialValue: item.value ?? '',
          validator: const Validator(cases: [
            RequiredValidationCase(),
          ]),
          onSubmit: (value) => Future.value(Ok(value)),
          onSubmitted: (value) => widget._detailsCollection
              .updateVoyageCode(value)
              .then(_handleDetailsUpdate),
        );
      case 'voyageDescription':
        return EditOnTapField(
          iconColor: iconColor,
          errorColor: errorColor,
          initialValue: item.value ?? '',
          validator: const Validator(cases: [
            RequiredValidationCase(),
          ]),
          onSubmit: (value) => Future.value(Ok(value)),
          onSubmitted: (value) => widget._detailsCollection
              .updateVoyageDescription(value)
              .then(_handleDetailsUpdate),
        );
      case 'intakeWaterDensity':
        return EditOnTapField(
          iconColor: iconColor,
          errorColor: errorColor,
          initialValue: item.value ?? '',
          validator: const Validator(cases: [
            RequiredValidationCase(),
            RealValidationCase(),
          ]),
          onSubmit: (value) => Future.value(Ok(value)),
          onSubmitted: (value) => widget._detailsCollection
              .updateIntakeWaterDensity(value)
              .then(_handleDetailsUpdate),
        );
      case 'wettingDeck':
        return EditOnTapField(
          iconColor: iconColor,
          errorColor: errorColor,
          initialValue: item.value ?? '',
          validator: const Validator(cases: [
            RequiredValidationCase(),
            RealValidationCase(),
          ]),
          onSubmit: (String value) => Future.value(Ok(value)),
          onSubmitted: (value) => widget._detailsCollection
              .updateWettingDeck(value)
              .then(_handleDetailsUpdate),
        );
      case 'icingTypes':
        return _BuildDropdownButton(
          items: widget._details.icing.options,
          initialValue: widget._details.icing.active,
          onChanged: (value) => widget._detailsCollection
              .updateIcingType(value)
              .then(_handleDetailsUpdate),
        );
      case 'waterAreaTypes':
        return _BuildDropdownButton(
          items: widget._details.waterArea.options,
          initialValue: widget._details.waterArea.active,
          onChanged: (value) => widget._detailsCollection
              .updateWaterAreaType(value)
              .then(_handleDetailsUpdate),
        );
      case 'loadLineTypes':
        return _BuildDropdownButton(
          items: widget._details.loadLine.options,
          initialValue: widget._details.loadLine.active,
          onChanged: (value) => widget._detailsCollection
              .updateDraftMarkType(value)
              .then(_handleDetailsUpdate),
        );
      default:
        return NullableCellWidget(value: item.value);
    }
  }
  //
  Result<void, Failure<String>> _handleDetailsUpdate(
    Result<void, Failure<String>> updateResult,
  ) {
    return updateResult.inspect(
      (_) {
        widget._onDetailsUpdate?.call();
      },
    ).inspectErr(
      (err) {
        _showErrorMessage(err.message);
        widget._onDetailsUpdate?.call();
      },
    );
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    final durationMs = const Setting('errorMessageDisplayDuration').toInt;
    BottomMessage.error(
      message: Localized(message).v,
      displayDuration: Duration(milliseconds: durationMs),
    ).show(context);
  }
}
///
class _BuildDropdownButton extends StatelessWidget {
  final FieldOption<String> initialValue;
  final List<FieldOption<String>> items;
  final void Function(FieldOption<String>) onChanged;
  ///
  const _BuildDropdownButton({
    required this.initialValue,
    required this.items,
    required this.onChanged,
  });
  //
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<FieldOption<String>>(
        value: initialValue,
        padding: EdgeInsets.zero,
        isDense: true,
        isExpanded: true,
        items: items
            .map(
              (v) => DropdownMenuItem(
                value: v,
                child: Text(Localized(v.value).v),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) return;
          onChanged(value);
        },
      ),
    );
  }
}
