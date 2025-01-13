import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/page/register/bloc/register_events.dart';
import 'package:ulearning_app/page/register/bloc/register_states.dart';

class RegisterBlocs extends Bloc<RegisterEvents, RegisterStates> {
  RegisterBlocs() : super(const RegisterStates()) {
    on<UserNameEvents>(_userNameEvent);
    on<EmailEvent>(_emailEvent);
    on<PasswordEvent>(_passwordEvent);
    on<RePasswordEvents>(_rePasswordEvent);
  }
  void _userNameEvent(UserNameEvents event, Emitter<RegisterStates> emit) {
    emit(state.copyWith(userName: event.userName));
  }

  void _emailEvent(EmailEvent event, Emitter<RegisterStates> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordEvent(PasswordEvent event, Emitter<RegisterStates> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _rePasswordEvent(RePasswordEvents event, Emitter<RegisterStates> emit) {
    emit(state.copyWith(rePassword: event.rePassword));
  }
}
