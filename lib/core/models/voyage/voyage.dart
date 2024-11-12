/// Voyage information
abstract interface class Voyage {
  ///Voyage code
  String? get code;

  /// Selection of water area (port or sea)
  WaterArea get waterArea;

  /// The density of the intake water used in the calculations.
  double get density;

  /// The choice of cargo grade determines
  ///  the draught limits used in ship's landing calculations
  LoadLine get loadLine;

  /// Taken into account in calculations of settlement, strength and stability
  Icing get icing;

  /// Wetting of deck timber cargo
  bool get wetting;

  /// A description of the voyage or cargo plan or any comment
  String? get description;

  /// The key-value pairs of the [Voyage]
  Map<String, String> toMap();

  /// Returns true if the given [field] is the description of the voyage
  bool isFieldDescription(String field);

  /// Returns the unit of the given [field]
  /// if the [field] is not in the map, returns empty [String]
  String unitsBy(String field);
}

final class JsonVoyage implements Voyage {
  final Map<String, String> _json;

  JsonVoyage(this._json);

  @override
  WaterArea get waterArea => WaterArea.fromString(_json['water_area']);

  @override
  LoadLine get loadLine => LoadLine.fromString(_json['load_line']);

  @override
  String? get code => _json['voyage_code'];

  @override
  double get density =>
      double.tryParse(_json['intake_water_density'] ?? '') ?? 1.025;

  @override
  Icing get icing => Icing.fromString(_json['icing']);

  @override
  bool get wetting => bool.tryParse(_json['wetting_deck'] ?? '') ?? false;

  @override
  String? get description => _json['voyage_description'];

  @override
  Map<String, String> toMap() => _json;

  @override
  bool isFieldDescription(String entry) => entry == 'voyage_description';

  @override
  String unitsBy(String field) {
    if (field == 'intake_water_density') {
      return 't/m^3';
    }
    return '';
  }
}

enum Icing {
  none,
  full,
  partial;

  factory Icing.fromString(String? value) {
    return Icing.values.firstWhere(
      (element) => element.toString() == value,
      orElse: () => Icing.none,
    );
  }
}

enum LoadLine {
  summer,
  winter,
  light;

  factory LoadLine.fromString(String? value) {
    return LoadLine.values.firstWhere(
      (element) => element.toString() == value,
      orElse: () => LoadLine.summer,
    );
  }
}

enum WaterArea {
  port,
  sea;

  factory WaterArea.fromString(String? value) {
    switch (value) {
      case 'port':
        return WaterArea.port;
      case 'sea':
        return WaterArea.sea;
      default:
        return WaterArea.port;
    }
  }
}
