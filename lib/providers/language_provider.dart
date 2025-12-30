import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'hi'; // Default Hindi

  String get currentLanguage => _currentLanguage;

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    notifyListeners();
  }

  String getLocaleId() {
    // Returns locale ID for speech-to-text
    switch (_currentLanguage) {
      case 'hi':
        return 'hi-IN';
      case 'ta':
        return 'ta-IN';
      case 'te':
        return 'te-IN';
      default:
        return 'en-US';
    }
  }

  String translate(String key) {
    // Simple translation map (expand this later)
    final translations = {
      'hi': {
        'welcome': 'स्वागत है',
        'pricing': 'मूल्य निर्धारण',
        'marketing': 'विपणन',
        'finance': 'वित्त',
      },
      'en': {
        'welcome': 'Welcome',
        'pricing': 'Pricing',
        'marketing': 'Marketing',
        'finance': 'Finance',
      },
      // Add Tamil, Telugu later
    };

    return translations[_currentLanguage]?[key] ?? key;
  }
}