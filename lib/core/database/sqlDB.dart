// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../auth/models/User.dart';

class SqlDB {
  static SqlDB? _instance;
  static Database? _db;

  // Singleton getter function
  static SqlDB get instance {
    _instance ??= SqlDB();
    return _instance!;
  }

  // Getter for the database instance
  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initializeDb();
    }
    return _db;
  }

  // Initialize the database and create tables if necessary
  Future<Database> _initializeDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'myDB.db');
    Database myDb = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return myDb;
  }

  // Define how to upgrade the database if the version changes
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion...");
    // Add upgrade logic here
  }

  // Define how to create the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute("""
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    """);
    print("Database and User table created successfully");
  }

  // Method to read data from the database
  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? myDb = await db;
    List<Map<String, dynamic>> response = await myDb!.rawQuery(sql);
    return response;
  }

  // Method to insert a user into the database
  Future<int> insertUser(User user) async {
    Database? myDb = await db;
    int response = await myDb!.insert('User', user.toMap());
    return response;
  }

  // Method to update a user in the database
  Future<int> updateUser(User user) async {
    Database? myDb = await db;
    int response = await myDb!.update('User', user.toMap(), where: 'email = ?', whereArgs: [user.email]);
    return response;
  }

  // Method to delete a user from the database
  Future<int> deleteUser(String email) async {
    Database? myDb = await db;
    int response = await myDb!.delete('User', where: 'email = ?', whereArgs: [email]);
    return response;
  }

  // Method to fetch all users from the database
  Future<List<User>> fetchUsers() async {
    List<User> userList = [];
    String sql = 'SELECT * FROM User';

    try {
      List<Map<String, dynamic>>? result = await readData(sql);

      for (Map<String, dynamic> row in result!) {
        User user = User.fromMap(row);
        userList.add(user);
      }

      return userList;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
