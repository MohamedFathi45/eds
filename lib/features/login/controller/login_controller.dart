
import 'package:eds/stdlib/httpClient.dart';

abstract class LoginController{
  Future<LoginResponse> login(String username , String password);
}

