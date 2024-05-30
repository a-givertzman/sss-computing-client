import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
///
/// Shows current value and its unit
class FTextValueIndicator extends StatelessWidget {
  final Future<ResultF<num>> future;
  final String caption;
  final String? unit;
  final double width;
  ///
  /// Creates widget that indicate current value
  ///
  /// - `future` - used to get value;
  /// - `caption` - name of the value;
  /// - `unit` - unit of the value;
  /// - `width` - width of the widget.
  const FTextValueIndicator({
    super.key,
    required this.future,
    required this.caption,
    this.unit,
    this.width = 250,
  });
  //
  @override
  Widget build(BuildContext context) {
    const textScaleFactor = 1.3;
    final textTheme = Theme.of(context).textTheme;
    final captionTextStyle = textTheme.bodySmall;
    final valueTextStyle = textTheme.bodyLarge;
    return TextIndicatorWidget(
      width: width,
      caption: OverflowableText(
        caption,
        style: captionTextStyle,
        textScaleFactor: textScaleFactor,
      ),
      indicator: _FValueIndicator(
        future: future,
        unit: unit,
        valueTextStyle: valueTextStyle,
        unitTextStyle: captionTextStyle,
        textScaleFactor: textScaleFactor,
      ),
      alignment: Alignment.centerLeft,
    );
  }
}
///
class _FValueIndicator extends StatelessWidget {
  final Future<ResultF<num>> _future;
  final int _fractionDigits;
  final String? _unit;
  final TextStyle? _valueTextStyle;
  final TextStyle? _unitTextStyle;
  final double _textScaleFactor;
  ///
  const _FValueIndicator({
    required Future<ResultF<num>> future,
    int fractionDigits = 0,
    String? unit,
    TextStyle? valueTextStyle,
    TextStyle? unitTextStyle,
    double textScaleFactor = 1.0,
  })  : _future = future,
        _fractionDigits = fractionDigits,
        _unit = unit,
        _valueTextStyle = valueTextStyle,
        _unitTextStyle = unitTextStyle,
        _textScaleFactor = textScaleFactor;
  //
  @override
  Widget build(BuildContext context) {
    final height = switch (_valueTextStyle?.fontSize) {
      final double size => size * _textScaleFactor,
      null => null,
    };
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FutureBuilderWidget(
            onFuture: () => _future,
            caseData: (context, data, _) => _buildValueWidget(
              context,
              data,
            ),
            caseError: (context, error, _) => _buildErrorWidget(
              context,
              Failure(message: '$error', stackTrace: StackTrace.current),
            ),
            caseLoading: (_) => const CupertinoActivityIndicator(),
          ),
          if (_unit != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                _unit,
                style: _unitTextStyle,
                textScaler: TextScaler.linear(_textScaleFactor),
              ),
            ),
          ],
        ],
      ),
    );
  }
  //
  Widget _buildValueWidget(BuildContext context, num value) {
    return Text(
      value.toStringAsFixed(_fractionDigits),
      style: _valueTextStyle?.copyWith(
        height: 1.0,
      ),
      textScaler: TextScaler.linear(_textScaleFactor),
    );
  }
  //
  Widget _buildErrorWidget(BuildContext context, Failure error) {
    final theme = Theme.of(context);
    return Tooltip(
      message: '${const Localized('Data loading error').v}: ${error.message}',
      child: Icon(
        Icons.error_outline,
        color: theme.stateColors.error,
      ),
    );
  }
}
