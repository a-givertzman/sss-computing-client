import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/stability/stability_criterions.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterion_list.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterions_summary.dart';
///
class StabilityBody extends StatelessWidget {
  final String _dbName;
  final ApiAddress _apiAddress;
  ///
  const StabilityBody({
    super.key,
    required String dbName,
    required ApiAddress apiAddress,
  })  : _dbName = dbName,
        _apiAddress = apiAddress;
  ///
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return FutureBuilderWidget(
      onFuture: DBStabilityCriterions(
        dbName: _dbName,
        apiAddress: _apiAddress,
      ).fetchAll,
      caseData: (context, data) {
        final criterions = data;
        return Padding(
          padding: EdgeInsets.all(blockPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                flex: 1,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Text('[Empty]'),
                ),
              ),
              SizedBox(width: blockPadding),
              Expanded(
                flex: 1,
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.all(padding * 1.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${const Localized('Stability criteria').v}:',
                              textAlign: TextAlign.start,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            CriterionsSummary(criterions: criterions),
                          ],
                        ),
                        SizedBox(height: padding),
                        Expanded(
                          flex: 1,
                          child: CriterionList(criterions: criterions),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
