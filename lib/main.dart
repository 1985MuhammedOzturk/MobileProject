import 'package:flutter/material.dart';
import 'airplane_list_page.dart';
import 'localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'add_edit_airplane_page.dart';

/// The main function is the entry point for the application.
void main() {
  runApp(MyApp());
}
///The root widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
///The state class
class _MyAppState extends State<MyApp> {
  ///_locale holds the current locale
  Locale _locale = Locale('en', 'US');

  /// _changeLanguage changes the locale and displays a snackbar.
  void _changeLanguage(Locale locale) {
    setState(() {
      ///new locale
      _locale = locale;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to ${locale.languageCode}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airline Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('fr', 'FR'),
      ],
      home: MainPage(onLocaleChange: _changeLanguage, locale: _locale),
    );
  }
}
///Main screen of the application.
class MainPage extends StatelessWidget {
  ///Function to change the locale
  final Function(Locale) onLocaleChange;
  final Locale locale;
///Creates MainPage widget.
  MainPage({required this.onLocaleChange, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
        actions: [
          DropdownButton<Locale>(
            onChanged: (Locale? locale) {
              if (locale != null) {
                onLocaleChange(locale);
              }
            },
            icon: Icon(Icons.language, color: Colors.white),
            value: locale,
            items: [
              DropdownMenuItem(
                value: Locale('en', 'US'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('fr', 'FR'),
                child: Text('Français'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AirplaneListPage()),
                );
              },
              child: Text(AppLocalizations.of(context).translate('Airplanes')),
            ),
            SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // Placeholder function
                print('Customer button pressed');
              },
              child: Text(AppLocalizations.of(context).translate('Customer')),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder function
                print('Flights button pressed');
              },
              child: Text(AppLocalizations.of(context).translate('Flights')),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder function
                print('Reservation button pressed');
              },
              child: Text(AppLocalizations.of(context).translate('Reservation')),
            ),
          ],
        ),
      ),
    );
  }
}
