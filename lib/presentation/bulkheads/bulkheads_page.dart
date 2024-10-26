import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:sss_computing_client/presentation/bulkheads/widgets/bulkheads_page_body.dart';
///
/// Page for configuration of bulkheads;
class BulkheadsPage extends StatelessWidget {
  final void Function()? _onClose;
  ///
  /// Creates page for configuration of bulkheads.
  ///
  ///  [onClose] callback is called when returning to previous page.
  const BulkheadsPage({
    super.key,
    void Function()? onClose,
  }) : _onClose = onClose;
  //
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: Tooltip(
          message: const Localized('Назад').v,
          child: TooltipVisibility(
            visible: false,
            child: BackButton(
              onPressed: () {
                navigator.pop();
                _onClose?.call();
              },
            ),
          ),
        ),
        title: Text(const Localized('Grain bulkheads installation').v),
      ),
      body: const BulkheadsPageBody(),
    );
  }
}
