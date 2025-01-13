import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/page/register/bloc/register_blocs.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_blocs.dart';
import 'package:ulearning_app/page/welcome/bloc/welcome_blocs.dart';

class AppBlocProvider {
  static get allBlocProvider => [
        BlocProvider(
          lazy: false,
          create: (context) => WelcomeBlocs(),
        ),
        // BlocProvider(lazy: false, create: (context) => AppBlocs()),
        BlocProvider(create: (context) => SignInBlocs()),
        BlocProvider(create: (context) => RegisterBlocs()),
      ];
}
