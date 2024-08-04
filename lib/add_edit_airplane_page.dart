import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'airplane.dart';
import 'localization.dart';
import 'secure_storage.dart';

///StatefulWidget allows the user to add or edit an airplane.
class AddEditAirplanePage extends StatefulWidget {
  ///The airplane to be edited
  final Airplane? airplane;

  ///Creates an instance of AddEditAirplanePage
  AddEditAirplanePage({Key? key, this.airplane}) : super(key: key);

  @override
  _AddEditAirplanePageState createState() => _AddEditAirplanePageState();
}

///The state for AddEditAirPlanePage
class _AddEditAirplanePageState extends State<AddEditAirplanePage> {
  ///formkey is used to validate the form
  final _formKey = GlobalKey<FormState>();
  ///type of the airplane
  late String _type;
  ///the number of passengers. capacity of the airplane
  late int _passengers;
  ///maximum speed of the plane
  late int _maxSpeed;
  ///the range distance of the airplane
  late int _range;
  ///an instance of secure storage is to store the airplane data.
  final SecureStorage secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    if (widget.airplane != null) {
      _type = widget.airplane!.type;
      _passengers = widget.airplane!.passengers;
      _maxSpeed = widget.airplane!.maxSpeed;
      _range = widget.airplane!.range;
    } else {
      _type = '';
      _passengers = 0;
      _maxSpeed = 0;
      _range = 0;
    }
  }

  ///saves the form data to the database and secure storage.
  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final airplane = Airplane(
        id: widget.airplane?.id,
        type: _type,
        passengers: _passengers,
        maxSpeed: _maxSpeed,
        range: _range,
      );

      if (widget.airplane == null) {
        await DatabaseHelper.instance.insertAirplane(airplane);
      } else {
        await DatabaseHelper.instance.updateAirplane(airplane);
      }

      // saves data to secure storage
      await secureStorage.writeData('airplane_${airplane.id}_type', airplane.type);
      await secureStorage.writeData('airplane_${airplane.id}_passengers', airplane.passengers.toString());
      await secureStorage.writeData('airplane_${airplane.id}_maxSpeed', airplane.maxSpeed.toString());
      await secureStorage.writeData('airplane_${airplane.id}_range', airplane.range.toString());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).translate('Saved')),
          content: Text(AppLocalizations.of(context).translate('Airplane saved successfully')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context, true); // Return to the previous screen
              },
              child: Text(AppLocalizations.of(context).translate('OK')),
            ),
          ],
        ),
      );
    }
  }

  ///deletes the airplane from the database and secure storage
  void _deleteAirplane() async {
    if (widget.airplane != null) {
      await DatabaseHelper.instance.deleteAirplane(widget.airplane!.id!);
      await secureStorage.deleteData('airplane_${widget.airplane!.id}_type');
      await secureStorage.deleteData('airplane_${widget.airplane!.id}_passengers');
      await secureStorage.deleteData('airplane_${widget.airplane!.id}_maxSpeed');
      await secureStorage.deleteData('airplane_${widget.airplane!.id}_range');
      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        ///snackbar
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Airplane deleted successfully')),
        ),
      );
    }
  }

  ///Builds the UI for the Add/Edit Airplane Page
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.airplane == null
            ? localizations.translate('add_airplane')
            : localizations.translate('edit_airplane')),
        actions: [
          if (widget.airplane != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteAirplane,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _type,
                decoration: InputDecoration(
                  labelText: localizations.translate('type'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('Please enter a type');
                  }
                  return null;
                },
                onSaved: (value) {
                  _type = value!;
                },
              ),
              TextFormField(
                initialValue: _passengers.toString(),
                decoration: InputDecoration(
                  labelText: localizations.translate('passengers'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('Please enter the number of passengers');
                  }
                  return null;
                },
                onSaved: (value) {
                  _passengers = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _maxSpeed.toString(),
                decoration: InputDecoration(
                  labelText: localizations.translate('max_speed'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('Please enter the max speed');
                  }
                  return null;
                },
                onSaved: (value) {
                  _maxSpeed = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _range.toString(),
                decoration: InputDecoration(
                  labelText: localizations.translate('range'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.translate('Please enter the range');
                  }
                  return null;
                },
                onSaved: (value) {
                  _range = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text(localizations.translate('save')),
              ),
              if (widget.airplane != null) ...[
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _deleteAirplane,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Set the button color to red
                  ),
                  child: Text(localizations.translate('delete')),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
