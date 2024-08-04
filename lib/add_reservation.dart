import 'package:flutter/material.dart';
import 'database_helper2.dart';
import 'list_reservation.dart';
import 'add_customer.dart';
import 'add_flight.dart';
import 'main.dart';

/// A page to add a new reservation.
class AddReservationPage extends StatefulWidget {
  /// Creates an [AddReservationPage] widget.
  const AddReservationPage({super.key});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

/// State class for [AddReservationPage].
class _AddReservationPageState extends State<AddReservationPage> {
  /// Key used to identify and manage the form.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the reservation name input field.
  final _reservationNameController = TextEditingController();

  /// Controller for the reservation date input field.
  final _reservationDateController = TextEditingController();

  /// The selected customer from the dropdown menu.
  String? _selectedCustomer;

  /// The selected flight from the dropdown menu.
  String? _selectedFlight;

  /// List of customer names to populate the customer dropdown menu.
  List<String> _customers = [];

  /// List of flight names to populate the flight dropdown menu.
  List<dynamic> _flights = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadFlights();
  }

  /// Loads the list of customers from the database and updates the state.
  Future<void> _loadCustomers() async {
    final customerList = await DatabaseHelper.instance.queryAllCustomers();
    setState(() {
      _customers = customerList.map((customer) {
        return '${customer[DatabaseHelper.columnFirstName]} ${customer[DatabaseHelper.columnLastName]}';
      }).toList();
    });
  }

  /// Loads the list of flights from the database and updates the state.
  Future<void> _loadFlights() async {
    final flightList = await DatabaseHelper.instance.queryAllFlights();
    setState(() {
      _flights = flightList.map((flight) {
        return flight[DatabaseHelper.columnFlightName];
      }).toList();
    });
  }

  /// Adds a new reservation to the database if the form is valid and both customer and flight are selected.
  Future<void> _addReservation() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCustomer != null && _selectedFlight != null) {
        final customerName = _selectedCustomer!.split(' ');
        final flightName = _selectedFlight!;
        final reservationName = _reservationNameController.text;
        final reservationDate = _reservationDateController.text;

        try {
          final customerId = await _getCustomerId(customerName[0], customerName[1]);
          final flightId = await _getFlightId(flightName);

          await DatabaseHelper.instance.insertReservation({
            DatabaseHelper.columnCustomerId: customerId,
            DatabaseHelper.columnFlightId: flightId,
            DatabaseHelper.columnReservationName: reservationName,
            DatabaseHelper.columnReservationDate: reservationDate,
          });

          // Navigate to the reservation list page
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ListReservationPage(),
              ),
            );
          }
        } catch (e) {
          // Show an error message if the reservation could not be added
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.white), // Alert icon
                    const SizedBox(width: 8.0),
                    Expanded(child: Text('Error: $e')),
                  ],
                ),
                backgroundColor: Colors.red, // SnackBar background color
              ),
            );
          }
        }
      } else {
        // Show a message if either customer or flight is not selected
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Colors.white), // Alert icon
                  SizedBox(width: 8.0),
                  Expanded(child: Text('Please select both customer and flight')),
                ],
              ),
              backgroundColor: Colors.red, // SnackBar background color
            ),
          );
        }
      }
    } else {
      // Show a SnackBar if any of the form fields are empty
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, color: Colors.white), // Alert icon
                SizedBox(width: 8.0),
                Expanded(child: Text('Please enter an input for every field of the form')),
              ],
            ),
            backgroundColor: Colors.red, // SnackBar background color
          ),
        );
      }
    }
  }

  /// Retrieves the ID of a customer based on their first and last name.
  ///
  /// Throws an [Exception] if the customer is not found.
  Future<int> _getCustomerId(String firstName, String lastName) async {
    final result = await DatabaseHelper.instance.queryAllCustomers();
    for (var customer in result) {
      if (customer[DatabaseHelper.columnFirstName] == firstName &&
          customer[DatabaseHelper.columnLastName] == lastName) {
        return customer[DatabaseHelper.columnId];
      }
    }
    throw Exception('Customer not found');
  }

  /// Retrieves the ID of a flight based on its name.
  ///
  /// Throws an [Exception] if the flight is not found.
  Future<int> _getFlightId(String flightName) async {
    final result = await DatabaseHelper.instance.queryAllFlights();
    for (var flight in result) {
      if (flight[DatabaseHelper.columnFlightName] == flightName) {
        return flight[DatabaseHelper.columnId];
      }
    }
    throw Exception('Flight not found');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background4.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black54, // Semi-transparent overlay
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0), // Space from the top
                      child: Text(
                        'Add Reservation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: _selectedCustomer,
                      items: _customers.map((customer) {
                        return DropdownMenuItem<String>(
                          value: customer,
                          child: Text(
                            customer,
                            style: const TextStyle(color: Colors.orangeAccent), // Label text color
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCustomer = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Customer',
                        labelStyle: const TextStyle(color: Colors.white), // Label text color
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        icon: const Icon(Icons.person, color: Colors.white), // White icon
                      ),
                      iconEnabledColor: Colors.white, // Dropdown icon color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a customer';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedFlight,
                      items: _flights.map((flight) {
                        return DropdownMenuItem<String>(
                          value: flight,
                          child: Text(
                            flight,
                            style: const TextStyle(color: Colors.orangeAccent), // Label text color
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFlight = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Flight',
                        labelStyle: const TextStyle(color: Colors.white), // Label text color
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        icon: const Icon(Icons.flight, color: Colors.white), // White icon
                      ),
                      iconEnabledColor: Colors.white, // Dropdown icon color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a flight';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reservationNameController,
                      decoration: InputDecoration(
                        labelText: 'Reservation Name',
                        labelStyle: const TextStyle(color: Colors.white), // Label text color
                        hintText: 'Enter reservation name',
                        hintStyle: const TextStyle(color: Colors.white54), // Hint text color
                        fillColor: Colors.transparent, // Transparent fill color
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent), // Input text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reservation name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _reservationDateController,
                      decoration: InputDecoration(
                        labelText: 'Reservation Date',
                        labelStyle: const TextStyle(color: Colors.white), // Label text color
                        hintText: 'Enter reservation date',
                        hintStyle: const TextStyle(color: Colors.white54), // Hint text color
                        fillColor: Colors.transparent, // Transparent fill color
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white), // White outline
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent), // Input text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reservation date';
                        }
                        return null;
                      },
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
                        onPressed: _addReservation,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white), // Button text color
                        ),
                      ),
                    ),
                  ],
                ),
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
                  MaterialPageRoute(builder: (context) => const MainPage()),
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
                  MaterialPageRoute(builder: (context) => const AddFlightPage()),
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

  @override
  void dispose() {
    _reservationNameController.dispose();
    _reservationDateController.dispose();
    super.dispose();
  }
}
