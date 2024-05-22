import 'dart:async';


import '../../../core/database/LoginOperation.dart';
import '../../models/User.dart';

class LoginRequest {
  Loginoperation con = new Loginoperation();

  Future<User?> getLogin(String email, String password) {
    var result = con.getLogin(email, password);
    return result;
  }
}
