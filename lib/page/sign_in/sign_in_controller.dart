import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ulearning_app/common/service/userService.dart';
import 'package:ulearning_app/common/values/constant.dart';
import 'package:ulearning_app/common/widgets/flutter_toast.dart';
import 'package:ulearning_app/global.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_blocs.dart';

class SignInController {
  final BuildContext context;
  const SignInController({required this.context});

  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        final state = context.read<SignInBlocs>().state;
        String emailAddress = state.email;
        String password = state.password;

        if (emailAddress.isEmpty) {
          toastInfo(msg: "Please enter your email address");
          return;
        }
        if (password.isEmpty) {
          toastInfo(msg: "Please enter your password");
          return;
        }

        final loginResult = await UserService.login(emailAddress, password);

        if (loginResult['success']) {
          String token = loginResult['data']['token'];
          var user = loginResult['data']['user'];
          // Lưu token vào SharedPreferences
          await UserService.saveToken(token);
          // // Store the token securely (e.g., in local storage or secure storage)
          Global.storageService
              .setString(AppConstant.STORAGE_USER_TOKEN_KEY, token);

          Navigator.of(context)
              .pushNamedAndRemoveUntil("/application", (route) => false);
          print("User signed in successfully");
        } else {
          toastInfo(msg: loginResult['message']);
        }
      }
    } catch (e) {
      print("Error: $e");
      toastInfo(msg: "An error occurred while logging in.");
    }
  }
}
