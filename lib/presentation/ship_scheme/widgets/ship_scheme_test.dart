import 'package:flutter/material.dart';
import 'package:sss_computing_client/core/models/cargo/cargo.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_chemes.dart';

///
class ShipSchemeTest extends StatefulWidget {
  final List<Cargo> cargos;

  ///
  const ShipSchemeTest({super.key, required this.cargos});

  @override
  State<ShipSchemeTest> createState() => _ShipSchemeTestState();
}

class _ShipSchemeTestState extends State<ShipSchemeTest> {
  Cargo? _selectedCargo;

  ///
  @override
  Widget build(BuildContext context) {
    return ShipSchemes(
      cargos: widget.cargos,
      selectedCargo: _selectedCargo,
      onCargoSelect: _toggleSelectedCargo,
    );
  }

  ///
  void _toggleSelectedCargo(Cargo cargo) {
    if (cargo != _selectedCargo) {
      setState(() {
        _selectedCargo = cargo;
      });
      return;
    }
    setState(() {
      _selectedCargo = null;
    });
  }
}
