import 'dart:convert';

import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/injector.dart';
import 'package:eds/stdlib/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eds/stdlib/httpClient.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _validate = true;
  String message = "";
  Color messageColor = Colors.red;
  bool _loading = false;
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _emaiController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginController controller = sl<LoginController>();
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
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: messageColor),
                    ),
                    _buildField("Email",_emaiController ,context,secure: false ,icon:Icons.email),
                    _buildField("password", _passwordController,context ,secure: true , icon: Icons.lock),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: (){
                        if(! _emaiController.text.isEmpty && ! _passwordController.text.isEmpty) {
                            _validate = true;
                            _loginFunction(controller);
                          }
                        else{
                          setState(() {
                            _validate = false;
                          });
                        }
                        },
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

  Future<void> _loginFunction(LoginController controller) async{
    _isLoading(true);
    LoginResponse response = await controller.login(_emaiController.text , _passwordController.text);
    _isLoading(false);
    if(response.activate){

      Navigator.pop(context ,response);
    }
    else{
      setState(() {
        message = response.message;
      });
    }
  }
  Widget _determinInButtonWidget(){
    if(_loading )
      return const CupertinoActivityIndicator(animating: true,);
    else
      return Text("Log in".toUpperCase() , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),);
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
            errorText: _validate ? null :'Value Can\'t Be Empty',
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
