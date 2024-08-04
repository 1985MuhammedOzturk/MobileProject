import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'airplane.dart';
import 'localization.dart';
import 'add_edit_airplane_page.dart';

///StatefulWidget displays the airplane list.
class AirplaneListPage extends StatefulWidget {
  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

///the state for AirplaneListPage
class _AirplaneListPageState extends State<AirplaneListPage> {
  List<Airplane> _airplanes = [];

  ///the list of airplanes
  @override
  void initState() {
    super.initState();
    _loadAirplanes();
  }
///loading the airplane list from database
  Future<void> _loadAirplanes() async {
    final airplanes = await DatabaseHelper.instance.getAirplanes();
    setState(() {
      _airplanes = airplanes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('Airplanes')),
      ),
      body: ListView.builder(
        itemCount: _airplanes.length,
        itemBuilder: (context, index) {
          final airplane = _airplanes[index];
          return ListTile(
            title: Text(airplane.type),
            subtitle: Text(
              '${localizations.translate('Passengers')}: ${airplane.passengers}, ${localizations.translate('Max Speed')}: ${airplane.maxSpeed} km/h, ${localizations.translate('Range')}: ${airplane.range} km',
            ),
            onTap: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditAirplanePage(airplane: airplane)),
              );
              if (result == true) {
                _loadAirplanes();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditAirplanePage()),
          );
          if (result == true) {
            _loadAirplanes();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
