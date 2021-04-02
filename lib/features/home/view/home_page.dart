import 'package:eds/features/login/controller/laravel_login_controller.dart';
import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/httpClient.dart';
import 'package:eds/stdlib/injector.dart';
import 'package:eds/stdlib/models/user.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _user;

  @override
  Widget build(BuildContext context) {
    if(sl<User>().authenticated)
      _user = sl<User>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: sl<User>().authenticated ?
            userLoggedInWidget(context) : userLoggedOutWidget(context)
      ),
      body: Center(
        child: Text("Home Screen"),
      ),
    );
  }
  Widget userLoggedInWidget(BuildContext context){
    return ListView(
      children: [
        DrawerHeader(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_user.avatar),
                radius: 30,
                backgroundColor: Colors.white,
              ),
              Text(_user.user_name , style: TextStyle(
                  color: Colors.white
              ),),
              SizedBox(height: 8.0,),
              Text(_user.email, style: TextStyle(
                  color: Colors.white)
              )
            ],
          ),
          decoration: BoxDecoration(
              color :Colors.blue
          ),
        ),
        ListTile(
          title: Text("Logout"),
          leading: Icon(Icons.lock),
          onTap: (){
            setState(() {
              sl<User>().logout();
            });
          },
        )
      ],
    ); 
  }
  Widget userLoggedOutWidget(BuildContext context){
    return ListView(
      children: [
        ListTile(
          title: Text("Login"),
          leading: Icon(Icons.lock_open),
          onTap: () async {
            LoginController loginController = LaravelLoginController();
          Object obj = await Navigator.pushNamed(context, '/login' , arguments: loginController);
          if(obj != null) {
            LoginResponse response = obj as LoginResponse;
            if (response.activate) {
              setState(() {
                sl<User>().isLoggedIn = true;
              });
            }
          }
          },
        )
      ],
    );
  }
}
