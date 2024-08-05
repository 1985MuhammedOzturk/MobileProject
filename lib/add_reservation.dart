import 'package:flutter/material.dart';
import 'database_helper2.dart';
import 'list_reservation.dart';
import 'add_customer.dart';
import 'add_flight.dart';
import 'main.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({Key? key}) : super(key: key);

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final _formKey = GlobalKey<FormState>();
  final _reservationNameController = TextEditingController();
  final _reservationDateController = TextEditingController();
  String? _selectedCustomer;
  String? _selectedFlight;

  List<String> _customers = [];
  List<String> _flights = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
    _loadFlights();
  }

  Future<void> _loadCustomers() async {
    final customerList = await DatabaseHelper.instance.queryAllCustomers();
    setState(() {
      _customers = customerList.map((customer) {
        return '${customer[DatabaseHelper.columnFirstName]} ${customer[DatabaseHelper.columnLastName]}';
      }).toList();
    });
  }

  Future<void> _loadFlights() async {
    final flightList = await DatabaseHelper.instance.queryAllFlights();
    setState(() {
      _flights = flightList.map((flight) {
        return flight[DatabaseHelper.columnFlightName] as String; // Cast to String
      }).toList();
    });
  }

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

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ListReservationPage(),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 8.0),
                    Expanded(child: Text('Error: $e')),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8.0),
                  Expanded(child: Text('Please select both customer and flight')),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8.0),
                Expanded(child: Text('Please enter an input for every field of the form')),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

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
              'assets/background4.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
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
                            style: const TextStyle(color: Colors.orangeAccent),
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
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        icon: const Icon(Icons.person, color: Colors.white),
                      ),
                      iconEnabledColor: Colors.white,
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
                            style: const TextStyle(color: Colors.orangeAccent),
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
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        icon: const Icon(Icons.flight, color: Colors.white),
                      ),
                      iconEnabledColor: Colors.white,
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
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Enter reservation name',
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: Colors.transparent,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent),
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
                        labelStyle: const TextStyle(color: Colors.white),
                        hintText: 'Enter reservation date',
                        hintStyle: const TextStyle(color: Colors.white54),
                        fillColor: Colors.transparent,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reservation date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: _addReservation,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
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
        color: Colors.orangeAccent,
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
                      locale: Locale('en', 'US'), // Pass required parameters
                      onLocaleChange: (locale) {},
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
                  MaterialPageRoute(
                    builder: (context) => const AddCustomerPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.flight, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddFlightPage(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.list, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListReservationPage(),
                  ),
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
