import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'database_helper2.dart';
import 'list_reservation.dart';
import 'main.dart';
import 'add_flight.dart';

/// A page for adding a new customer.
class AddCustomerPage extends StatefulWidget {
  /// Creates an instance of [AddCustomerPage].
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  /// The global key for the form used in this page.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the first name field.
  final _firstNameController = TextEditingController();

  /// Controller for the last name field.
  final _lastNameController = TextEditingController();

  /// Controller for the birthday field.
  final _birthdayController = TextEditingController();

  /// Controller for the address field.
  final _addressController = TextEditingController();

  /// The shared preferences instance used for storing customer data.
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _loadLastCustomer();
  }

  /// Loads the last entered customer data from shared preferences.
  Future<void> _loadLastCustomer() async {
    final firstName = await _prefs.getString('last_first_name');
    final lastName = await _prefs.getString('last_last_name');
    final birthday = await _prefs.getString('last_birthday');
    final address = await _prefs.getString('last_address');

    if (mounted) {
      setState(() {
        _firstNameController.text = firstName ?? '';
        _lastNameController.text = lastName ?? '';
        _birthdayController.text = birthday ?? '';
        _addressController.text = address ?? '';
      });
    }
  }

  /// Saves the current customer data to shared preferences.
  Future<void> _saveLastCustomer() async {
    await _prefs.setString('last_first_name', _firstNameController.text);
    await _prefs.setString('last_last_name', _lastNameController.text);
    await _prefs.setString('last_birthday', _birthdayController.text);
    await _prefs.setString('last_address', _addressController.text);
  }

  /// Adds a new customer to the database and saves the data to shared preferences.
  Future<void> _addCustomer() async {
    if (_formKey.currentState!.validate()) {
      try {
        await DatabaseHelper.instance.insertCustomer({
          DatabaseHelper.columnFirstName: _firstNameController.text,
          DatabaseHelper.columnLastName: _lastNameController.text,
          DatabaseHelper.columnBirthday: _birthdayController.text,
          DatabaseHelper.columnAddress: _addressController.text,
        });

        await _saveLastCustomer();

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // Background image
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
                        'Add New Customer',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Space between text and buttons
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.white), // Field label color
                        hintText: 'Enter first name',
                        hintStyle: TextStyle(color: Colors.white), // Placeholder text color
                        filled: false, // No fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent), // Input text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.white), // Field label color
                        hintText: 'Enter last name',
                        hintStyle: TextStyle(color: Colors.white), // Placeholder text color
                        filled: false, // No fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent), // Input text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _birthdayController,
                      decoration: const InputDecoration(
                        labelText: 'Birthday',
                        labelStyle: TextStyle(color: Colors.white), // Field label color
                        hintText: 'Enter birthday',
                        hintStyle: TextStyle(color: Colors.white), // Placeholder text color
                        filled: false, // No fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent), // Input text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter birthday';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.white), // Field label color
                        hintText: 'Enter address',
                        hintStyle: TextStyle(color: Colors.white), // Placeholder text color
                        filled: false, // No fill color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.orangeAccent),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      style: const TextStyle(color: Colors.orangeAccent), // Input text color
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, // Span the width of the page
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent, // Button fill color
                          side: const BorderSide(color: Colors.white), // Button outline color
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: _addCustomer,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
