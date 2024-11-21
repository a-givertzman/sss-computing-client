import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sss_computing_client/presentation/container_cargo/widgets/date_format_extension.dart';
///
/// Widget that displays a dateTime label and allows to change it.
class DateTimeLabelPicker extends StatelessWidget {
  final DateTime _dateTime;
  final void Function(DateTime dateTime) _updateDateTime;
  final ThemeData _themeData;
  ///
  /// Creates a widget that displays a [dateTime] label and allows to change it,
  /// [updateDateTime] is called when the dateTime is changed.
  ///
  /// [themeData] is used to style date and time picker dialog.
  const DateTimeLabelPicker({
    super.key,
    required DateTime dateTime,
    required void Function(DateTime newDateTime) updateDateTime,
    required ThemeData themeData,
  })  : _dateTime = dateTime,
        _updateDateTime = updateDateTime,
        _themeData = themeData;
  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDateAndTime(context),
      child: Text(_dateTime.formatRU()),
    );
  }
  //
  void _pickDateAndTime(BuildContext context) async {
    const String emptyLabel = '';
    final pickedDate = await showDatePicker(
      helpText: emptyLabel,
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      switchToInputEntryModeIcon: const Icon(Icons.keyboard_outlined),
      builder: _buildInputDialog,
    );
    if (!context.mounted || pickedDate == null) return;
    final pickedTime = await showTimePicker(
      helpText: emptyLabel,
      hourLabelText: emptyLabel,
      minuteLabelText: emptyLabel,
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dateTime),
      builder: _buildInputDialog,
    );
    _updateDateTime(pickedDate.copyWith(
      hour: pickedTime?.hour ?? 0,
      minute: pickedTime?.minute ?? 0,
    ));
  }
  //
  Widget _buildInputDialog(BuildContext context, Widget? child) {
    return Localizations(
      locale: const Locale('ru'),
      delegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: _themeData.colorScheme.copyWith(),
        ),
        child: child!,
      ),
    );
  }
}
