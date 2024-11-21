/// Ship general details
abstract interface class ShipDetails {
  /// name of the ship
  String get name;
  ///
  /// Returns the [Map] representation of the [ShipDetails]
  Map<String, dynamic> toMap();
  /// Checks if the given [field] is found in [_editableFields] list
  /// returns true if found, false otherwise.
  /// used to determine if a field can be edited.
  bool isFieldEditable(String field);
}
/// An instance of [ShipDetails] from json.
class JsonShipDetails implements ShipDetails {
  static const _nullValueText = '—';
  final Map<String, dynamic> _json;
  ///
  /// Creates [ShipDetails] that parses itself from [json] map.
  const JsonShipDetails(this._json);
  ///
  /// Creates [ShipDetails] that parses itself from database [row].
  ///
  /// [row] should have the following format:
  /// ```json
  /// {
  ///   "shipName": "name", // String?
  ///   "callSign": "sign", // String?
  ///   "imo": "imo", // String?
  ///   "mmsi": "mmsi", // String?
  ///   "shipType": "type", // String?
  ///   "navigationArea": "area", // String?
  ///   "shipClassification": "class", // String?
  ///   "registration": "registration", // String?
  ///   "registrationPort": "port", // String?
  ///   "flagState": "state", // String?
  ///   "shipOwner": "owner", // String?
  ///   "shipOwnerCode": "code", // String?
  ///   "buildYard": "yard", // String?
  ///   "buildPlace": "place", // String?
  ///   "buildYear": "year", // String?
  ///   "shipBuilderNumber": "builder", // String?
  ///   "shipMaster": "master", // String?
  ///   "shipChiefMate": "chief", // String?
  /// }
  /// ```
  factory JsonShipDetails.fromRow(Map<String, dynamic> row) => JsonShipDetails({
        "shipName": row['shipName'] as String?,
        "callSign": row['callSign'] as String?,
        "imo": row['imo'] as String?,
        "mmsi": row['mmsi'] as String?,
        "shipType": row['shipType'] as String?,
        "navigationArea": row['navigationArea'] as String?,
        "shipClassification": row['shipClassification'] as String?,
        "registration": row['registration'] as String?,
        "registration_port": row['registrationPort'] as String?,
        "flagState": row['flagState'] as String?,
        "shipOwner": row['shipOwner'] as String?,
        "shipOwnerCode": row['shipOwnerCode'] as String?,
        "buildYard": row['buildYard'] as String?,
        "buildPlace": row['buildPlace'] as String?,
        "buildYear": row['buildYear'] as String?,
        "shipBuilderNumber": row['shipBuilderNumber'] as String?,
        "shipMaster": (row['shipMaster'] as String?) ??
            _nullValueText, // TODO: must be removed by modifying EditOnTapField
        "shipChiefMate": (row['shipChiefMate'] as String?) ??
            _nullValueText, // TODO: same as above
      });
  //
  @override
  String get name => _json['shipName'] ?? '';
  //
  @override
  Map<String, dynamic> toMap() => Map.from(_json);
  //
  List<String> get _editableFields => ["shipMaster", "shipChiefMate"];
  //
  @override
  bool isFieldEditable(String field) {
    return _editableFields.contains(field);
  }
}
