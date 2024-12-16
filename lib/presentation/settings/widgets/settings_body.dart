import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:sss_computing_client/presentation/settings/widgets/app_language_switch_widget.dart';
///
/// Body of settings screen.
class SettingsBody extends StatefulWidget {
  ///
  /// Creates body of settings screen.
  const SettingsBody({super.key});
  //
  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}
//
class _SettingsBodyState extends State<SettingsBody> {
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockPadding = const Setting('blockPadding').toDouble;
    return Padding(
      padding: EdgeInsets.all(blockPadding),
      child: Center(
        child: Column(
          children: [
            Text(
              const Localized('App settings').v,
              style: theme.textTheme.titleLarge,
            ),
            const Spacer(),
            SizedBox(height: blockPadding),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AppSettingsItem(
                  label: const Localized('Language').v,
                  child: const AppLanguageSwitchWidget(),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
///
/// Widget for app settings item.
class _AppSettingsItem extends StatelessWidget {
  final String _label;
  final Widget _child;
  ///
  /// Creates widget for app settings item with [label]
  /// and [child] next to each other.
  const _AppSettingsItem({
    required String label,
    required Widget child,
  })  : _label = label,
        _child = child;
  //
  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$_label:'),
          SizedBox(width: const Setting('padding').toDouble),
          _child,
        ],
      );
}
