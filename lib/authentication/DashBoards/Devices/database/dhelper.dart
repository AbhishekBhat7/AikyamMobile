import 'package:aikyamm/authentication/DashBoards/Devices/database/dmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static Database? _database;

  // Singleton pattern for DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  // Initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open or create the database
  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'bluetooth_devices.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE devices(id TEXT PRIMARY KEY, name TEXT, connectionStatus TEXT)',
        );
      },
      version: 1,
    );
  }

  // Insert a device into the database
  Future<void> insertDevice(BluetoothDeviceModel device) async {
    final db = await database;
    await db.insert(
      'devices',
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all saved devices
  Future<List<BluetoothDeviceModel>> getSavedDevices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('devices');

    return List.generate(maps.length, (i) {
      return BluetoothDeviceModel.fromMap(maps[i]);
    });
  }
}
