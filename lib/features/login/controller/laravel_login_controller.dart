

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/errors/failurs.dart';
import 'package:eds/stdlib/httpClient.dart';
import 'package:eds/stdlib/injector.dart';
import 'package:eds/stdlib/models/user.dart';

class LaravelLoginController implements LoginController{
  DeviceInfoPlugin deviceinfo = DeviceInfoPlugin();

  @override
  Future<LoginResponse> login(String username, String password) async {
    try {
      String _device_name = await getDeviceName();
      Map<String, dynamic> body =
      {
        'email': username,
        'password': password,
        'device_name' : _device_name?? 'UnKnown'
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

  Future<bool> tryToken({String token}) async{
    if(token == null)
      return false;
    else{
      try{
        Response response = await makeKeyRequest("/user");
        sl<User>().setUserFromJson(response.data);
        if(response.statusCode == 200){   //success
          return true;
        }
        else{
          return false;
        }
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

  @override
  Future<void> logout() async{
    try {
      Response response = await makeKeyRequest("user/revoke");

      sl<User>().logout();
    }catch(e){
      print(e);
    }
  }

  Future<String> getDeviceName() async{
     try{
        if(Platform.isAndroid){
          AndroidDeviceInfo androidDeviceInfo = await deviceinfo.androidInfo;
          return androidDeviceInfo.model;
        }else if(Platform.isIOS){
            IosDeviceInfo iosDeviceInfo = await deviceinfo.iosInfo;
            return iosDeviceInfo.utsname.machine;
        }
     }catch(e){

     }
  }
}