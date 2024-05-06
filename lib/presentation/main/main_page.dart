import 'package:flutter/material.dart';
import 'package:sss_computing_client/presentation/main/widgets/main_body.dart';
///
class MainPage extends StatelessWidget {
  static const routeName = '/main';
  ///
  const MainPage({super.key});
  ///
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MainBody(),
    );
  }
}
