import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkhead_base_widget.dart';
///
class BulkheadEmptyWidget extends StatelessWidget {
  final double _height;
  final String _label;
  ///
  const BulkheadEmptyWidget({
    super.key,
    required double height,
    required String label,
  })  : _height = height,
        _label = label;
  //
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.25,
      child: BulkheadBaseWidget(
        borderColor: Colors.white,
        backgroundColor: Colors.transparent,
        height: _height,
        child: OverflowableText(
          Localized(_label).v,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
