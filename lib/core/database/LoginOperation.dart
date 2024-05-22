

import '../../auth/models/User.dart';
import 'DBHelper.dart';

class Loginoperation {
  final DBHelper con = DBHelper();

  // Insertion
  Future<int> saveUser(User user) async {
    var dbClient = await con.db;
    if (dbClient == null) {
      return 0;
    }
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  // Deletion
  Future<int> deleteUser(User user) async {
    var dbClient = await con.db;
    if (dbClient == null) {
      return 0;
    }
    int res = await dbClient.delete("User", where: 'email = ?', whereArgs: [user.email]);
    return res;
  }

  // Fetch user by username and password
  Future<User?> getLogin(String email, String password) async {
    var dbClient = await con.db;
    if (dbClient == null) {
      return null;
    }
    var res = await dbClient.query(
      "User",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
    
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  // Fetch all users
  Future<List<User>> getAllUsers() async {
    var dbClient = await con.db;
    if (dbClient == null) {
      return [];
    }
    var res = await dbClient.query("User");
    
    List<User> list = res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return list;
  }
}
