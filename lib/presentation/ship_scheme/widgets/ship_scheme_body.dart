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
    final controller = TransformationController();
    const minX = -100.0;
    const maxX = 100.0;
    const minY = -10.0;
    const maxY = 20.0;
    const frameTNumber = 20;
    const frameRNumber = 100;
    final framesTheoretic = List<(double, double, String)>.generate(
      frameTNumber,
      (index) {
        const width = (maxX - minX) / frameTNumber;
        return (
          minX + index * width,
          minX + (index + 1) * width,
          // '$index${index == 0 ? 'FT' : ''}'
          '${index}FT'
        );
      },
    );
    final framesReal = [
      ...List<(double, String)>.generate(25, (index) {
        const width = (maxX - minX) / 2 / frameRNumber;
        // return (minX + index * width, '$index${index == 0 ? 'FR' : ''}');
        return (minX + index * width, '${index}FR');
      }),
      ...List<(double, String)>.generate(25, (index) {
        const width = (maxX - minX) / frameRNumber;
        return (
          minX + ((maxX - minX) / 2 / frameRNumber) * 25 + (index) * width,
          '${index + 25}FR'
        );
      }),
      ...List<(double, String)>.generate(50, (index) {
        const width = (maxX - minX) / 2 / frameRNumber;
        return (
          minX +
              ((maxX - minX) / 2 / frameRNumber) * 25 +
              ((maxX - minX) / frameRNumber) * 25 +
              (index) * width,
          '${index + 50}FR'
        );
      }),
      ...List<(double, String)>.generate(25, (index) {
        const width = (maxX - minX) / frameRNumber;
        return (
          minX +
              ((maxX - minX) / 2 / frameRNumber) * 75 +
              ((maxX - minX) / frameRNumber) * 25 +
              (index) * width,
          '${index + 100}FR'
        );
      }),
      ...List<(double, String)>.generate(25, (index) {
        const width = (maxX - minX) / 2 / frameRNumber;
        return (
          minX +
              ((maxX - minX) / 2 / frameRNumber) * 25 +
              ((maxX - minX) / frameRNumber) * 75 +
              (index) * width,
          '${index + 125}FR'
        );
      }),
    ];
    return Center(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(const Setting('padding').toDouble),
          child: SizedBox(
            width: 1800.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // InteractiveViewer(
                //   trackpadScrollCausesScale: false,
                // child:
                ShipScheme(
                  caption: 'Profile view',
                  minX: minX,
                  maxX: maxX,
                  minY: minY,
                  maxY: maxY,
                  xAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 25.0,
                    isGridVisible: false,
                  ),
                  yAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 10.0,
                    isGridVisible: false,
                  ),
                  body: ('assets/img/side3.svg', -100.0, 100.0),
                  framesTheoretic: framesTheoretic,
                  framesReal: framesReal,
                  trController: controller,
                ),
                // ),
                ShipScheme(
                  caption: 'Top view',
                  minX: minX,
                  maxX: maxX,
                  minY: -20.0,
                  maxY: 20.0,
                  xAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 25.0,
                    isGridVisible: false,
                  ),
                  yAxis: const ChartAxis(
                    caption: 'm',
                    labelsSpaceReserved: 25.0,
                    valueInterval: 10.0,
                    isGridVisible: false,
                  ),
                  body: ('assets/img/top3.svg', -100.0, 100.0),
                  framesTheoretic: framesTheoretic,
                  framesReal: framesReal,
                  trController: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
