import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/models/cargo/cargo.dart';
import 'package:sss_computing_client/presentation/cargo_details/widgets/table_view/table_view.dart';

class CargoDetailsPage extends StatefulWidget {
  const CargoDetailsPage({super.key});

  @override
  State<CargoDetailsPage> createState() => _CargoDetailsPageState();
}

class _CargoDetailsPageState extends State<CargoDetailsPage> {
  late final List<Cargo> _cargos;
  late final DaviModel<Cargo> _model;

  @override
  void initState() {
    _cargos = List.generate(
      100,
      (index) => {
        'id': index,
        'name': '123asd-$index',
        'weight': (index * 10).toDouble(),
      },
    ).map((json) => JsonCargo(json: json)).toList();
    _model = DaviModel(
      columns: [
        DaviColumn(
          name: 'id',
          intValue: (cargo) => cargo.id,
        ),
        DaviColumn(
          name: 'name',
          stringValue: (cargo) => cargo.name,
        ),
        DaviColumn(
          name: 'weight',
          doubleValue: (cargo) => cargo.weight,
        ),
      ],
      rows: _cargos,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: TableView<Cargo>(
            model: _model,
            columnWidthBehavior: ColumnWidthBehavior.fit,
          ),
        ),
      ),
    );
  }
}
