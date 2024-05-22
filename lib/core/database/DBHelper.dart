import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../auth/models/User.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  factory DBHelper() => _instance;

  static Database? _db;

  DBHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'myDBB.db');
    Database myDb = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return myDb;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion...");
    // Add upgrade logic here
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE User (
        email TEXT PRIMARY KEY,
        password TEXT NOT NULL
      )
    """);
    print("Database and User table created successfully");
  }

  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? myDb = await db;
    if (myDb == null) {
      return [];
    }
    List<Map<String, dynamic>> response = await myDb.rawQuery(sql);
    return response;
  }

  Future<int> insertUser(User user) async {
    Database? myDb = await db;
    if (myDb == null) {
      return 0;
    }
    int response = await myDb.insert('User', user.toMap());
    return response;
  }

  Future<int> updateUser(User user) async {
    Database? myDb = await db;
    if (myDb == null) {
      return 0;
    }
    int response = await myDb.update('User', user.toMap(), where: 'email = ?', whereArgs: [user.email]);
    return response;
  }

  Future<int> deleteUser(String email) async {
    Database? myDb = await db;
    if (myDb == null) {
      return 0;
    }
    int response = await myDb.delete('User', where: 'email = ?', whereArgs: [email]);
    return response;
  }

  Future<int> deleteAllUsers() async {
    Database? myDb = await db;
    if (myDb == null) {
      return 0;
    }
    int response = await myDb.delete('User');
    return response;
  }

  Future<List<User>> fetchUsers() async {
    List<User> userList = [];
    String sql = 'SELECT * FROM User';

    try {
      List<Map<String, dynamic>> result = await readData(sql);

      for (Map<String, dynamic> row in result) {
        User user = User.fromMap(row);
        userList.add(user);
      }

      return userList;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<bool> emailExists(String email) async {
    Database? myDb = await db;
    if (myDb == null) {
      return false;
    }
    List<Map<String, dynamic>> result = await myDb.query(
      'User',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }
}
