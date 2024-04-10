import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

///
class CellActionButtons extends StatefulWidget {
  final String? _validationError;
  final Failure? _error;
  final void Function()? _onConfirm;
  final void Function()? _onCancel;
  final double? _iconSize;
  final Color? _iconColor;
  final Color? _errorColor;

  ///
  const CellActionButtons({
    super.key,
    String? validationError,
    Failure<dynamic>? error,
    void Function()? onConfirm,
    void Function()? onCancel,
    double? iconSize,
    Color? iconColor,
    Color? errorColor,
  })  : _errorColor = errorColor,
        _iconColor = iconColor,
        _onCancel = onCancel,
        _iconSize = iconSize,
        _onConfirm = onConfirm,
        _error = error,
        _validationError = validationError;

  ///
  @override
  State<CellActionButtons> createState() => _CellActionButtonsState();
}

///
class _CellActionButtonsState extends State<CellActionButtons> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = IconTheme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget._validationError != null
            ? SizedBox(
                width: widget._iconSize ?? iconTheme.size,
                height: widget._iconSize ?? iconTheme.size,
                child: Tooltip(
                  message: Localized(
                    widget._validationError ?? 'Values must be valid',
                  ).v,
                  child: Icon(
                    Icons.warning_rounded,
                    color: widget._errorColor ?? theme.colorScheme.error,
                  ),
                ),
              )
            : SizedBox(
                width: widget._iconSize ?? iconTheme.size,
                height: widget._iconSize ?? iconTheme.size,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: widget._onConfirm,
                  child: Icon(
                    Icons.done,
                    color: widget._iconColor ?? theme.colorScheme.primary,
                  ),
                ),
              ),
        SizedBox(
          width: widget._iconSize ?? iconTheme.size,
          height: widget._iconSize ?? iconTheme.size,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget._onCancel,
            child: Icon(
              Icons.close,
              color: widget._iconColor ?? theme.colorScheme.primary,
            ),
          ),
        ),
        if (widget._error != null)
          SizedBox(
            width: widget._iconSize ?? iconTheme.size,
            height: widget._iconSize ?? iconTheme.size,
            child: Tooltip(
              message:
                  Localized(widget._error?.message ?? 'Something went wrong').v,
              child: Icon(
                Icons.error_outline,
                color: widget._errorColor ?? theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
