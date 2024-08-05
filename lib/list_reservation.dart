import 'package:flutter/material.dart';
import 'add_reservation.dart';
import 'database_helper2.dart';

/// A page that displays a list of reservations.
class ListReservationPage extends StatefulWidget {
  /// Creates an instance of [ListReservationPage].
  const ListReservationPage({super.key});

  @override
  ListReservationPageState createState() => ListReservationPageState();
}

/// The state for [ListReservationPage].
class ListReservationPageState extends State<ListReservationPage> {
  late Future<List<Map<String, dynamic>>> _reservations;

  @override
  void initState() {
    super.initState();
    _reservations = DatabaseHelper.instance.queryAllReservations();
  }

  Future<void> _refreshReservations() async {
    setState(() {
      _reservations = DatabaseHelper.instance.queryAllReservations();
    });
  }

  Future<void> _deleteReservation(int reservationId) async {
    await DatabaseHelper.instance.deleteReservation(reservationId);
    _refreshReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background3.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black54, // Semi-transparent overlay
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30.0), // Space from the top
                  child: Text(
                    'All Reservations',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _reservations,
                    builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No reservations found.',
                            style: TextStyle(color: Colors.white), // Text color
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) => const Divider(
                          color: Colors.white30, // Divider color
                          thickness: 1, // Divider thickness
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final reservation = snapshot.data![index];
                          return ListTile(
                            title: Text(
                              reservation['reservation_name'] ?? 'No Name',
                              style: const TextStyle(color: Colors.white), // Text color
                            ),
                            subtitle: Text(
                              reservation['reservation_date'] ?? 'No Date',
                              style: const TextStyle(color: Colors.white), // Text color
                            ),
                            trailing: OutlinedButton(
                              onPressed: () {
                                _showDetails(context, reservation);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.transparent, // Transparent background
                                side: const BorderSide(color: Colors.white), // Button outline color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // No rounded corners
                                ),
                              ),
                              child: const Text(
                                'View Details',
                                style: TextStyle(color: Colors.white), // Button text color
                              ),
                            ),
                            onLongPress: () {
                              if (reservation['_id'] != null) {
                                _showDeleteSnackBar(context, reservation['_id']);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid reservation ID'),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.white54, // Background color for the footer
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Add A New Reservation',
                            hintStyle: TextStyle(color: Colors.white), // Hint text color
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white), // Text color
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (BuildContext context) => const AddReservationPage()),
                            );
                          },
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const AddReservationPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white), // Button outline color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0), // No rounded corners
                          ),
                        ),
                        child: const Text(
                          'Click Here',
                          style: TextStyle(color: Colors.white), // Button text color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a dialog with reservation details.
  ///
  /// The [context] is used to build the dialog, and [reservation] contains the details to be displayed.
  void _showDetails(BuildContext context, Map<String, dynamic> reservation) async {
    final BuildContext dialogContext = context; // Store context to avoid async gaps

    final customer = await DatabaseHelper.instance.queryCustomerById(reservation['customer_id']);
    final flight = await DatabaseHelper.instance.queryFlightById(reservation['flight_id']);

    showDialog(
      context: dialogContext,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orangeAccent, // Background color of AlertDialog
          title: Text(
            reservation['reservation_name'] ?? 'No Name',
            style: const TextStyle(color: Colors.black), // Dialog title color
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reservation Date: ${reservation['reservation_date'] ?? 'No Date'}',
                style: const TextStyle(color: Colors.black), // Text color
              ),
              if (customer != null) ...[
                Text(
                  'Customer: ${customer['first_name']} ${customer['last_name']}',
                  style: const TextStyle(color: Colors.black), // Text color
                ),
                Text(
                  'Address: ${customer['address'] ?? 'No Address'}',
                  style: const TextStyle(color: Colors.black), // Text color
                ),
              ],
              if (flight != null) ...[
                Text(
                  'Flight Details: ${flight['flight_name']} from ${flight['departure_city']} to ${flight['destination_city']}',
                  style: const TextStyle(color: Colors.black), // Text color
                ),
                Text(
                  'Departure Time: ${flight['departure_time'] ?? 'No Time'}',
                  style: const TextStyle(color: Colors.black), // Text color
                ),
                Text(
                  'Arrival Time: ${flight['arrival_time'] ?? 'No Time'}',
                  style: const TextStyle(color: Colors.black), // Text color
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white), // Close button text color
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSnackBar(BuildContext context, int reservationId) {
    final snackBar = SnackBar(
      backgroundColor: Colors.orangeAccent,
      content: const Text(
        'Do you want to delete this reservation?',
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
        label: 'Delete Reservation',
        textColor: Colors.white,
        onPressed: () {
          _deleteReservation(reservationId);
        },
      ),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
