import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/stability/stability_criterions.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/stability/widgets/criterion_list.dart';
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
    final padding = const Setting('padding').toDouble;
    return Scaffold(
      body: FutureBuilderWidget(
        onFuture: DBStabilityCriterions(
          dbName: _dbName,
          apiAddress: _apiAddress,
        ).fetchAll,
        caseData: (context, data) {
          final criterions = data;
          return Row(
            children: [
              const Spacer(),
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(padding * 1.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${const Localized('Критерии остойчивости').v}:',
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
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
          );
        },
      ),
    );
  }
}
