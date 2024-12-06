import 'package:sss_computing_client/core/models/projects/project.dart';
///
/// [Project] that parses itself from json map.
class JsonProject implements Project {
  final Map<String, dynamic> _json;
  ///
  /// Creates [Project] that parses itself from [json] map.
  const JsonProject({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [Project] that parses itself from database [row].
  ///
  /// [row] should have the following format:
  /// ```json
  /// {
  ///   "id": 1, // int
  ///   "name": "project name", // String
  ///   "createdAt": "2022-01-01 00:00:00", // String
  ///   "loadedAt": "2022-01-01 00:00:00", // String?
  ///   "isLoaded": true, // bool
  /// }
  factory JsonProject.fromRow(Map<String, dynamic> row) => JsonProject(
        json: {
          'id': row['id'] as int,
          'name': row['name'] as String,
          'createdAt': row['createdAt'] as String,
          'loadedAt': row['loadedAt'] as String?,
          'isLoaded': row['isLoaded'] as bool,
        },
      );
  ///
  /// Creates empty [Project] with default values,
  ///
  /// Some values can be overridden by passed parameters.
  factory JsonProject.emptyWith({
    String? name,
    DateTime? createdAt,
    DateTime? loadedAt,
    bool? isLoaded,
  }) =>
      JsonProject(
        json: {
          'id': -1,
          'name': name ?? DateTime.now().toIso8601String(),
          'createdAt': createdAt?.toString() ?? DateTime.now().toString(),
          'loadedAt': loadedAt?.toString(),
          'isLoaded': isLoaded ?? false,
        },
      );
  //
  @override
  int get id => _json['id'];
  //
  @override
  String get name => _json['name'];
  //
  @override
  DateTime get createdAt => DateTime.parse(_json['createdAt']);
  //
  @override
  DateTime? get loadedAt => DateTime.tryParse(_json['loadedAt']);
  //
  @override
  bool get isLoaded => _json['isLoaded'];
  //
  @override
  Map<String, dynamic> asMap() => Map.from(_json);
}
