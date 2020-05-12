import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageItem {
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  LanguageItem({this.id, this.name, this.flag, this.languageCode});

  static List<LanguageItem> languageList() {
    return <LanguageItem>[
      LanguageItem(id: 1, name: 'English', flag: '🇺🇸', languageCode: 'en'),
      LanguageItem(id: 1, name: 'عربى', flag: '🇦🇪', languageCode: 'ar'),
    ];
  }
}

class Language with ChangeNotifier {
  Future<void> switchLocale(LanguageItem language) async {
    Locale _locale;
    switch (language.languageCode) {
      case 'en':
        {
          _locale = Locale(language.languageCode, 'US');
        }
        break;

      case 'ar':
        {
          _locale = Locale(language.languageCode, 'AE');
        }
        break;

      default:
        _locale = Locale(language.languageCode, 'US');
        break;
    }

    final prefs = await SharedPreferences.getInstance();
    final localeData = json.encode(
      {
        'languageCode': _locale.languageCode,
        'countryCode': _locale.countryCode,
      },
    );
    prefs.setString('localeData', localeData);
    
  }

  Future<Locale> getLocale() async {
    Locale _locale;

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('localeData')) {
      _locale = Locale('en', 'US');
    } else {
      final extractedUserData =
          json.decode(prefs.getString('localeData')) as Map<String, Object>;

      _locale = Locale(extractedUserData['languageCode'], extractedUserData['countryCode']);
    }
    return _locale;
     //notifyListeners();
  }
}
