
import 'package:eds/stdlib/httpClient.dart';

abstract class LoginController{
  Future<LoginResponse> login(String username , String password);
  Future<bool> tryToken({String token});
  Future<void> logout();
}

