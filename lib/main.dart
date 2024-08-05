import 'package:flutter/material.dart';
import 'add_customer.dart';
import 'add_flight.dart';
import 'list_reservation.dart';
import 'airplane_list_page.dart';
import 'localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// The main function is the entry point for the application.
void main() {
  runApp(MyApp());
}

/// The root widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// The state class
class _MyAppState extends State<MyApp> {
  /// _locale holds the current locale
  Locale _locale = Locale('en', 'US');

  /// _changeLanguage changes the locale and displays a snackbar.
  void _changeLanguage(Locale locale) {
    setState(() {
      /// new locale
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
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

/// Main screen of the application.
class MainPage extends StatelessWidget {
  /// Function to change the locale
  final Function(Locale) onLocaleChange;
  final Locale locale;

  /// Creates MainPage widget.
  MainPage({required this.onLocaleChange, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30), // Space between image and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconTheme(
                    data: IconThemeData(color: Colors.white),
                    child: PopupMenuButton<Locale>(
                      icon: Icon(Icons.language),
                      onSelected: onLocaleChange,
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: Locale('en', 'US'),
                            child: Text('English'),
                          ),
                          PopupMenuItem(
                            value: Locale('fr', 'FR'),
                            child: Text('Français'),
                          ),
                        ];
                      },
                    ),
                  ),
                ],
              ),
              // Add the airline logo image
              Image.asset(
                'assets/airline_logo.png',
                width: 200, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
              SizedBox(height: 20), // Space between image and buttons
              Text(
                'AC Travel Services',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20), // Space between image and buttons
              // Buttons
              _buildStyledButton(context, 'Airplanes', AirplaneListPage()),
              SizedBox(height: 15), // Space between buttons
              _buildStyledButton(context, 'Customer', AddCustomerPage()),
              SizedBox(height: 15),
              _buildStyledButton(context, 'Flights', AddFlightPage()),
              SizedBox(height: 15),
              _buildStyledButton(context, 'Reservation', ListReservationPage()),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build styled buttons
  ElevatedButton _buildStyledButton(BuildContext context, String label, Widget page) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white70, // Background color
        foregroundColor: Colors.black, // Text color
        minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50), // Width and height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Rectangular shape with no rounded edges
        ),
      ),
      child: Text(AppLocalizations.of(context).translate(label)),
    );
  }
}
