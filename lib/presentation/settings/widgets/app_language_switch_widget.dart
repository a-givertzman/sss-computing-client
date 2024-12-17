import 'dart:convert';
import 'package:flutter/material.dart' hide Localizations;
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'package:sss_computing_client/core/app_language_settings_text_file.dart';
import 'package:sss_computing_client/core/extensions/app_settings.dart';
import 'package:sss_computing_client/core/extensions/strings.dart';
import 'package:sss_computing_client/core/widgets/disabled_widget.dart';
import 'package:sss_computing_client/presentation/settings/widgets/app_languages_dropdown.dart';
///
///
class AppLanguageSwitchWidget extends StatefulWidget {
  ///
  ///
  const AppLanguageSwitchWidget({super.key});
  //
  @override
  State<AppLanguageSwitchWidget> createState() =>
      _AppLanguageSwitchWidgetState();
}
///
class _AppLanguageSwitchWidgetState extends State<AppLanguageSwitchWidget> {
  late bool _isLoading;
  late AppLang? _currentAppLanguage;
  //
  @override
  void initState() {
    _isLoading = false;
    _currentAppLanguage = _getAppLanguage();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: const Setting('buttonWidthMedium').toDouble,
      child: DisabledWidget(
        disabled: _isLoading,
        child: AppLanguagesDropdown(
          initialValue: _currentAppLanguage,
          onValueChanged: _handleLanguageChanged,
          values: _getAppLanguages(),
        ),
      ),
    );
  }
  //
  void _handleLanguageChanged(AppLang lang) async {
    setState(() {
      _isLoading = true;
    });
    const languageSettingFile = AppLanguageSettingsTextFile();
    languageSettingFile.content.then(
      (result) => result.andThen((settingsContent) {
        try {
          final settingsJson = json.decode(settingsContent);
          return Ok(settingsJson);
        } catch (err) {
          return Err(Failure(
            message: 'Error while loading language settings occurred',
            stackTrace: StackTrace.current,
          ));
        }
      }).inspectErr((err) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorMessage(Localized(err.message).v);
        }
      }).andThen((settingsJson) {
        settingsJson['currentLanguage'] = lang.name;
        languageSettingFile.write(json.encode(settingsJson)).then((_) {
          return _showInfoMessage(
            const Localized(
              'New language settings saved, please restart app to apply it',
            ).v,
          );
        }).then((_) {
          return AppSettings().initializeFromTextFiles(
            [languageSettingFile],
          );
        }).catchError((_) {
          return _showErrorMessage(const Localized(
            'Cannot change application language settings, please try again',
          ).v);
        }).whenComplete(() {
          if (mounted) {
            setState(() {
              _currentAppLanguage = _getAppLanguage();
              _isLoading = false;
            });
          }
        });
        return const Ok(null);
      }),
    );
  }
  //
  void _showErrorMessage(String message) {
    if (mounted) {
      final durationMs = const Setting('errorMessageDisplayDuration_ms').toInt;
      BottomMessage.error(
        message: message.truncate(),
        displayDuration: Duration(milliseconds: durationMs),
      ).show(context);
    }
  }
  //
  void _showInfoMessage(String message) {
    if (mounted) {
      final durationMs = const Setting('infoMessageDisplayDuration_ms').toInt;
      BottomMessage.info(
        message: message.truncate(),
        displayDuration: Duration(milliseconds: durationMs),
      ).show(context);
    }
  }
  //
  AppLang? _getAppLanguage() {
    return switch (Setting(
      'currentLanguage',
      onError: (_) => 'unknownLanguage',
    ).toString()) {
      'en' => AppLang.en,
      'ru' => AppLang.ru,
      _ => null,
    };
  }
  //
  List<AppLang> _getAppLanguages() => [
        AppLang.en,
        AppLang.ru,
      ];
}
