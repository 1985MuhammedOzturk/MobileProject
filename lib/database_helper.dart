import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'airplane.dart';

///this class helps to manage the database operations for airplanes
class DatabaseHelper {
  ///singleton instance
  static final DatabaseHelper instance = DatabaseHelper._init();
///database instance
  static Database? _database;

  ///constructor for the singleton instance
  DatabaseHelper._init();

  ///gets the database instance , and initialize it if necessary.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('airplanes.db');
    return _database!;
  }

  ///Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  ///commands for database schema
  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE airplanes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      passengers INTEGER NOT NULL,
      maxSpeed INTEGER NOT NULL,
      range INTEGER NOT NULL
    )
    ''');
  }
///insert an airplane into the database
  Future<int> insertAirplane(Airplane airplane) async {
    final db = await instance.database;
    return await db.insert('airplanes', airplane.toMap());
  }
///updates the airplane in the databsae
  Future<int> updateAirplane(Airplane airplane) async {
    final db = await instance.database;
    return await db.update(
      'airplanes',
      airplane.toMap(),
      where: 'id = ?',
      whereArgs: [airplane.id],
    );
  }
///deletes the airplane from the database
  Future<int> deleteAirplane(int id) async {
    final db = await instance.database;
    return await db.delete(
      'airplanes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  ///retrieves all airplanes from the database
  Future<List<Airplane>> getAirplanes() async {
    final db = await instance.database;

    final result = await db.query('airplanes');

    return result.map((json) => Airplane.fromMap(json)).toList();
  }
}
