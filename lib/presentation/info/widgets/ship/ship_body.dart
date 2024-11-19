import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

import 'package:sss_computing_client/core/models/ship/ship.dart';
import 'package:sss_computing_client/core/widgets/edit_on_tap_widget/edit_on_tap_field.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/core/widgets/table/table_nullable_cell.dart';
import 'package:sss_computing_client/core/widgets/zebra_stripped_list/zebra_stripped_list.dart';
import 'package:sss_computing_client/presentation/info/widgets/ship/pg_ship_details.dart';

///
/// Ship Info body displaying the [EditableZebraList] with the ship details
///
class ShipBody extends StatelessWidget {
  const ShipBody({super.key});

  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(blockPadding),
        child: FutureBuilderWidget(
          onFuture: PgShipDetails().fetchShip,
          caseData: (context, ship, _) {
            return _BuildItems(ship: ship);
          },
        ),
      ),
    );
  }
}

class _BuildItems extends StatefulWidget {
  const _BuildItems({required this.ship});
  final JsonShip ship;

  @override
  State<_BuildItems> createState() => _BuildItemsState();
}

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
            items: widget.ship.toMap().entries.toList(),
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
    if (widget.ship.isFieldEditable(item.key)) {
      ///todo validation
      return EditOnTapField(
        initialValue: item.value ?? '',
        maxLines: 5,
        onSubmit: (value) async {
          return Ok(value);
        },
        onSubmitted: (value) async {
          return Ok(value);
        },
      );
    } else {
      return NullableCellWidget(value: item.value);
    }
  }
}
