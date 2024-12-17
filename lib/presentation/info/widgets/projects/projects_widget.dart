import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/date_time.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/models/field/field_type.dart';
import 'package:sss_computing_client/core/models/projects/json_project.dart';
import 'package:sss_computing_client/core/models/projects/project.dart';
import 'package:sss_computing_client/core/models/projects/projects.dart';
import 'package:sss_computing_client/core/widgets/confirmation_dialog.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table.dart';
import 'package:sss_computing_client/core/widgets/table/editing_table_column.dart';
import 'package:sss_computing_client/presentation/info/widgets/projects/save_as_dialog.dart';
///
/// Widget that displays projects and allows to switch between them
/// or create new one;
class ProjectsWidget extends StatefulWidget {
  final List<Project> _projects;
  final Projects _projectsCollection;
  final void Function() _onProjectLoaded;
  ///
  /// Creates widget that displays [projects] and allows to switch between them
  /// or create new one using [projectsCollection];
  ///
  /// [onProjectLoaded] is called when successfully switched to other project
  const ProjectsWidget({
    super.key,
    required List<Project> projects,
    required Projects projectsCollection,
    required void Function() onProjectLoaded,
  })  : _projects = projects,
        _projectsCollection = projectsCollection,
        _onProjectLoaded = onProjectLoaded;
  //
  @override
  State<ProjectsWidget> createState() => _ProjectsWidgetState();
}
///
class _ProjectsWidgetState extends State<ProjectsWidget> {
  late final List<Project> _projects;
  late final List<EditingTableColumn<Project, Object?>> _tableColumns;
  late Project? _selectedProject;
  late bool _isLoading;
  //
  @override
  void initState() {
    _projects = widget._projects;
    _selectedProject = null;
    _isLoading = false;
    _tableColumns = [
      EditingTableColumn<Project, String>(
        key: 'name',
        name: const Localized('name').v,
        grow: 1,
        defaultValue: '',
        extractValue: (project) => project.name,
        parseToValue: (String text) => text,
      ),
      EditingTableColumn<Project, DateTime>(
        key: 'created_at',
        name: const Localized('save date').v,
        grow: 1,
        type: FieldType.date,
        defaultValue: DateTime.now(),
        extractValue: (project) => project.createdAt,
        parseToValue: (String text) =>
            DateTime.tryParse(text) ?? DateTime.now(),
        parseToString: (DateTime value) => value.formatRU(),
      ),
      EditingTableColumn<Project, bool>(
        key: 'is_loaded',
        name: const Localized('status').v,
        grow: 1,
        defaultValue: false,
        extractValue: (project) => project.isLoaded,
        parseToValue: (String text) => bool.tryParse(text) ?? false,
        parseToString: (bool value) =>
            value ? const Localized('project loaded').v : '—',
      ),
    ];
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final blockPadding = const Setting('blockPadding').toDouble;
    return DisabledWidget(
      disabled: _isLoading,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.save_rounded),
                label: Text(const Localized('Save project').v),
                onPressed: _handleProjectSave,
              ),
              SizedBox(width: blockPadding),
              FilledButton.icon(
                icon: const Icon(Icons.save_rounded),
                label: Text(const Localized('Save project as').v),
                onPressed: _handleProjectSaveAs,
              ),
              const Spacer(),
              SizedBox(width: blockPadding),
              FilledButton.icon(
                icon: const Icon(Icons.unarchive_outlined),
                label: Text(const Localized('Load project').v),
                onPressed: _selectedProject != null
                    ? () => _handleProjectLoad(_selectedProject!)
                    : null,
              ),
              SizedBox(width: blockPadding),
              FilledButton.icon(
                icon: const Icon(Icons.delete_rounded),
                label: Text(const Localized('Delete project').v),
                onPressed: _selectedProject != null
                    ? () => _handleProjectDelete(_selectedProject!)
                    : null,
              ),
            ],
          ),
          Expanded(
            child: EditingTable<Project>(
              columns: _tableColumns,
              onRowTap: _toggleProjectSelection,
              rows: _projects,
              selectedRow: _selectedProject,
            ),
          ),
        ],
      ),
    );
  }
  //
  void _toggleProjectSelection(Project? project) {
    if (project?.id == _selectedProject?.id) {
      setState(() {
        _selectedProject = null;
      });
    } else {
      setState(() {
        _selectedProject = project;
      });
    }
  }
  //
  void _handleUpdateResult(Future<Result<void, Failure<String>>> updateResult) {
    setState(() {
      _isLoading = true;
    });
    updateResult.then((result) {
      return result
          .inspect(
            (_) => widget._onProjectLoaded(),
          )
          .inspectErr(
            (error) => _showErrorMessage(Localized(error.message).v),
          );
    }).whenComplete(() {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }
  //
  void _handleProjectSave() {
    _handleUpdateResult(
      widget._projectsCollection.add(JsonProject.emptyWith()),
    );
  }
  //
  void _handleProjectSaveAs() {
    showDialog(
      context: context,
      builder: (_) => SaveAsDialog(
        onSave: (name) async {
          final sameNameProject = _projects.firstWhereOrNull(
            (project) => project.name == name,
          );
          final replaceProject = sameNameProject != null
              ? await _confirmProjectReplacing(sameNameProject) ?? false
              : false;
          if (sameNameProject != null && replaceProject) {
            _handleUpdateResult(widget._projectsCollection.replace(
              sameNameProject,
              JsonProject.emptyWith(name: name),
            ));
            return;
          }
          if (sameNameProject == null) {
            _handleUpdateResult(widget._projectsCollection.add(
              JsonProject.emptyWith(name: name),
            ));
            return;
          }
        },
      ),
    );
  }
  //
  Future<bool?> _confirmProjectReplacing(Project project) => showDialog<bool>(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            title: Text(const Localized('Replace project?').v),
            content: Text(
              '${const Localized('Project with same name already exists.').v}\n\n${const Localized('Replace it with new project?')}',
            ),
            confirmationButtonLabel: const Localized('Replace').v,
          );
        },
      );
  //
  void _handleProjectLoad(Project project) {
    _handleUpdateResult(
      widget._projectsCollection.load(project),
    );
  }
  //
  void _handleProjectDelete(Project project) {
    _handleUpdateResult(
      widget._projectsCollection.remove(project),
    );
  }
  //
  void _showErrorMessage(String message) {
    if (!mounted) return;
    final durationMs = const Setting('errorMessageDisplayDuration_ms').toInt;
    BottomMessage.error(
      message: message.truncate(),
      displayDuration: Duration(milliseconds: durationMs),
    ).show(context);
  }
}
