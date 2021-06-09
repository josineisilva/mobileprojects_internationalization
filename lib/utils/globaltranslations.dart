import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devicelocale/devicelocale.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

//
// Preferences related
//
const String _storageKey = "MyApplication_";
const List<String> _supportedLanguages = ['en','pt_BR'];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class GlobalTranslations {
  static final GlobalTranslations _translations = GlobalTranslations._internal();
  factory GlobalTranslations() => _translations;
  GlobalTranslations._internal();

  Locale _locale;
  Map<dynamic, dynamic> _localizedValues;
  VoidCallback _onLocaleChangedCallback;

  // Returns the list of supported Locales
  Iterable<Locale> supportedLocales() => _supportedLanguages.map<Locale>((lang) => Locale(lang, ''));

  // Returns the translation that corresponds to the [key]
  String text(String key, [List<String> args]) {
    // Return the requested string
    String ret = (_localizedValues == null || _localizedValues[key] == null)?
      '** ${key} not found'
    : _localizedValues[key];
    if (args != null) {
      for( int i=0; i<args.length; i++ ) {
        String placeHolder = "\$${i+1}";
        ret = ret.replaceAll(placeHolder,args[i]);
      };
    }
    return ret;
  }

  // Returns the current language code
  get currentLanguage => _locale == null ? '' : _locale.languageCode;

  // Returns the current Locale
  get locale => _locale;

  // One-time initialization
  Future<Null> init([String language]) async {
    String deviceLocale = await Devicelocale.currentLocale;
    print("Device locale: ${deviceLocale}");
    if (_locale == null){
      if (language == null) {
        language = await getPreferredLanguage();
        if (language == "")
          language = deviceLocale;
      }
      await setNewLanguage(language);
    }
    return null;
  }

  // Restores the preferred language
  getPreferredLanguage() async {
    return _getApplicationSavedInformation('language');
  }

  // Save the preferred language
  setPreferredLanguage(String lang) async {
    return _setApplicationSavedInformation('language', lang);
  }

  // Change the language
  Future<Null> setNewLanguage([String newLanguage, bool saveInPrefs = false]) async {
    String language = newLanguage;
    if (language == null)
      language = await getPreferredLanguage();
    if (language == "")
      language = _supportedLanguages.first;
    if (!_supportedLanguages.contains(language))
      language = _supportedLanguages.first;
    // Set the locale
    _locale = Locale(language, "");
    // Load the language strings
    String jsonContent = await rootBundle.loadString("assets/i18n/i18n_${_locale.languageCode}.json");
    _localizedValues = json.decode(jsonContent);
    // Save the new language in the application preferences
    if (saveInPrefs){
      await setPreferredLanguage(language);
    }
    // Notify that a language has changed
    if (_onLocaleChangedCallback != null){
      _onLocaleChangedCallback();
    }
    return null;
  }

  // Callback to be invoked when the user changes the language
  set onLocaleChangedCallback(VoidCallback callback){
    _onLocaleChangedCallback = callback;
  }

  // Fetch an application preference
  Future<String> _getApplicationSavedInformation(String name) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_storageKey + name) ?? '';
  }

  // Saves an application preference
  Future<bool> _setApplicationSavedInformation(String name, String value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_storageKey + name, value);
  }
}

GlobalTranslations translations = GlobalTranslations();
