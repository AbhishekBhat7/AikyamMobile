import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'login_state.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_state (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            is_logged_in INTEGER,
            email TEXT
          )
        ''');
      },
    );
  }

  Future<void> setLoginState(bool isLoggedIn, {String? email}) async {
    final db = await database;
    // Clear previous state and set new state
    await db.delete('user_state');
    await db.insert('user_state', {
      'is_logged_in': isLoggedIn ? 1 : 0,
      'email': email ?? '', // Store email if provided
    });
  }

  Future<Map<String, dynamic>?> getLoginState() async {
    final db = await database;
    final result = await db.query('user_state');
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> clearLoginState() async {
    final db = await database;
    await db.delete('user_state');
  }
}
