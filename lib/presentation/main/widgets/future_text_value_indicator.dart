import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/widgets/future_builder_widget.dart';
///
/// Widget to showing current value as text.
class FTextValueIndicator extends StatelessWidget {
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final Future<ResultF<num>> Function() _fetch;
  final String _caption;
  final String? _unit;
  final double? _width;
  ///
  /// Creates widget that indicating current value as text.
  ///
  /// - [fetch] – fetching data and returns future;
  /// - [caption] – name of the value to show;
  /// - [unit] – unit of the value to show;
  /// - [width] – width of the widget.
  const FTextValueIndicator({
    super.key,
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required Future<ResultF<num>> Function() fetch,
    required String caption,
    String? unit,
    double? width = 250,
  })  : _appRefreshStream = appRefreshStream,
        _fetch = fetch,
        _caption = caption,
        _unit = unit,
        _width = width;
  //
  @override
  Widget build(BuildContext context) {
    const textScaleFactor = 1.3;
    final textTheme = Theme.of(context).textTheme;
    final captionTextStyle = textTheme.bodySmall;
    final valueTextStyle = textTheme.bodyLarge;
    return TextIndicatorWidget(
      width: _width,
      caption: OverflowableText(
        _caption,
        style: captionTextStyle,
        textScaleFactor: textScaleFactor,
      ),
      indicator: _FValueIndicator(
        appRefreshStream: _appRefreshStream,
        fetch: _fetch,
        unit: _unit,
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
  final Stream<DsDataPoint<bool>> _appRefreshStream;
  final Future<ResultF<num>> Function() _fetch;
  final int _fractionDigits;
  final String? _unit;
  final TextStyle? _valueTextStyle;
  final TextStyle? _unitTextStyle;
  final double _textScaleFactor;
  ///
  const _FValueIndicator({
    required Stream<DsDataPoint<bool>> appRefreshStream,
    required Future<ResultF<num>> Function() fetch,
    int fractionDigits = 0,
    String? unit,
    TextStyle? valueTextStyle,
    TextStyle? unitTextStyle,
    double textScaleFactor = 1.0,
  })  : _appRefreshStream = appRefreshStream,
        _fetch = fetch,
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
            refreshStream: _appRefreshStream,
            onFuture: _fetch,
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
          if (_unit != null)
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                _unit,
                style: _unitTextStyle,
                textScaler: TextScaler.linear(_textScaleFactor),
              ),
            ),
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
