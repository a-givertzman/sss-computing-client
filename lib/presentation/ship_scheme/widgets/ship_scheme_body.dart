import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/chart_axis.dart';
import 'package:sss_computing_client/presentation/ship_scheme/widgets/ship_scheme.dart';

///
class ShipSchemeBody extends StatelessWidget {
  const ShipSchemeBody({super.key});

  ///
  @override
  Widget build(BuildContext context) {
    const minX = 0.0;
    const maxX = 800.0;
    const frameNumber = 20;
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: ShipScheme(
            xAxis: const ChartAxis(
              caption: 'Ship Length [m]',
              captionSpaceReserved: 20.0,
              labelsSpaceReserved: 25.0,
              valueInterval: 100.0,
              isGridVisible: false,
            ),
            frames:
                List<(double, double, String)>.generate(frameNumber, (index) {
              const width = (maxX - minX) / frameNumber;
              return (
                minX + index * width,
                minX + (index + 1) * width,
                'F${(index + 1).toString()}'
              );
            }),
            minX: minX,
            maxX: maxX,
          ),
        ),
      ),
    );
  }
}
