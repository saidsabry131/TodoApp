

import '../../models/User.dart';
import 'LoginRequest.dart';

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
