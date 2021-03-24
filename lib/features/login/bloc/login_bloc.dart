
import 'package:bloc/bloc.dart';
import 'package:eds/features/login/bloc/login_event.dart';
import 'package:eds/features/login/bloc/login_state.dart';
import 'package:eds/stdlib/httpClient.dart';

class LoginBloc extends Bloc<LoginEvent , LoginState>{
  LoginBloc(LoginState initialState) : super(initialState);


  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is ResetFormEvent)
      yield LoginInitial();
    else if(event is LoginButtonPushed){
      yield LoginLoading();
      try {
        await makeKeyRequest("/blog.php/", params: {
          "title": event.post.title,
          "body": event.post.body
        });
        yield LoginCompleted();
      } on DioError catch(e){
        yield LoginFailure(await basicDioErrorHandler(e , {}));
      }
    }
  }

}