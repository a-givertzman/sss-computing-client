import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/extensions/future_result_extension.dart';
import 'package:sss_computing_client/core/widgets/async_action_checkbox.dart';
///
/// Cell for [TableColumn] with checkbox.
class CheckboxCellWidget extends StatelessWidget {
  static const _log = Log('CheckboxCellWidget');
  final bool _value;
  final Future<ResultF<void>> Function(bool value) _onUpdate;
  final String _activateMessage;
  final String _deactivateMessage;
  ///
  /// Creates cell widget for [TableColumn] with checkbox.
  ///
  /// Checkbox either active if [value] is `true` or inactive if [value] is `false`.
  /// To handle value update, use [onUpdate] callback.
  const CheckboxCellWidget({
    super.key,
    required bool value,
    required Future<ResultF<void>> Function(bool value) onUpdate,
    String activateMessage = '',
    String deactivateMessage = '',
  })  : _value = value,
        _onUpdate = onUpdate,
        _activateMessage = activateMessage,
        _deactivateMessage = deactivateMessage;
  //
  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return Container(
      margin: EdgeInsets.symmetric(vertical: padding),
      child: Tooltip(
        message: switch (_value) {
          true => _deactivateMessage,
          false => _activateMessage,
        },
        child: Center(
          child: AsyncActionCheckbox(
            initialValue: _value,
            onChanged: (value) => _updateValue(context, value),
          ),
        ),
      ),
    );
  }
  //
  Future<void> _updateValue(BuildContext context, bool? value) async {
    if (value == null) return;
    return _onUpdate(value).convertFailure().then((result) => result
        .inspect(
          (_) => _log.info('value updated: $value'),
        )
        .inspectErr(
          (error) => _showErrorMessage(context, error.message),
        ));
  }
  //
  void _showErrorMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    BottomMessage.error(
      message: message.truncate(),
      displayDuration: Duration(
        milliseconds: const Setting('errorMessageDisplayDuration_ms').toInt,
      ),
    ).show(context);
  }
}
