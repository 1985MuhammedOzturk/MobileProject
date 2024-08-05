import 'package:flutter/material.dart';
import 'database_helper2.dart';
import 'list_reservation.dart';
import 'main.dart';
import 'add_customer.dart';

/// A page for adding a new flight.
class AddFlightPage extends StatefulWidget {
  /// Creates an instance of [AddFlightPage].
  const AddFlightPage({super.key});

  @override
  AddFlightPageState createState() => AddFlightPageState();
}

/// The state of the [AddFlightPage] widget.
class AddFlightPageState extends State<AddFlightPage> {
  /// Global key for form validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Controller for the flight name input field.
  final TextEditingController _flightNameController = TextEditingController();

  /// Controller for the departure city input field.
  final TextEditingController _departureCityController = TextEditingController();

  /// Controller for the destination city input field.
  final TextEditingController _destinationCityController = TextEditingController();

  /// Controller for the departure time input field.
  final TextEditingController _departureTimeController = TextEditingController();

  /// Controller for the arrival time input field.
  final TextEditingController _arrivalTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background1.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black54, // Semi-transparent overlay
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0), // Space from the top
                    child: Text(
                      'Add New Flight',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Space between text and fields
                  _buildTextFormField(
                    controller: _flightNameController,
                    label: 'Flight Name',
                    hint: 'Enter flight name',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a flight name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _departureCityController,
                    label: 'Departure City',
                    hint: 'Enter departure city',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a departure city'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _destinationCityController,
                    label: 'Destination City',
                    hint: 'Enter destination city',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a destination city'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _departureTimeController,
                    label: 'Departure Time',
                    hint: 'Enter departure time',
                    keyboardType: TextInputType.datetime,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a departure time'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _arrivalTimeController,
                    label: 'Arrival Time',
                    hint: 'Enter arrival time',
                    keyboardType: TextInputType.datetime,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter an arrival time'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Span the width of the page
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent, // Button background color
                        side: const BorderSide(color: Colors.white), // White outline
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text(
                        'Save Flight',
                        style: TextStyle(color: Colors.white), // Button text color
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _submitFlight(context); // Pass context to the async method
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orangeAccent, // Background color of the bottom menu
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.black87),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      locale: const Locale('en', 'US'), // Provide a default locale
                      onLocaleChange: (locale) {
                        // Handle locale change if needed
                      },
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCustomerPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.flight, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFlightPage()), // Use without const if needed
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.list, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ListReservationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a text form field with consistent styling.
  ///
  /// The [controller] is used to manage the input's value.
  /// The [label] is the text displayed as the label of the field.
  /// The [hint] provides a hint to the user about the expected input.
  /// The [keyboardType] specifies the type of keyboard to use.
  /// The [validator] is used to validate the input value.
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white), // Label text color
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white), // Hint text color
        filled: false, // No fill color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.orangeAccent), // Input text color
      validator: validator,
    );
  }

  /// Submits the flight information to the database.
  ///
  /// The [context] is used to navigate back to the previous page.
  Future<void> _submitFlight(BuildContext context) async {
    final flight = {
      'flight_name': _flightNameController.text,
      'departure_city': _departureCityController.text,
      'destination_city': _destinationCityController.text,
      'departure_time': _departureTimeController.text,
      'arrival_time': _arrivalTimeController.text,
    };

    await DatabaseHelper.instance.insertFlight(flight);

    if (mounted) {
      Navigator.pop(context); // Navigate back to the main page only if the widget is still mounted
    }
  }
}
