import 'package:sss_computing_client/core/models/stowage/container/freight_container.dart';
import 'package:sss_computing_client/core/models/stowage/container/freight_container_type.dart';
///
/// [FreightContainer] that parse itself from json map.
class JsonFreightContainer implements FreightContainer {
  final Map<String, dynamic> _json;
  ///
  /// Creates [FreightContainer] that parse itself from [json] map.
  const JsonFreightContainer({
    required Map<String, dynamic> json,
  }) : _json = json;
  ///
  /// Creates [FreightContainer] that parse itself from [row].
  ///
  /// Row must be following format:
  ///
  /// ```json
  /// {
  ///   "id": 1, // int
  ///   "serialCode": 123, // int
  ///   "typeCode": "GP", // String
  ///   "ownerCode": "OWN", // String
  ///   "checkDigit": 1, // int
  ///   "maxGrossWeight": 1000.0, // double
  ///   "grossWeight": 900.0, // double
  ///   "tareWeight": 100.0, // double
  ///   "polWaypointId": 1, // int?
  ///   "podWaypointId": 2, // int?
  ///   "polWaypointOrder": 1, // int?
  ///   "podWaypointOrder": 2, // int?
  /// }
  factory JsonFreightContainer.fromRow(Map<String, dynamic> row) =>
      JsonFreightContainer(
        json: {
          'id': row['id'] as int,
          'isoCode': row['isoCode'] as String,
          'serialCode': row['serialCode'] as int,
          'typeCode': row['typeCode'] as String,
          'ownerCode': row['ownerCode'] as String,
          'checkDigit': row['checkDigit'] as int,
          'maxGrossWeight': row['maxGrossWeight'] as double,
          'grossWeight': row['grossWeight'] as double,
          'tareWeight': row['tareWeight'] as double,
          'polWaypointId': row['polWaypointId'] as int?,
          'podWaypointId': row['podWaypointId'] as int?,
          'polWaypointOrder': row['polWaypointOrder'] as int?,
          'podWaypointOrder': row['podWaypointOrder'] as int?,
        },
      );
  //
  @override
  int get id => _json['id'];
  //
  @override
  int get serialCode => _json['serialCode'];
  //
  @override
  String get typeCode => _json['typeCode'];
  //
  @override
  String get ownerCode => _json['ownerCode'];
  //
  @override
  int get checkDigit => _json['checkDigit'];
  //
  @override
  double get tareWeight => _json['tareWeight'];
  //
  @override
  double get grossWeight => _json['grossWeight'];
  //
  @override
  double get maxGrossWeight => _json['maxGrossWeight'];
  //
  @override
  double get cargoWeight => grossWeight - tareWeight;
  //
  @override
  FreightContainerType get type => switch (_json['isoCode']) {
        '1A' => FreightContainerType.type1A,
        '1AA' => FreightContainerType.type1AA,
        '1AAA' => FreightContainerType.type1AAA,
        '1C' => FreightContainerType.type1C,
        '1CC' => FreightContainerType.type1CC,
        '1CCC' => FreightContainerType.type1CCC,
        _ => FreightContainerType.type1AA,
      };
  //
  @override
  double get length => type.length;
  //
  @override
  double get height => type.height;
  //
  @override
  double get width => type.width;
  //
  @override
  int? get polWaypointId => _json['polWaypointId'];
  //
  @override
  int? get podWaypointId => _json['podWaypointId'];
  //
  @override
  int? get polWaypointOrder => _json['polWaypointOrder'];
  //
  @override
  int? get podWaypointOrder => _json['podWaypointOrder'];
  //
  @override
  Map<String, dynamic> asMap() => {
        'id': id,
        'isoCode': type.isoCode,
        'serialCode': serialCode,
        'typeCode': typeCode,
        'ownerCode': ownerCode,
        'checkDigit': checkDigit,
        'maxGrossWeight': maxGrossWeight,
        'grossWeight': grossWeight,
        'tareWeight': tareWeight,
        'polWaypointId': polWaypointId,
        'podWaypointId': podWaypointId,
        'polWaypointOrder': polWaypointOrder,
        'podWaypointOrder': podWaypointOrder,
      };
}
