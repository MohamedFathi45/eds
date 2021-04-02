import 'package:eds/stdlib/models/user.dart';
import 'package:get_it/get_it.dart';



final sl = GetIt.instance;

void setUpLocator(){
    sl.registerSingleton<User>( User.empty() );
}