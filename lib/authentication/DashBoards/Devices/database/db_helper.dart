import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Device model
class Device {
  final String id;
  final String name;

  Device({required this.id, required this.name});

  // Convert a Device into a Map. The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Extract a Device object from a Map
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('devices.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final pathToDB = join(dbPath, path);
    return openDatabase(
      pathToDB,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE devices(
            id TEXT PRIMARY KEY,
            name TEXT
          )
        ''');
      },
    );
  }

  // Insert a new device
  Future<void> insertDevice(Device device) async {
    final db = await instance.database;
    await db.insert(
      'devices',
      device.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all saved devices
  Future<List<Device>> getDevices() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('devices');
    return List.generate(maps.length, (i) {
      return Device.fromMap(maps[i]);
    });
  }

  // Delete a device
  Future<void> deleteDevice(String deviceId) async {
    final db = await instance.database;
    await db.delete(
      'devices',
      where: 'id = ?',
      whereArgs: [deviceId],
    );
  }
}
