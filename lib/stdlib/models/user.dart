
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User{
  FlutterSecureStorage storage = FlutterSecureStorage();
  String _id;
  String _avatar;
  bool isLoggedIn = false;
  String _userName;
  String _email;
  User(this._id,this._userName ,this._email ,this._avatar );

  void
  fromJson(Map<String ,dynamic> json){
    String id = json['id'].toString();
    _id = id;
    _userName = json['name'];
    _email = json['email'];
    _avatar = json['avatar'];
  }
  User.empty();



  void setUser(User user){
    _userName = user._userName;
    _email = user._email;
    _avatar = user._avatar;
  }
  void setUserFromJson(Map<String , dynamic> json){
    fromJson(json);
  }

  Future<String> getUserToken() async{    // must check th secure storage first
    String _token = await storage.read(key : 'token');
    return _token;
  }

  void logout() async{
    _id = null;
    isLoggedIn = false;
    _avatar = null;
    _userName = null;
    _email = null;
     await storage.delete(key: 'token');
  }
  void storeToken({String token}) async{
    print(token);
    await this.storage.write(key: 'token', value: token);
  }
  bool get authenticated => isLoggedIn;
  String get user_name =>_userName;
  String get email =>_email;
  String get avatar =>_avatar;
  String get id =>_id;
}