import 'package:eds/features/bloc/home_bloc.dart';
import 'package:eds/features/bloc/home_event.dart';
import 'package:eds/features/bloc/home_state.dart';
import 'package:eds/features/login/controller/laravel_login_controller.dart';
import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/httpClient.dart';
import 'package:eds/stdlib/injector.dart';
import 'package:eds/stdlib/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  LoginController loginController;
  HomeBloc homeBloc;



  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    loginController = sl<LoginController>();
    tryToLogin();
  }


  void tryToLogin() async{
    String token = await readToken();
    if(await loginController.tryToken(token: token) == true){
        homeBloc.add(UserIsLoggedInEvent());
    }
  }

  Future<String> readToken() async{
    String token = await storage.read(key : 'token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: BlocBuilder<HomeBloc,HomeState>(
            builder: (context , state){
              if(state is SetUserDataState) {
                return userLoggedInWidget(context);
              }
              else if(state is IdelState){
                return userLoggedOutWidget(context);
              }
              else{
                throw('Undocumented State');
              }
            }
        ),
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
                backgroundImage: NetworkImage(sl<User>().avatar),
                radius: 30,
                backgroundColor: Colors.white,
              ),
              Text(sl<User>().user_name , style: TextStyle(
                  color: Colors.white
              ),),
              SizedBox(height: 8.0,),
              Text(sl<User>().email, style: TextStyle(
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
            homeBloc.add(UserIsLoggedOutEvent());
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
          Object obj = await Navigator.pushNamed(context, '/login');
          if(obj != null) {
              LoginResponse response = obj as LoginResponse;
              if (response.activate) {
                  homeBloc.add(UserIsLoggedInEvent());
              }
            }
          },
        )
      ],
    );
  }
}
