import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/draft_criteria.dart';
import 'package:sss_computing_client/presentation/drafts/widgets/draft_scheme.dart';
///
/// Body of drafts page.
class DraftsPageBody extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  ///
  /// Creates body of drafts page.
  ///
  /// * [appRefreshStream] – stream with events causing data to be updated.
  const DraftsPageBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
  }) : _appRefreshStream = appRefreshStream;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Card(
              margin: const EdgeInsets.all(0.0),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: DraftScheme(appRefreshStream: _appRefreshStream),
              ),
            ),
          ),
          SizedBox(height: blockPadding),
          Flexible(
            flex: 2,
            child: Card(
              margin: const EdgeInsets.all(0.0),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: DraftCriteria(appRefreshStream: _appRefreshStream),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
