import 'dart:convert';
import 'package:sss_computing_client/core/models/options_field/json_options_field.dart';
import 'package:sss_computing_client/core/models/options_field/options_field.dart';
/// Voyage information
abstract interface class VoyageDetails {
  ///Voyage code
  String? get code;
  /// The density of the intake water used in the calculations.
  double get density;
  /// Selection of water area (port or sea)
  OptionsField<String> get waterArea;
  /// The choice of cargo grade determines
  /// the draught limits used in ship's landing calculations
  OptionsField<String> get loadLine;
  /// Taken into account in calculations of settlement, strength and stability
  OptionsField<String> get icing;
  /// Wetting of deck timber cargo
  bool get wetting;
  /// A description of the voyage or cargo plan or any comment
  String? get description;
  /// The key-value pairs of the [VoyageDetails]
  Map<String, dynamic> toMap();
  /// Returns true if the given [field] is the description of the voyage
  bool isFieldDescription(String field);
  /// Returns the unit of the given [field]
  /// if the [field] is not in the map, returns empty [String]
  String unitsBy(String field);
}
///
/// [VoyageDetails] that parses itself from json map.
final class JsonVoyageDetails implements VoyageDetails {
  final Map<String, dynamic> _json;
  ///
  /// Creates a [JsonVoyageDetails] that parses itself from json map.
  const JsonVoyageDetails(this._json);
  ///
  /// Creates a [JsonVoyageDetails] from the given sql [row].
  ///
  /// [row] should have the following format:
  /// ```json
  /// {
  ///   "voyageCode": "Код рейса", // String
  ///   "voyageDescription": "Описание рейса", // String
  ///   "intakeWaterDensity": "1.025", // String
  ///   "wettingDeck": "10.0", // String
  ///   "icingTypes": [{'id': 1, 'name': 'full', 'isActive': true}, ...], // String, JsonOptionsField
  ///   "waterAreaTypes": [{'id': 1, 'name': 'port', 'isActive': true}, ...], // String, JsonOptionsField
  ///   "loadLineTypes": [{'id': 1, 'name': 'full', 'isActive': true}, ...], // String, JsonOptionsField
  /// }
  /// ```
  ///
  /// Fore more information about [JsonOptionsField] format
  /// (for `icingTypes`, `waterArea` etc), see [JsonOptionsField.fromRowField].
  factory JsonVoyageDetails.fromRow(Map<String, dynamic> row) {
    return JsonVoyageDetails({
      'voyageCode': row['voyageCode'] as String,
      'intakeWaterDensity': row['intakeWaterDensity'] as String,
      'wettingDeck': row['wettingDeck'] as String,
      'icingTypes': json.encode(row['icingTypes']),
      'waterAreaTypes': json.encode(row['waterAreaTypes']),
      'loadLineTypes': json.encode(row['loadLineTypes']),
      'voyageDescription': row['voyageDescription'] as String,
    });
  }
  //
  @override
  String? get code => _json['voyageCode'];
  //
  @override
  double get density =>
      double.tryParse(_json['intakeWaterDensity'] ?? '') ?? 1.025;
  //
  @override
  bool get wetting => bool.tryParse(_json['wettingDeck'] ?? '') ?? false;
  //
  @override
  String? get description => _json['voyageDescription'];
  //
  @override
  OptionsField<String> get waterArea => JsonOptionsField.fromRowField(
        json.decode(_json['waterAreaTypes'] as String),
      );
  //
  @override
  OptionsField<String> get loadLine => JsonOptionsField.fromRowField(
        json.decode(_json['loadLineTypes'] as String),
      );
  //
  @override
  OptionsField<String> get icing => JsonOptionsField.fromRowField(
        json.decode(_json['icingTypes'] as String),
      );
  //
  @override
  Map<String, dynamic> toMap() => Map.from(_json);
  //
  @override
  bool isFieldDescription(String entry) => entry == 'voyageDescription';
  //
  @override
  String unitsBy(String field) {
    if (field == 'intakeWaterDensity') {
      return 't/m^3';
    }
    if (field == 'wettingDeck') {
      return '%';
    }
    return '';
  }
}
