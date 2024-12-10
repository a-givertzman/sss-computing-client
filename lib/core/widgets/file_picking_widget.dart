import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/core/widgets/form/async_action_button.dart';

///
/// Widget for picking directory and proceeding it.
class DirectoryPickingWidget extends StatefulWidget {
  final String _title;
  final String _selectionButtonLabel;
  final String _proceedButtonLabel;
  final void Function(String) _proceedPicked;

  ///
  /// Widget for picking directory and proceeding it,
  /// using [proceedPicked] callback.
  const DirectoryPickingWidget({
    super.key,
    required String title,
    required String selectionButtonLabel,
    required String proceedButtonLabel,
    required void Function(String) proceedPicked,
  })  : _proceedButtonLabel = proceedButtonLabel,
        _selectionButtonLabel = selectionButtonLabel,
        _title = title,
        _proceedPicked = proceedPicked;
  //
  @override
  State<DirectoryPickingWidget> createState() => _DirectoryPickingWidgetState();
}

///
class _DirectoryPickingWidgetState extends State<DirectoryPickingWidget> {
  Option<String> _pickedDirectory = const None();
  //
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final padding = const Setting('blockPadding').toDouble;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget._title,
          style: textTheme.titleLarge,
        ),
        SizedBox(height: padding * 1.5),
        SizedBox(
          height: padding * 1.5,
          child: switch (_pickedDirectory) {
            Some(value: final path) => Text(path),
            None() => Text(const Localized('directory not selected').v),
          },
        ),
        SizedBox(height: padding),
        AsyncActionButton(
          icon: Icons.folder_rounded,
          label: widget._selectionButtonLabel,
          onPressed: _pickDirectory,
        ),
        SizedBox(height: padding),
        AsyncActionButton(
          icon: Icons.save_rounded,
          label: widget._proceedButtonLabel,
          onPressed: _getOnProceedPressed(),
        ),
      ],
    );
  }

  //
  Future<void> _pickDirectory() => FilePicker.platform.getDirectoryPath().then(
        (value) {
          if (value != null && mounted) {
            setState(() {
              _pickedDirectory = Some(value);
            });
          }
        },
      );
  //
  Future<void> Function()? _getOnProceedPressed() => switch (_pickedDirectory) {
        Some(value: final path) => () async => widget._proceedPicked(path),
        None() => null,
      };
}
