import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
///
class AsyncActionCheckbox extends StatefulWidget {
  final bool? _initialValue;
  final Future<void> Function(bool?)? _onChanged;
  final Color? _activeColor;
  final Color? _indicatorColor;
  ///
  const AsyncActionCheckbox({
    super.key,
    required bool? initialValue,
    Future<void> Function(bool?)? onChanged,
    Color? activeColor,
    Color? indicatorColor,
  })  : _initialValue = initialValue,
        _onChanged = onChanged,
        _activeColor = activeColor,
        _indicatorColor = indicatorColor;
  //
  @override
  State<AsyncActionCheckbox> createState() => _AsyncActionCheckboxState();
}
class _AsyncActionCheckboxState extends State<AsyncActionCheckbox> {
  late bool _isLoading;
  //
  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _isLoading
        ? CupertinoActivityIndicator(
            color: widget._indicatorColor,
          )
        : Checkbox(
            activeColor: widget._activeColor ?? theme.colorScheme.primary,
            value: widget._initialValue,
            onChanged: widget._onChanged != null ? _onChanged : null,
          );
  }
  void _onChanged(bool? value) {
    final onChanged = widget._onChanged;
    if (onChanged == null) return;
    setState(() {
      _isLoading = true;
    });
    onChanged(value).whenComplete(
      () => setState(() {
        _isLoading = false;
      }),
    );
  }
}
