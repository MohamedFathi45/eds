
import 'package:eds/features/home/view/home_page.dart';
import 'package:eds/features/login/view/login_page.dart';
import 'package:eds/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
Map<String , WidgetBuilder> routes = {
  '/login' : (context) => LoginPage(),
  '/home' : (context) => HomeScreen(),
};