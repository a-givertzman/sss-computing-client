import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/models/cargos/cargos.dart';
import 'package:sss_computing_client/presentation/cargo_details/widgets/cargo_table.dart';

class CargoDetailsPage extends StatefulWidget {
  final Cargos cargos;
  const CargoDetailsPage({super.key, required this.cargos});

  @override
  State<CargoDetailsPage> createState() => _CargoDetailsPageState();
}

class _CargoDetailsPageState extends State<CargoDetailsPage> {
  void _handleReload() {
    Log('$runtimeType').debug('Reloaded');
    setState(() {
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                const Localized('Cargo list').v,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: const Setting('padding', factor: 1.0).toDouble,
              ),
              Expanded(
                flex: 1,
                child: FutureBuilder(
                  future: widget.cargos.fetchAll(),
                  builder: (context, snapshot) {
                    return switch (snapshot.connectionState) {
                      ConnectionState.done => switch (snapshot.data!) {
                          Ok(value: final cargos) => CargoTable(cargos: cargos),
                          Err(:final error) => _AlertWidget(
                              message: error.message,
                              onConfirm: () => _handleReload(),
                            ),
                        },
                      _ => const CupertinoActivityIndicator(),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertWidget extends StatelessWidget {
  final String message;
  final void Function()? onConfirm;
  const _AlertWidget({required this.message, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).stateColors.error,
          ),
          Text(
            message,
            style: TextStyle(
              color: Theme.of(context).stateColors.error,
            ),
          ),
          TextButton(
            onPressed: () => onConfirm?.call(),
            child: Text(const Localized('Retry').v),
          ),
        ],
      ),
    );
  }
}
