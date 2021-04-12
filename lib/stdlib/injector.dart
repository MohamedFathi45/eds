import 'package:eds/features/login/controller/laravel_login_controller.dart';
import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/models/user.dart';
import 'package:get_it/get_it.dart';



final sl = GetIt.instance;

void setUpLocator(){
    sl.registerSingleton<User>( User.empty() );
    sl.registerLazySingleton<LoginController>(() => LaravelLoginController());
}