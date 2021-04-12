
import 'package:eds/features/bloc/home_bloc.dart';
import 'package:eds/features/bloc/home_state.dart';
import 'package:eds/features/home/view/home_page.dart';
import 'package:eds/features/login/view/login_page.dart';
import 'package:eds/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
Map<String , WidgetBuilder> routes = {
  '/login' : (context) => LoginPage(),
    '/home' : (context) => BlocProvider<HomeBloc>(
     create:(context) => HomeBloc(IdelState()),
    child: HomeScreen(),)

};