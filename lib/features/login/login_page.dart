import 'dart:convert';
import 'package:eds/features/login/bloc/login_event.dart';
import 'package:eds/stdlib/errors/failurs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutterblog/features/login/domain/login.dart';
import 'package:flutterblog/stdlib/httpClient.dart';
import 'package:eds/stdlib/ui/colors.dart';
import 'package:dio/dio.dart';

import 'bloc/login_bloc.dart';


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

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
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
                          blurRadius: 3)
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
                            "Log in",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyText1.copyWith(color: messageColor),
                        ),
                        _buildField("Email",_emaiController ,context,secure: false ,icon:Icons.email),
                        _buildField("password", _passwordController,context ,secure: true , icon: Icons.lock),
                        MaterialButton(
                          color: Theme.of(context).primaryColor,
                            onPressed: (){loginBloc.add(LoginButtonPushed());},
                          child: _determinLogInButtonWidget(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Center(
              child: Text(
                "Create new Account",
              style: TextStyle(color: Colors.white ,),
              ),
            ),
          )
        ],
      ),

      );
  }

  Future<void>_registerFunction() async{
    _isLoading(true);
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
  Widget _determinLogInButtonWidget(){
    if(_loading )
      return const CupertinoActivityIndicator(animating: true,);
    else
      return Text("Log in".toUpperCase() , style: TextStyle(color: Colors.white),);
  }

  Widget _determinRegisterButtonWidget(){
    if(_loading)
      return const CupertinoActivityIndicator(animating: true,);
    else
      return Text("Register now".toUpperCase() , style: TextStyle(color: Colors.white),);
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
