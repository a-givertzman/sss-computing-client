import 'package:flutter/material.dart';

///
/// A simple cell with a nullable value
/// ``` dart
/// value??'—'
/// ```
class NullableCellWidget<T> extends StatelessWidget {
  final T? value;

  ///
  const NullableCellWidget({
    super.key,
    this.value,
  });
  //
  @override
  Widget build(BuildContext context) {
    return Text(
      '${value ?? '—'}',
      overflow: TextOverflow.ellipsis,
    );
  }
}
