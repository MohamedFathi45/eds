

import 'package:bloc/bloc.dart';
import 'package:eds/features/bloc/home_state.dart';
import 'package:eds/features/login/controller/login_controller.dart';
import 'package:eds/stdlib/injector.dart';
import 'package:eds/stdlib/models/user.dart';

import 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent , HomeState>{
  HomeBloc(HomeState initialState) : super(initialState);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async*{
    if(event is UserIsLoggedInEvent){
      sl<User>().isLoggedIn = true;
      yield SetUserDataState();
    }
    else if(event is UserIsLoggedOutEvent){
      sl<LoginController>().logout();
      yield IdelState();
    }
  }

}