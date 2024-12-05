import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/projects/project.dart';
///
/// Interface for controlling collection of [Project].
abstract interface class Projects {
  ///
  /// Fetches and returns all projects.
  Future<Result<List<Project>, Failure<String>>> fetchAll();
  ///
  /// Adds [project] to collection.
  Future<Result<void, Failure<String>>> add(Project project);
  ///
  /// Replaces [old] project with new [project] in collection.
  Future<Result<void, Failure<String>>> replace(Project old, Project project);
  ///
  /// Removes [project] from collection.
  Future<Result<void, Failure<String>>> remove(Project project);
  ///
  /// Loads [project] data.
  Future<Result<void, Failure<String>>> load(Project project);
}
