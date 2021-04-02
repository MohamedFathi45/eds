

import 'package:dio/dio.dart';
import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/errors/failurs.dart';
import 'package:eds/stdlib/httpClient.dart';
import 'package:eds/stdlib/injector.dart';
import 'package:eds/stdlib/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LaravelLoginController implements LoginController{


  @override
  Future<LoginResponse> login(String username, String password) async {
    try {
      Map<String, dynamic> body =
      {
        'email': username,
        'password': password,
        'device_name' : 'android'
      };
      Response response = await makeKeylessRequest("sanctum/token", params: body);
      sl<User>().storeToken(token :response.data.toString());
      await this.tryToken(token: response.data.toString());
      return LoginResponse(true ,"");
    } on DioError catch(e){
      print("error occured");
      print(e.response.statusCode);
      print(e.response.data.toString());
      Failure f = await basicDioErrorHandler(e,{
        422: "Invalid credentials",
        404: "Connection error",
        503: "Access Denied",
        401: "Invalid credentials"
      });
      return LoginResponse(false , f.message);
    }

    }

  Future<void> tryToken({String token}) async{
    if(token == null)
      return;
    else{
      try{
        Response response = await makeKeyRequest("/user");
        sl<User>().setUserFromJson(response.data);
      }catch (e){
        if (e is DioError){
            print(e.message);
        }
        else{
          print(e);
        }
      }
    }
  }
}