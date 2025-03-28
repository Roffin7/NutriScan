import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// ✅ Corrected method to access localization using context
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome to NutriScan!',
      'scan_food': 'Scan your food & get nutrition insights instantly.',
      'about': 'About NutriScan',
      'description': 'NutriScan is your personal food nutrition assistant. '
          'Simply search for any food item and get instant insights into its nutritional values. '
          'Powered by real-time data, NutriScan helps you make healthier choices effortlessly.',
      
      // New localized feature keys
      'key_features': 'Key Features',
      'instant_scanning_title': 'Instant Scanning',
      'instant_scanning_desc': 'Quickly scan food items to get nutritional insights.',
      'detailed_nutrition_title': 'Detailed Nutrition',
      'detailed_nutrition_desc': 'Comprehensive breakdown of nutritional values.',
      'healthy_choices_title': 'Healthy Choices',
      'healthy_choices_desc': 'Guidance for making informed dietary decisions.',
    },
    'es': {
      'welcome': '¡Bienvenido a NutriScan!',
      'scan_food': 'Escanea tu comida y obtén información nutricional al instante.',
      'about': 'Sobre NutriScan',
      'description': 'NutriScan es tu asistente personal de nutrición. '
          'Busca cualquier alimento y obtén información instantánea sobre su valor nutricional. '
          'Impulsado por datos en tiempo real, NutriScan te ayuda a tomar decisiones más saludables sin esfuerzo.',
      
      // Spanish translations for feature keys
      'key_features': 'Características Principales',
      'instant_scanning_title': 'Escaneo Instantáneo',
      'instant_scanning_desc': 'Escanea rápidamente los alimentos para obtener información nutricional.',
      'detailed_nutrition_title': 'Nutrición Detallada',
      'detailed_nutrition_desc': 'Desglose completo de valores nutricionales.',
      'healthy_choices_title': 'Elecciones Saludables',
      'healthy_choices_desc': 'Orientación para tomar decisiones dietéticas informadas.',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static final LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}