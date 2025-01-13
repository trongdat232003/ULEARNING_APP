import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/page/welcome/bloc/welcome_events.dart';
import 'package:ulearning_app/page/welcome/bloc/welcome_states.dart';
import 'package:ulearning_app/page/welcome/welcome.dart';

class WelcomeBlocs extends Bloc<WelcomeEvents, WelcomeStates> {
  WelcomeBlocs() : super(WelcomeStates()) {
    print("Welcome bloc");
    on<WelcomeEvents>((event, emit) {
      emit(WelcomeStates(page: state.page));
    });
  }
}
