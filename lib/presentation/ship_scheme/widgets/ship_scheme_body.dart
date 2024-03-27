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
    const minX = -400.0;
    const maxX = 400.0;
    const minY = 0.0;
    const maxY = 400.0;
    const frameTNumber = 20;
    const frameRNumber = 100;
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: ShipScheme(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            xAxis: const ChartAxis(
              caption: 'm',
              labelsSpaceReserved: 25.0,
              valueInterval: 100.0,
              isGridVisible: false,
            ),
            yAxis: const ChartAxis(
              caption: 'm',
              labelsSpaceReserved: 25.0,
              valueInterval: 50.0,
              isGridVisible: false,
            ),
            framesTheoretic:
                List<(double, double, String)>.generate(frameTNumber, (index) {
              const width = (maxX - minX) / frameTNumber;
              return (
                minX + index * width,
                minX + (index + 1) * width,
                '${(index + 1).toString()}${index == 0 ? 'FR.T' : ''}'
              );
            }),
            framesReal: List<(double, String)>.generate(frameRNumber, (index) {
              const width = (maxX - minX) / frameRNumber;
              return (
                minX + index * width,
                '${(index + 1).toString()}${index == 0 ? 'FR.R' : ''}'
              );
            }),
          ),
        ),
      ),
    );
  }
}
