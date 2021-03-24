
import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutterblog/stdlib/config/config.dart';
import 'package:flutterblog/stdlib/errors/failurs.dart';
import 'package:flutterblog/stdlib/injector.dart';

import 'models/user.dart';

Dio _dio = Dio();
final Config _config = sl<Config>();


Future<Response> makeKeylessRequest(String endpoint , {Map<String,dynamic>params}) async{
  final String url = _createURL(endpoint);
  String json_data = json.encode(params);
  final Response response = await _dio.post(url,
  data: json_data,
  options: Options(contentType: 'application/json; charset=utf-8'));
  return response;
}

Future<Response> makeKeyRequest(String endpoint , {Map<String,dynamic>params}) async{
  if(await User.getRefreshToken() == null){
    throw Exception("No Api key you should never get here");
  }
  final String url = _createURL(endpoint);
  Response response;
  try{
      if(params != null){   // post request
          response = await _dio.post(url,
          data: params,
          options: Options(contentType: "application/json",
          headers: {
            "authorization": await User.getRefreshToken(),
          }
          ));
      }
      else{                 // get request
        response = await _dio.get(url,
            options: Options(contentType: "application/json",
                headers: {
                  "authorization": await User.getRefreshToken(),
                }
            ));
      }
  }on DioError catch(e){
      if(e.response == null || e.response.statusCode != 401){   // 401 means jwt or api key expired
        rethrow;
      }

      if(await refresh_api_key()){      // if we succeded refreshing then its ok
        response = await makeKeyRequest(endpoint , params: params);
      }
  }
  return response;
}
String _createURL(String endpoint){
  String url = endpoint;
  if(url.startsWith("/") && url.length > 1) url = url.substring(1);
  if(!url.endsWith("/")) url ="$url/";
  return "http://${_config.restBaseUrl}$url";
}

Future<Failure> basicDioErrorHandler(DioError e , Map<int,String> extraErrors) async{
  if (e.error is SocketException){
    return Failure(message: "Couldn't connect to our servers. Please try again soon.");
  } else if (e.response == null){
    if (!await _isConnected()){
      return Failure(message: "Couldn't connect to internet.");
    } else {
      return Failure(message: "Couldn't make connection.");
    }
  }
  Failure f = Failure(message: "UnKnown Error", resolved: false);
  extraErrors.forEach((code, error) {
      if(code == e.response.statusCode){
        f = Failure(message: error , resolved: true);
      }
  });
  return f;
}

Future<bool> refresh_api_key() async{
  Response response;
  print("Tried to refresh the key");
  try{
    response = await makeKeyRequest("/refresh_key.php/");
  } on DioError catch(e , st){
      sl<User>().signOut();
      print(e);
      print(st);
      return false;
  }
  final Map<String , dynamic> responseMap = response.data;
  User.setRefreshToken(responseMap["jwt"] as String);
  return true;
}

Future<bool> _isConnected() async{
  final DataConnectionChecker connectionChecker = DataConnectionChecker();
  final bool connectivityResult = await connectionChecker.hasConnection;
  if(connectivityResult){
    return true;
  }
  return false;
}