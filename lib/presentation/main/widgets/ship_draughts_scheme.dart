import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/core/models/figure/box_figure.dart';
import 'package:sss_computing_client/core/models/figure/figure.dart';
import 'package:sss_computing_client/core/models/figure/line_figure.dart';
import 'package:sss_computing_client/core/models/figure/svg_path_figure.dart';
import 'package:sss_computing_client/core/models/figure/transformed_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figure.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_figures.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_layout.dart';
import 'package:sss_computing_client/core/widgets/scheme/scheme_text.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
final shipBody = SVGPathFigure(
  paints: [
    Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill,
  ],
  pathProjections: {
    FigurePlane.xy:
        'M 47.1097,6.69785 L 47.1943,6.69695 L 47.5032,6.68791 L 47.8206,6.67256 L 48.1383,6.6512 L 48.4624,6.62335  L 48.7867,6.58949 L 49.1144,6.54922 L 49.4419,6.50294 L 49.7693,6.45064 L 50.096,6.39235 L 50.4191,6.32867  L 50.7412,6.25906 L 51.0562,6.18491 L 51.3699,6.10489 L 51.6738,6.02126 L 51.9761,5.93184 L 52.2666,5.83975  L 52.5551,5.74197 L 52.8306,5.6424 L 53.1038,5.53723 L 53.3634,5.43102 L 53.6203,5.31935 L 53.8788,5.2  L 54.1134,5.08504 L 54.3451,4.96484 L 54.5635,4.84488 L 54.7787,4.71983 L 54.9813,4.59525 L 55.1804,4.46574  L 55.3678,4.33684 L 55.5515,4.2032 L 55.7244,4.07014 L 55.8932,3.93256 L 56.0522,3.79539 L 56.207,3.6539  L 56.3528,3.5126 L 56.4942,3.36719 L 56.6275,3.22157 L 56.7562,3.07208 L 56.8776,2.92189 L 56.9943,2.76808  L 57.1045,2.61293 L 57.2097,2.45442 L 57.309,2.29382 L 57.4033,2.13011 L 57.4923,1.96346 L 57.576,1.79393  L 57.6429,1.64789 L 57.706,1.5 L 57.7492,1.38634 L 57.7875,1.26878 L 57.8208,1.14999 L 57.855,1.00542  L 57.8841,0.856842 L 57.9095,0.694702 L 57.9293,0.529785 L 57.9441,0.355759 L 57.953,0.180313 L 57.956,-0  L 57.953,-0.178345 L 57.9441,-0.355972 L 57.9295,-0.527679 L 57.9092,-0.697281 L 57.8843,-0.855591 L 57.854,-1.01047  L 57.8208,-1.14999 L 57.7845,-1.27882 L 57.7429,-1.40405 L 57.706,-1.5 L 57.6308,-1.67519 L 57.5502,-1.84775  L 57.4648,-2.01636 L 57.3741,-2.18207 L 57.2782,-2.34483 L 57.1772,-2.50446 L 57.0704,-2.66203 L 56.9586,-2.81618  L 56.8404,-2.96902 L 56.7173,-3.11823 L 56.587,-3.26671 L 56.4522,-3.41132 L 56.3092,-3.55569 L 56.1619,-3.69597  L 56.0056,-3.8364 L 55.8452,-3.9725 L 55.6749,-4.10901 L 55.5006,-4.24098 L 55.3156,-4.3735 L 55.1269,-4.50131  L 54.9264,-4.62965 L 54.7226,-4.7531 L 54.5062,-4.87698 L 54.2867,-4.9958 L 54.0839,-5.09988 L 53.8788,-5.2  L 53.6317,-5.31427 L 53.3819,-5.4232 L 53.1183,-5.53146 L 52.8524,-5.63425 L 52.573,-5.73569 L 52.2915,-5.83154  L 51.9975,-5.92528 L 51.7016,-6.01331 L 51.3946,-6.09833 L 51.0861,-6.17754 L 50.7688,-6.25281 L 50.4503,-6.32219  L 50.126,-6.3867 L 49.8008,-6.44528 L 49.4732,-6.49821 L 49.1451,-6.54514 L 48.8183,-6.58588 L 48.4914,-6.62057  L 48.1692,-6.6488 L 47.8471,-6.67101 L 47.5325,-6.68674 L 47.2182,-6.69646 L 47.0834,-6.69832 L 46.886,-6.7  L -61.994,-6.7 L -61.994,6.7 L 46.886,6.7 z ',
    FigurePlane.xz:
        'M 57.856,6.79999 L 57.8528,6.56166 L 57.843,6.325 L 57.8261,6.08667 L 57.8149,5.96812 L 57.8016,5.84999  L 57.7861,5.73058 L 57.7683,5.6116 L 57.7481,5.49307 L 57.7255,5.375 L 57.6998,5.25548 L 57.6713,5.13647  L 57.6401,5.01797 L 57.606,4.89999 L 57.5441,4.69942 L 57.4803,4.5 L 57.4111,4.29283 L 57.3395,4.08749  L 57.2636,3.88008 L 57.1844,3.67499 L 57.0995,3.46724 L 57.0101,3.2625 L 56.947,3.12582 L 56.8814,2.99077  L 56.8132,2.85742 L 56.7422,2.72588 L 56.6682,2.59627 L 56.5909,2.46867 L 56.5286,2.37128 L 56.4642,2.27521  L 56.3975,2.18056 L 56.3285,2.08737 L 56.1991,1.92497 L 56.1313,1.8457 L 56.0613,1.76778 L 55.9864,1.68863  L 55.9091,1.61102 L 55.8292,1.53499 L 55.7466,1.46059 L 55.6613,1.38788 L 55.5732,1.31691 L 55.4821,1.24771  L 55.3881,1.18034 L 55.2888,1.11337 L 55.1863,1.04842 L 55.0805,0.985489 L 54.9714,0.924652 L 54.8588,0.865936  L 54.7428,0.809372 L 54.6156,0.751587 L 54.4843,0.696274 L 54.3491,0.643448 L 54.2098,0.59314 L 54.0664,0.545334  L 53.9189,0.5 L 53.7563,0.454132 L 53.5891,0.411118 L 53.4045,0.368027 L 53.2148,0.328125 L 52.9343,0.276276  L 52.6439,0.230469 L 52.3821,0.195068 L 52.1132,0.163757 L 51.8264,0.135269 L 51.5324,0.110565 L 51.2371,0.0897217  L 50.9356,0.0719147 L 50.5665,0.054184 L 50.1895,0.0398865 L 49.8054,0.0285492 L 49.4148,0.0197144 L 48.7696,0.00968933  L 48.1135,0.00372314 L 46.886,-0 L -47.394,-0 L -47.7932,0.00317383 L -47.9296,0.0057373 L -48.1924,0.0127411  L -48.4082,0.0205688 L -48.5916,0.0286865 L -48.7764,0.0382385 L -48.9908,0.0510406 L -49.1443,0.0613403 L -49.3902,0.0798187  L -49.5121,0.0898743 L -49.6699,0.104477 L -49.7892,0.11499 L -49.8794,0.123856 L -50.1125,0.148239 L -50.2606,-0  L -57.4214,-0 L -57.5533,0.000305176 L -57.7162,0.00245667 L -57.879,0.00785828 L -58.0402,0.017746 L -58.1994,0.033371  L -58.3691,0.0585175 L -58.4711,0.07901 L -58.5677,0.103104 L -58.7136,0.15062 L -58.7819,0.178787 L -58.8444,0.208832  L -58.9123,0.247253 L -58.9722,0.287506 L -59.0294,0.333206 L -59.0783,0.380157 L -59.1224,0.430969 L -59.1593,0.482529  L -59.1932,0.541016 L -59.2202,0.599991 L -59.5781,1.48999 L -59.5781,1.95 L -59.3961,2.31349 L -61.994,3  L -61.994,6.84999 L -45.594,6.84999 L -45.594,8.23 L 34.956,8.23 L 34.956,6.84999 L 37.556,6.84999  L 37.556,9.7 L 57.956,9.7 z M 51.3325,2.19943 L 51.2846,2.19487 L 51.2296,2.18375 L 51.1908,2.17192 L 51.1574,2.15886 L 51.0967,2.12749  L 51.0427,2.08968 L 51.0145,2.06522 L 50.9901,2.04076 L 50.964,2.01031 L 50.9418,1.98004 L 50.9194,1.94371  L 50.9012,1.90775 L 50.8823,1.85992 L 50.8689,1.81287 L 50.8597,1.76045 L 50.856,1.7 L 50.8602,1.63528  L 50.8695,1.58464 L 50.8839,1.53526 L 50.9001,1.49466 L 50.9201,1.45503 L 50.9679,1.38477 L 51.0233,1.32674  L 51.0823,1.28159 L 51.1412,1.24849 L 51.1975,1.22578 L 51.2496,1.21143 L 51.2971,1.20348 L 51.3401,1.20024  L 51.38,1.20056 L 51.4166,1.20367 L 51.4638,1.21176 L 51.4947,1.21962 L 51.5215,1.22816 L 51.5518,1.23993  L 51.5782,1.25206 L 51.6066,1.26733 L 51.6317,1.28287 L 51.6615,1.30417 L 51.6876,1.32574 L 51.7175,1.35455  L 51.7433,1.38371 L 51.7711,1.42123 L 51.7942,1.45926 L 51.8167,1.5056 L 51.8338,1.55257 L 51.8488,1.61563  L 51.856,1.7 L 51.8534,1.75099 L 51.8454,1.8024 L 51.8332,1.84924 L 51.8159,1.89624 L 51.7963,1.93687  L 51.772,1.97742 L 51.7475,2.01103 L 51.7185,2.04437 L 51.6597,2.09717 L 51.5992,2.13687 L 51.5395,2.1651  L 51.4825,2.18372 L 51.4291,2.19461 L 51.3794,2.19945 z ',
    FigurePlane.yz:
        'M 1.14999,9.7 L 5.2,9.56 L 6.7,9.50999 L 6.7,0.5 L 6.69814,0.456985 L 6.69296,0.416473  L 6.6924,0.413162 L 6.68294,0.370514 L 6.66985,0.328979 L 6.66953,0.328125 L 6.64716,0.276276 L 6.63301,0.25  L 6.62112,0.230469 L 6.59576,0.194427 L 6.58301,0.178604 L 6.56903,0.162628 L 6.54149,0.134766 L 6.52139,0.116974  L 6.5136,0.110565 L 6.45836,0.0719147 L 6.45,0.0669861 L 6.39571,0.0398865 L 6.371,0.0301514 L 6.33904,0.0197144  L 6.29797,0.00968933 L 6.28682,0.00758362 L 6.26094,0.00372314 L 6.2,-0 L -6.2,-0 L -6.26094,0.00372314  L -6.28682,0.00758362 L -6.29797,0.00968933 L -6.33904,0.0197144 L -6.371,0.0301514 L -6.39571,0.0398865 L -6.45,0.0669861  L -6.45836,0.0719147 L -6.5136,0.110565 L -6.52139,0.116974 L -6.54149,0.134766 L -6.56903,0.162628 L -6.58301,0.178604  L -6.59576,0.194427 L -6.62112,0.230469 L -6.63301,0.25 L -6.64716,0.276276 L -6.66953,0.328125 L -6.66985,0.328979  L -6.68294,0.370514 L -6.6924,0.413162 L -6.69296,0.416473 L -6.69814,0.456985 L -6.7,0.5 L -6.7,9.50999  L -5.2,9.56 L -1.14999,9.7 z ',
  },
);
///
class ShipDraughtsScheme extends StatelessWidget {
  ///
  const ShipDraughtsScheme({super.key});
  //
  @override
  Widget build(BuildContext context) {
    const draught = 4.0;
    const massShiftX = 0.0;
    const massShiftY = 0.0;
    const trimAngle = 0.0;
    const heelAngle = 0.0;
    final waterlineFigure = RectangularCuboid(
      start: Vector3(-140.0, -20.0, -20.0),
      end: Vector3(140.0, 20.0, 0.0),
      paints: [
        Paint()
          ..color = Colors.blue.withOpacity(0.25)
          ..style = PaintingStyle.fill,
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke,
      ],
    );
    final trimTransform = Matrix4.identity()
      ..translate(0.0, -draught)
      ..translate(massShiftX, draught)
      ..rotateZ(degrees2Radians * trimAngle)
      ..translate(-massShiftX, -draught);
    final heelTransform = Matrix4.identity()
      ..translate(0.0, -draught)
      ..translate(massShiftY, draught)
      ..rotateZ(degrees2Radians * heelAngle)
      ..translate(-massShiftY, -draught);
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      backgroundColor: theme.colorScheme.primary.withOpacity(0.75),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: SchemeLayout(
            fit: BoxFit.contain,
            minX: -10.0,
            maxX: 10.0,
            minY: -10.0,
            maxY: 10.0,
            yAxisReversed: true,
            buildContent: (ctx, transform) => Stack(
              children: [
                SchemeFigures(
                  plane: FigurePlane.yz,
                  figures: [
                    TransformedProjectionFigure(
                      figure: shipBody,
                      transform: heelTransform,
                    ),
                    waterlineFigure,
                    TransformedProjectionFigure(
                      figure: LineSegmentFigure(
                        start: const Offset(-20.0, 0.0),
                        end: const Offset(20.0, 0.0),
                        paints: [
                          Paint()
                            ..color = Colors.white
                            ..style = PaintingStyle.stroke,
                        ],
                      ),
                      transform: heelTransform,
                    ),
                  ],
                  layoutTransform: transform,
                ),
                SchemeText(
                  text:
                      '${const Localized('Heel').v} $heelAngle${const Localized('°').v}',
                  offset: const Offset(0.0, 10.0),
                  alignment: const Alignment(0.0, 2.0),
                  style: labelStyle,
                  layoutTransform: transform,
                ),
                _DraugthLabel(
                  draught: draught,
                  draughtShift: 0.0,
                  massShift: massShiftY,
                  angle: heelAngle,
                  layoutTransform: transform,
                  draughtsTransform: heelTransform,
                  label: '',
                  labelStyle: labelStyle,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          flex: 7,
          child: SchemeLayout(
            fit: BoxFit.contain,
            minX: -70.0,
            maxX: 70.0,
            minY: -10.0,
            maxY: 10.0,
            yAxisReversed: true,
            buildContent: (ctx, transform) => Stack(
              children: [
                SchemeFigures(
                  plane: FigurePlane.xz,
                  figures: [
                    TransformedProjectionFigure(
                      figure: shipBody,
                      transform: trimTransform,
                    ),
                    waterlineFigure,
                    TransformedProjectionFigure(
                      figure: LineSegmentFigure(
                        start: const Offset(-140.0, 0.0),
                        end: const Offset(140.0, 0.0),
                        paints: [
                          Paint()
                            ..color = Colors.white
                            ..style = PaintingStyle.stroke,
                        ],
                      ),
                      transform: trimTransform,
                    ),
                  ],
                  layoutTransform: transform,
                ),
                SchemeText(
                  text:
                      '${const Localized('Trim').v} $trimAngle${const Localized('°').v}',
                  alignment: const Alignment(0.0, 2.0),
                  offset: const Offset(0.0, 10.0),
                  style: labelStyle,
                  layoutTransform: transform,
                ),
                _DraugthLabel(
                  draught: draught,
                  draughtShift: -50.0,
                  massShift: massShiftX,
                  angle: trimAngle,
                  layoutTransform: transform,
                  draughtsTransform: trimTransform,
                  label: const Localized('AP').v,
                  labelStyle: labelStyle,
                ),
                _DraugthLabel(
                  draught: draught,
                  draughtShift: massShiftX,
                  massShift: massShiftX,
                  angle: trimAngle,
                  layoutTransform: transform,
                  draughtsTransform: trimTransform,
                  label: const Localized('MP').v,
                  labelStyle: labelStyle,
                ),
                _DraugthLabel(
                  draught: draught,
                  draughtShift: 50.0,
                  massShift: massShiftX,
                  angle: trimAngle,
                  layoutTransform: transform,
                  draughtsTransform: trimTransform,
                  label: const Localized('FP').v,
                  labelStyle: labelStyle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
///
class _DraugthLabel extends StatelessWidget {
  final double draught;
  final double draughtShift;
  final double massShift;
  final double angle;
  final Matrix4 layoutTransform;
  final Matrix4 draughtsTransform;
  final String label;
  final TextStyle? labelStyle;
  ///
  const _DraugthLabel({
    required this.draught,
    required this.draughtShift,
    required this.massShift,
    required this.angle,
    required this.layoutTransform,
    required this.draughtsTransform,
    required this.label,
    this.labelStyle,
  });
  @override
  Widget build(BuildContext context) {
    final radians = degrees2Radians * angle;
    final dy = tan(radians) * (draughtShift - massShift);
    final dx = draughtShift / cos(radians);
    return Stack(
      children: [
        SchemeFigure(
          plane: FigurePlane.xz,
          figure: TransformedProjectionFigure(
            figure: LineSegmentFigure(
              paints: [
                Paint()
                  ..color = Colors.white
                  ..style = PaintingStyle.stroke,
              ],
              start: Offset(dx, 0.0),
              end: Offset(dx, draught - dy),
            ),
            transform: draughtsTransform,
          ),
          layoutTransform: layoutTransform,
        ),
        SchemeText(
          text:
              '$label ${(draught - dy).toStringAsFixed(2)} ${const Localized('m').v}',
          offset: Offset(dx, 0.0),
          alignment: const Alignment(0.0, -2.0),
          layoutTransform: layoutTransform,
          style: labelStyle,
        ),
      ],
    );
  }
}
