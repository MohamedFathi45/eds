
import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:eds/stdlib/errors/failurs.dart';
import 'package:eds/stdlib/models/user.dart';

import 'injector.dart';


Dio _dio = Dio();



String restBaseUrl = "http://1481d8229baa.ngrok.io/engineering_app_web_service/public/api/";



// without any token
Future<Response> makeKeylessRequest(String endpoint , {Map<String,dynamic>params}) async{
   String url = _createURL(endpoint);
   String json_data = json.encode(params);
   _dio.options.headers['Accept'] = 'application/json';
   final Response response = await _dio.post(url,
       data: json_data,
   );
   return response;

}


// if the user gets here this means he must have token
Future<Response> makeKeyRequest(String endpoint , {Map<String,dynamic>params}) async{
  String _token = await sl<User>().getUserToken();
  if(_token == null){
    throw Exception("No Api key you should never get here");
  }
  final String url = _createURL(endpoint);
  Response response;


  try{
      if(params != null){   // post request
        String json_data = json.encode(params);
        _dio.options.headers['Accept'] = 'application/json';
         response = await _dio.post(url,
             options: Options(
                 headers: {
                   "authorization": 'Bearer $_token',
                 }
             ),
          data: json_data,
        );
      }
      else{                 // get request
        _dio.options.headers['Accept'] = 'application/json';
        response = await _dio.get(url,
          options: Options(
              headers: {
                "authorization": 'Bearer $_token',
              }
          ),
        );
      }
  }on DioError catch(e){
      if(e.response == null || e.response.statusCode != 401){   // 401 means jwt or api key expired
        rethrow;
      }

      /*if(await refresh_api_key()){      // if we succeded refreshing then its ok
        response = await makeKeyRequest(endpoint , params: params);
      }
       */
  }
  return response;
}


String _createURL(String endpoint){
  String url = endpoint;
  if(url.startsWith("/") && url.length > 1) url = url.substring(1);
  return "${restBaseUrl}$url";
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



Future<bool> _isConnected() async{
  final DataConnectionChecker connectionChecker = DataConnectionChecker();
  final bool connectivityResult = await connectionChecker.hasConnection;
  if(connectivityResult){
    return true;
  }
  return false;
}

class LoginResponse{
  final bool activate;
  final String message;

  LoginResponse(this.activate, this.message);
}