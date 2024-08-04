import 'package:flutter/material.dart';
import 'add_customer.dart';
import 'add_flight.dart';
import 'list_reservation.dart';

/// The entry point of the application.
///
/// This function is the main entry point of the application, which calls the
/// `runApp` function with `MyApp` as its argument to start the Flutter application.
void main() {
  runApp(const MyApp());
}

/// A stateless widget representing the root of the application.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  const MyApp({super.key});

  /// Builds the [MyApp] widget.
  ///
  /// This method returns a [MaterialApp] widget configured with the application's
  /// title, theme, home page, and debug banner settings.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Reservation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
      debugShowCheckedModeBanner: false, // Removes the debug banner
    );
  }
}

/// A stateless widget representing the main page of the application.
class MainPage extends StatelessWidget {
  /// Creates a [MainPage] widget.
  const MainPage({super.key});

  /// Shows an [AlertDialog] with reservation instructions.
  ///
  /// This method creates an [AlertDialog] with a background color of `orangeAccent`
  /// and a message with instructions on making a reservation. It includes a close
  /// text button to dismiss the dialog.
  void _showGuideDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orangeAccent,
          title: const Text(
            'Quick Guide',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'To make a reservation, add a customer, an airplane, and a flight first.',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds the [MainPage] widget.
  ///
  /// This method returns a [Scaffold] widget containing a background image,
  /// a logo, a title, buttons to navigate to different pages, and a guide text
  /// that opens an [AlertDialog] with instructions.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background2.jpg'), // Page background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // This gives space around the edges
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40), // This gives space from the top
              Center(
                child: Image.asset(
                  'assets/airline_logo.png',
                  width: 150,
                ),
              ),
              const SizedBox(height: 16), // This gives space between image and text
              const Text(
                'AC Travel Services',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24), // This gives space between text and buttons
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white60,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Add Customer',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCustomerPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white60,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'Add Flight',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddFlightPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white60,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'See Reservations',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListReservationPage()),
                    );
                  },
                ),
              ),
              const Spacer(), // Pushes the text to the bottom

              const SizedBox(height: 20), // Space before the guide text
              TextButton(
                onPressed: () => _showGuideDialog(context),
                child: const Text(
                  'How To Use This Platform',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
