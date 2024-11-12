///
/// Common data of the given [Itinerary]
/// The information is used to generate
/// reports and to assist in the preparation of container loading plans.
abstract interface class Itinerary {
  /// Index of the [Itinerary]
  int get index;

  /// Name of the port
  String get port;

  /// Code of the port
  String get portCode;

  /// Estimated time of departure [ETD]
  DateTime get departure;

  /// Estimated time of arrival [ETA]
  DateTime get arrival;

  /// Draft limitation
  int get draftLimit;
}

/// A [Iterinerary] implementation based on JSON
final class JsonItinerary implements Itinerary {
  final Map<String, dynamic> _json;

  JsonItinerary({required Map<String, dynamic> json}) : _json = json;

  @override
  int get index => int.parse(_json['index']);

  @override
  DateTime get arrival => DateTime.parse(_json['arrival']);

  @override
  DateTime get departure => DateTime.parse(_json['departure']);

  @override
  String get port => _json['port'];

  @override
  String get portCode => _json['port_code'];

  @override
  int get draftLimit => int.tryParse(_json['draft_limit']) ?? 0;
}
