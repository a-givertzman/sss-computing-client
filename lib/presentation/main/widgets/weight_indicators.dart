import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/models/field_record/field_record.dart';
import 'package:sss_computing_client/presentation/main/widgets/future_text_value_indicator.dart';
///
/// Widget for indicating ship weights.
class WeightIndicators extends StatelessWidget {
  final ApiAddress _apiAddress;
  final String _dbName;
  final String? _authToken;
  ///
  /// Creates widget that fetching data about ship weigths
  /// and displaying its as text value indicator widgets.
  ///
  ///   - `apiAddress` - [ApiAddress] of server that interact with database;
  ///   - `dbName` - name of the database;
  ///   - `authToken` - string authentication token for accessing server.
  const WeightIndicators({
    super.key,
    required ApiAddress apiAddress,
    required String dbName,
    String? authToken,
  })  : _apiAddress = apiAddress,
        _dbName = dbName,
        _authToken = authToken;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'ballast',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Ballast').v,
                      unit: const Localized('t').v,
                    ),
                    SizedBox(height: padding),
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'store',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Stores').v,
                      unit: const Localized('t').v,
                    ),
                    SizedBox(height: padding),
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'cargo',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Cargo').v,
                      unit: const Localized('t').v,
                    ),
                    SizedBox(height: padding),
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'deadweight',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Deadweight').v,
                      unit: const Localized('t').v,
                    ),
                  ],
                ),
              ),
              SizedBox(width: padding),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'lightship',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Lightship').v,
                      unit: const Localized('t').v,
                    ),
                  ],
                ),
              ),
              SizedBox(width: padding),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'icing',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Icing').v,
                      unit: const Localized('t').v,
                    ),
                    SizedBox(height: padding),
                    FTextValueIndicator(
                      future: FieldRecord<double>(
                        tableName: 'loads_general',
                        fieldName: 'wetting',
                        dbName: _dbName,
                        apiAddress: _apiAddress,
                        authToken: _authToken,
                        toValue: (value) => double.parse(value),
                      ).fetch(),
                      caption: const Localized('Wetting').v,
                      unit: const Localized('t').v,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: padding),
        Center(
          child: FTextValueIndicator(
            future: FieldRecord<double>(
              tableName: 'loads_general',
              fieldName: 'displacement',
              dbName: _dbName,
              apiAddress: _apiAddress,
              authToken: _authToken,
              toValue: (value) => double.parse(value),
            ).fetch(),
            caption: const Localized('Displacement').v,
            unit: const Localized('t').v,
          ),
        ),
      ],
    );
  }
}
