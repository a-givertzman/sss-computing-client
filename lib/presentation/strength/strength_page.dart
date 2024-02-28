import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/strength/widgets/live_bar_chart.dart';

class StrengthPage extends StatelessWidget {
  const StrengthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          height: 400,
          child: LiveBarChart(),
        ),
      ),
    );
  }
}
