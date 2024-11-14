import 'package:hmi_core/hmi_core.dart';

import 'package:sss_computing_client/core/models/voyage/itinerary.dart';
import 'package:sss_computing_client/core/models/voyage/voyage.dart';

/// Voyage details and itineraries collections that are stored in postgres DB.
/// TODO: Postgres database access implementation
class PgVoyageDetails {
  /// Fetches the details of the voyage from the database
  /// and return it as a list of [ConfigurableItem]s
  Future<Result<Voyage, Failure<String>>> fetchDetails() async {
    return Ok(
      JsonVoyage({
        "voyage_code": "Код рейса",
        "water_area": "sea",
        "intake_water_density": "1.025",
        "load_line": "summer",
        "icing": "none",
        "wetting_deck": "Нет",
        "voyage_description": "Описание рейса",
      }),
    );
  }

  ///
  /// Fetches list of itineraries from the Postgres database
  Future<Result<List<Itinerary>, Failure<String>>> fetchItineraries() async {
    return Ok(
      [
        {
          "index": "1",
          "port": "Архангельск",
          "port_code": "RUARH",
          "arrival": "2024-10-19 11:24:54.00 +02:00",
          "departure": "2024-10-19 11:24:54.00 +02:00",
          "draft_limit": "100"
        },
        {
          "port": "Азов",
          "index": "2",
          "port_code": "RUAZO",
          "arrival": "2024-10-19 09:24:54 +02:00",
          "departure": "2024-10-19 09:24:54 +02:00",
          "draft_limit": "100"
        },
        {
          "port": "Астрахань",
          "port_code": "RUAST",
          "arrival": "2024-10-21T10:11:14 +02:00",
          "departure": "2024-10-19 09:24:54 +02:00",
          "index": "3",
          "draft_limit": "600",
        },
        {
          "port": "Кемерово",
          "port_code": "RUKEM",
          "arrival": "2024-10-19 09:24:54 +02:00",
          "departure": "2024-10-19 09:24:54 +02:00",
          "index": "4",
          "draft_limit": "200",
        }
      ].map((e) => JsonItinerary(json: e)).toList(),
    );
  }
}
