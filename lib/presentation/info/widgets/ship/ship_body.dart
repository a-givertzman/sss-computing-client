import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/models/ship/ship_details.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/core/widgets/edit_on_tap_widget/edit_on_tap_field.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/table/table_nullable_cell.dart';
import 'package:sss_computing_client/core/widgets/zebra_stripped_list/zebra_stripped_list.dart';
import 'package:sss_computing_client/core/models/ship/pg_ship_details.dart';
///
/// Ship Info body displaying the [EditableZebraList] with the ship details
class ShipBody extends StatefulWidget {
  ///
  /// Creates ship info body displaying the [EditableZebraList] with the ship details
  /// and allows to change them.
  const ShipBody({super.key});
  //
  @override
  State<ShipBody> createState() => _ShipBodyState();
}
///
class _ShipBodyState extends State<ShipBody> {
  late bool _isLoading;
  late final PgShipDetails _pgShipDetails;
  //
  @override
  void initState() {
    _isLoading = false;
    _pgShipDetails = PgShipDetails(
      apiAddress: ApiAddress(
        host: const Setting('api-host').toString(),
        port: const Setting('api-port').toInt,
      ),
      dbName: const Setting('api-database').toString(),
      authToken: const Setting('api-auth-token').toString(),
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(blockPadding),
        child: FutureBuilderWidget(
          onFuture: _pgShipDetails.fetch,
          caseData: (_, shipDetails, refreshDetails) {
            return DisabledWidget(
              disabled: _isLoading,
              child: _BuildItems(
                shipDetails: shipDetails,
                onItemChanged: (key, value) => _onItemChange(
                  key: key,
                  value: value,
                  whenComplete: refreshDetails,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  //
  Future<Result<String, Failure<String>>> _onItemChange({
    required String key,
    required String value,
    void Function()? whenComplete,
  }) {
    setState(() {
      _isLoading = true;
    });
    return _pgShipDetails.updateByKey(key: key, value: value).then(
      (result) {
        return result.inspectErr(
          (error) => _showErrorMessage(error.message),
        );
      },
    ).whenComplete(() {
      setState(
        () {
          _isLoading = false;
        },
      );
      whenComplete?.call();
    });
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    final durationMs = const Setting('errorMessageDisplayDuration').toInt;
    BottomMessage.error(
      message: message.truncate(),
      displayDuration: Duration(milliseconds: durationMs),
    ).show(context);
  }
}
///
class _BuildItems extends StatefulWidget {
  final JsonShipDetails _shipDetails;
  final Future<Result<String, Failure<String>>> Function(
    String key,
    String value,
  ) _onItemChanged;
  ///
  const _BuildItems({
    required JsonShipDetails shipDetails,
    required Future<Result<String, Failure<String>>> Function(
      String key,
      String value,
    ) onItemChanged,
  })  : _shipDetails = shipDetails,
        _onItemChanged = onItemChanged;
  //
  @override
  State<_BuildItems> createState() => _BuildItemsState();
}
///
class _BuildItemsState extends State<_BuildItems> {
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
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          const Localized('Ship').v,
          textAlign: TextAlign.start,
          style: theme.textTheme.titleLarge,
        ),
        SizedBox(height: padding),
        Expanded(
          child: ZebraStripedListView<MapEntry<String, dynamic>>(
            scrollController: _scrollController,
            items: widget._shipDetails.toMap().entries.toList(),
            buildItem: (context, item, stripped) => Padding(
              padding: EdgeInsets.all(padding / 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(Localized(item.key).v),
                  ),
                  Expanded(
                    child: _buildValueWidget(item),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildValueWidget(MapEntry<String, dynamic> item) {
    final theme = Theme.of(context);
    if (widget._shipDetails.isFieldEditable(item.key)) {
      return EditOnTapField(
        initialValue: item.value,
        maxLines: 5,
        iconColor: theme.colorScheme.primary,
        errorColor: theme.stateColors.error,
        onSubmit: (value) => Future.value(Ok(value)),
        onSubmitted: (value) => widget._onItemChanged(item.key, value),
      );
    } else {
      return NullableCellWidget(value: item.value);
    }
  }
}
