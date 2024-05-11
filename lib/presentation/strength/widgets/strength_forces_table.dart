import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sss_computing_client/core/models/strength/strength_force.dart';
import 'package:sss_computing_client/presentation/strength/widgets/table_widget/table_widget.dart';
///
class StrengthForceTable extends StatelessWidget {
  final String _valueUnit;
  final Stream<List<StrengthForce>> _stream;
  ///
  const StrengthForceTable({
    super.key,
    required String valueUnit,
    required Stream<List<StrengthForce>> stream,
  })  : _valueUnit = valueUnit,
        _stream = stream;
  //
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (_, snapshot) {
        return snapshot.hasData
            ? TableWidget(
                valueUnit: _valueUnit,
                strengthForces: snapshot.data!,
              )
            : const Center(child: CupertinoActivityIndicator());
      },
    );
  }
}
