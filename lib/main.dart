import 'package:eds/features/bloc/home_bloc.dart';
import 'package:eds/features/bloc/home_state.dart';
import 'package:eds/stdlib/routes.dart';
import 'package:flutter/material.dart';
import 'package:eds/stdlib/injector.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/home/view/home_page.dart';

void main() {
  di.setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: '/home',
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
