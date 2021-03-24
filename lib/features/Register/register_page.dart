import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eds/stdlib/errors/failurs.dart';
import 'package:eds/stdlib/httpClient.dart';
import 'package:eds/stdlib/ui/colors.dart';
import 'package:dio/dio.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String message = "";
  Color messageColor = Colors.red;
  bool _loading = false;
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 1.0],
              colors: [Color(0xffFFAFBD), Color(0xffffc3a0)]
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 19.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: const Offset(3, 4),
                        spreadRadius: 3,
                        blurRadius: 3
                    )
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(16.0))
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: messageColor),
                    ),
                    _buildField("Username",_userNameController ,context,secure: false ,icon:Icons.person),
                    _buildField("Email Adress",_emaiController ,context,secure: false ,icon:Icons.email),
                    _buildField("Phone",_phoneController ,context,secure: false ,icon:Icons.phone),
                    _buildField("password", _passwordController,context ,secure: true , icon: Icons.lock),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: (){_loginFunction();},
                      child: _determinInButtonWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loginFunction() async{
    _isLoading(true);
    try{
      Map<String,dynamic> body =
      {
        'email' : _emaiController.text,
        'password' : _passwordController.text
      };

      Response response = await makeKeylessRequest("/login.php/" , params: body);
      //handel response
      login(response);
    } on DioError catch(e){
      Failure f = await basicDioErrorHandler(e,{
        404: "Invalid credentials",
        503: "Access Denied",
        401: "Invalid credentials"
      });
      setState(() {
        message = f.message;
      });
    }
    _isLoading(false);
  }
  Widget _determinInButtonWidget(){
    if(_loading )
      return const CupertinoActivityIndicator(animating: true,);
    else
      return Text("Log in".toUpperCase() , style: TextStyle(color: Colors.white),);
  }

  Widget _buildField(String text ,TextEditingController controller  , BuildContext context,{bool secure = false , IconData icon}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0 , vertical: 10.0),
      child: TextField(
          controller: controller,
          obscureText: secure,
          cursorColor: Theme.of(context).cursorColor,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: text,
          )
      ),
    );
  }
  void _isLoading(bool loading) {
    if (loading) {
      setState(() {
        _loading = true;
        message = "";
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }
}
