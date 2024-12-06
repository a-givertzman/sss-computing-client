import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/projects/pg_projects.dart';
import 'package:sss_computing_client/core/models/projects/projects.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
import 'package:sss_computing_client/presentation/info/widgets/projects/projects_widget.dart';
///
/// Widget that displays projects and allows to manage them.
class ProjectsBody extends StatefulWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final void Function() _fireRefreshEvent;
  ///
  /// Creates widget that displays projects and allows to manage them.
  ///
  /// [fireRefreshEvent] - callback that is called to refresh app data.
  const ProjectsBody({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required void Function() fireRefreshEvent,
  })  : _appRefreshStream = appRefreshStream,
        _fireRefreshEvent = fireRefreshEvent;
  //
  @override
  State<ProjectsBody> createState() => _ProjectsBodyState();
}
///
class _ProjectsBodyState extends State<ProjectsBody> {
  late final Projects _projectsCollection;
  //
  @override
  void initState() {
    _projectsCollection = PgProjects(
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
    final padding = const Setting('padding').toDouble;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(blockPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              const Localized('Projects').v,
              textAlign: TextAlign.start,
              style: theme.textTheme.titleLarge,
            ),
            SizedBox(height: padding),
            Expanded(
              child: FutureBuilderWidget(
                refreshStream: widget._appRefreshStream,
                onFuture: _projectsCollection.fetchAll,
                caseData: (_, projects, __) => ProjectsWidget(
                  projects: projects,
                  projectsCollection: _projectsCollection,
                  onProjectLoaded: widget._fireRefreshEvent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
