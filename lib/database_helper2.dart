import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  static const _databaseName = "finalMobileProject.db";
  static const _databaseVersion = 1;

  static const tableCustomers = 'customers';
  static const tableFlights = 'flights';
  static const tableReservations = 'reservations';

  static const columnId = '_id';
  static const columnFirstName = 'first_name';
  static const columnLastName = 'last_name';
  static const columnBirthday = 'birthday';
  static const columnAddress = 'address';
  static const columnFlightName = 'flight_name';
  static const columnDepartureCity = 'departure_city';
  static const columnDestinationCity = 'destination_city';
  static const columnDepartureTime = 'departure_time';
  static const columnArrivalTime = 'arrival_time';
  static const columnCustomerId = 'customer_id';
  static const columnFlightId = 'flight_id';
  static const columnReservationName = 'reservation_name';
  static const columnReservationDate = 'reservation_date';

  DatabaseHelper._internal();

  static DatabaseHelper get instance => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableCustomers (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstName TEXT NOT NULL,
        $columnLastName TEXT NOT NULL,
        $columnBirthday TEXT NOT NULL,
        $columnAddress TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableFlights (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFlightName TEXT NOT NULL,
        $columnDepartureCity TEXT NOT NULL,
        $columnDestinationCity TEXT NOT NULL,
        $columnDepartureTime TEXT NOT NULL,
        $columnArrivalTime TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableReservations (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCustomerId INTEGER NOT NULL,
        $columnFlightId INTEGER NOT NULL,
        $columnReservationName TEXT NOT NULL,
        $columnReservationDate TEXT NOT NULL,
        FOREIGN KEY ($columnCustomerId) REFERENCES $tableCustomers ($columnId),
        FOREIGN KEY ($columnFlightId) REFERENCES $tableFlights ($columnId)
      )
    ''');
  }

  // CRUD methods for Customers
  Future<int> insertCustomer(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableCustomers, row);
  }

  Future<List<Map<String, dynamic>>> queryAllCustomers() async {
    Database db = await database;
    return await db.query(tableCustomers);
  }

  Future<Map<String, dynamic>?> queryCustomerById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableCustomers,
      columns: [columnId, columnFirstName, columnLastName, columnAddress],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateCustomer(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(tableCustomers, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteCustomer(int id) async {
    Database db = await database;
    return await db.delete(tableCustomers, where: '$columnId = ?', whereArgs: [id]);
  }

  // CRUD methods for Flights
  Future<int> insertFlight(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableFlights, row);
  }

  Future<List<Map<String, dynamic>>> queryAllFlights() async {
    Database db = await database;
    return await db.query(tableFlights);
  }

  Future<Map<String, dynamic>?> queryFlightById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableFlights,
      columns: [columnId, columnFlightName, columnDepartureCity, columnDestinationCity, columnDepartureTime, columnArrivalTime],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateFlight(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(tableFlights, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteFlight(int id) async {
    Database db = await database;
    return await db.delete(tableFlights, where: '$columnId = ?', whereArgs: [id]);
  }

  // CRUD methods for Reservations
  Future<int> insertReservation(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(tableReservations, row);
  }

  Future<List<Map<String, dynamic>>> queryAllReservations() async {
    Database db = await database;
    return await db.query(tableReservations);
  }

  Future<Map<String, dynamic>?> queryReservationById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      tableReservations,
      columns: [columnId, columnCustomerId, columnFlightId, columnReservationName, columnReservationDate],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateReservation(int id, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.update(tableReservations, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteReservation(int id) async {
    Database db = await database;
    return await db.delete(tableReservations, where: '$columnId = ?', whereArgs: [id]);
  }
}