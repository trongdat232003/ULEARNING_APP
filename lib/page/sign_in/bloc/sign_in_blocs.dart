import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_events.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_states.dart';

class SignInBlocs extends Bloc<SignInEvents, SigninStates> {
  SignInBlocs() : super(SigninStates()) {
    on<EmailEvents>(_emailEvent);
    on<PasswordEvents>(_passwordlEvent);
  }
  void _emailEvent(EmailEvents event, Emitter<SigninStates> emit) {
    print("My email is ${event.email}");
    emit(state.copyWith(email: event.email));
  }

  void _passwordlEvent(PasswordEvents event, Emitter<SigninStates> emit) {
    print("My password is ${event.password}");
    emit(state.copyWith(password: event.password));
  }
}
