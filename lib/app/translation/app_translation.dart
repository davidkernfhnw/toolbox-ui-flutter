abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en": en,
    "de-ch": deCh,
    "ro": ro,
    "nl-nl": nlNl,
  };
}

final Map<String, String> en = {"title": "Settings"};
final Map<String, String> deCh = {"title": "Einstellungen"};
final Map<String, String> ro = {"title": "setări"};
final Map<String, String> nlNl = {"title": "instellingen"};
