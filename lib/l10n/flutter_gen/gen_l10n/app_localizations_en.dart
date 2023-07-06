import 'app_localizations.dart';

/// The translations for Turkish (`tr`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => "Welcome to Water Reminder";

  @override
  String get welcomeSubTitle =>
      "Hi, I'm your personal water consumption assistant.";

  @override
  // TODO: implement welcomeTitle
  String get welcomeTitle => throw UnimplementedError();
}
