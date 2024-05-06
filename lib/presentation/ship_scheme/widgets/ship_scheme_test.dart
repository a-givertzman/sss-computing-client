import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_chemes.dart';
///
class ShipCargoModel with ChangeNotifier {
  List<Cargo> cargos;
  Cargo? selectedCargo;
  ShipCargoModel({
    required this.cargos,
    this.selectedCargo,
  });
  ///
  void setCargos(List<Cargo> newCargos) {
    cargos = newCargos;
    notifyListeners();
  }
  ///
  void toggleSelected(Cargo? cargo) {
    if (cargo != selectedCargo) {
      selectedCargo = cargo;
      notifyListeners();
      return;
    }
    selectedCargo = null;
    notifyListeners();
  }
}
///
class ShipSchemeTestPage extends StatefulWidget {
  final List<Cargo> _cargos;
  ///
  const ShipSchemeTestPage({
    super.key,
    required List<Cargo> cargos,
  }) : _cargos = cargos;
  //
  @override
  State<ShipSchemeTestPage> createState() => _ShipSchemeTestPageState(
        cargos: _cargos,
      );
}
///
class _ShipSchemeTestPageState extends State<ShipSchemeTestPage> {
  final List<Cargo> _cargos;
  _ShipSchemeTestPageState({
    required List<Cargo> cargos,
  }) : _cargos = cargos;
  //
  @override
  Widget build(BuildContext context) {
    final shipCargoNotifier = ShipCargoModel(cargos: _cargos);
    final padding = const Setting('padding').toDouble;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: ShipSchemes(
              shipCargoNotifier: shipCargoNotifier,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
