// login_state.dart
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

abstract class LoginCallBack {
  void onLoginSuccess(User user);
  void onLoginError(String error);
}

class LoginResponse {
  LoginCallBack _callBack;
  LoginRequest loginRequest = new LoginRequest();

  LoginResponse(this._callBack);

  void doLogin(String email, String password) {
    loginRequest
        .getLogin(email, password)
        .then((user) => _callBack.onLoginSuccess(user!))
        .catchError((onError) => _callBack.onLoginError(onError.toString()));
  }
}

class LoginState implements LoginCallBack {
  late Function(User user) onSuccess;
  late Function(String error) onError;
  late LoginResponse _response;
  bool rememberPassword = true;

  LoginState({required this.onSuccess, required this.onError}) {
    _response = LoginResponse(this);
  }

  void doLogin(String email, String password) {
    _response.doLogin(email, password);
  }

  @override
  void onLoginSuccess(User user) {
    onSuccess(user);
  }

  @override
  void onLoginError(String error) {
    onError(error);
  }
}
