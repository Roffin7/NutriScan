import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as developer; // For logging errors

import 'core/theme.dart';
import 'core/localization.dart';
import 'screens/home_screen.dart';

class NutriScanApp extends StatefulWidget {
  const NutriScanApp({super.key});

  @override
  _NutriScanAppState createState() => _NutriScanAppState();
}

class _NutriScanAppState extends State<NutriScanApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  Locale _currentLocale = const Locale('en', 'US');

  void _changeLanguage(Locale locale) {
    setState(() {
      _currentLocale = locale;
    });
  }

  // Method to build language selection popup menu
  List<PopupMenuEntry<Locale>> _buildLanguageMenuItems() {
    return [
      PopupMenuItem<Locale>(
        value: const Locale('en', 'US'),
        child: Text('English'),
      ),
      PopupMenuItem<Locale>(
        value: const Locale('es', 'ES'),
        child: Text('Español'),
      ),
    ];
  }

  // Improved error widget
  Widget _buildErrorWidget(Object error) {
    developer.log('Firebase initialization error', error: error);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              Text('Firebase initialization error', 
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Text(error.toString(), 
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Improved error handling
        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error!);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'NutriScan',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            locale: _currentLocale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'),
              const Locale('es', 'ES'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            home: Builder(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('NutriScan'),
                    actions: [
                      PopupMenuButton<Locale>(
                        onSelected: _changeLanguage,
                        itemBuilder: (BuildContext context) => _buildLanguageMenuItems(),
                      ),
                    ],
                  ),
                  body: const HomeScreen(),
                );
              },
            ),
          );
        }

        // Loading state
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
