import 'app_localizations.dart';

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get welcome => "Water Reminder'e Hoşgeldiniz";

  @override
  String get welcomeSubTitle =>
      "Merhaba, ben sizin kişisel su tüketim asistanınızım.";

  @override
  // TODO: implement welcomeTitle
  String get welcomeTitle => throw UnimplementedError();
}
