import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_failure.dart';

import 'package:sss_computing_client/core/models/ship/ship.dart';


///
/// Ship general details collection that stored in postgres DB.
/// TODO: Postgres database access implementation
///
class PgShipDetails {
  Future<Result<JsonShip, Failure<String>>> fetchShip() async {
    return Ok(
      JsonShip({
        "ship_name": "Наименование судна",
        "call_sign": "Позывной",
        "imo": "Номер ИМО",
        "ship_type": "Тип судна",
        "ship_classification": "Классификационное общество",
        "registration": "Регистровый номер",
        "registration_port": "Порт приписки",
        "flag_state": "Флаг приписки",
        "ship_owner": "Cудовладелец",
        "ship_owner_code": "Код судовладельца",
        "build_yard": "Верфь постройки",
        "build_place": "Место постройки",
        "build_year": "Год постройки",
        "ship_builder_number": "Заводской номер",
        "ship_master": "Капитан",
        "ship_chief_mate": "Старший помощник капитана"
      }),
    );
  }
}
