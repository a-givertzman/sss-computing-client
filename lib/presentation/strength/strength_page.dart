import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(const Setting('blockPadding').toDouble),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding:
                          EdgeInsets.all(const Setting('padding').toDouble),
                      child: const Text('Shear forces [BarChart]'),
                    ),
                  ),
                ),
                SizedBox(
                  height: const Setting('blockPadding').toDouble,
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding:
                          EdgeInsets.all(const Setting('padding').toDouble),
                      child: const Text('Bending moments [BarChart]'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: const Setting('blockPadding').toDouble,
          ),
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(const Setting('padding').toDouble),
                child: const Text('[ShipParametes]'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
