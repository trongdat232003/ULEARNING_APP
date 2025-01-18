import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/common/service/userService.dart';
import 'package:ulearning_app/common/widgets/flutter_toast.dart';
import 'package:ulearning_app/page/register/bloc/register_blocs.dart';

class RegisterController {
  final BuildContext context;
  const RegisterController(this.context);

  Future<void> handleEmailRegister() async {
    final state = context.read<RegisterBlocs>().state;

    String userName = state.userName;
    String email = state.email;
    String password = state.password;
    String rePassword = state.rePassword;

    // Validate input fields
    if (userName.isEmpty) {
      toastInfo(msg: "User name cannot be empty");
      return;
    }
    if (email.isEmpty) {
      toastInfo(msg: "Email cannot be empty");
      return;
    }
    if (password.isEmpty) {
      toastInfo(msg: "Password cannot be empty");
      return;
    }
    if (rePassword.isEmpty) {
      toastInfo(msg: "Re-Password cannot be empty");
      return;
    }
    if (password != rePassword) {
      toastInfo(msg: "Passwords do not match");
      return;
    }

    try {
      // Call the UserService to register the user
      final result = await UserService.register(userName, email, password);

      if (result['success']) {
        // Registration successful, send verification email or proceed with next steps
        toastInfo(msg: "Registration successful. Please verify your email.");

        // Optionally send verification email, navigate, etc.
        Navigator.of(context).pop(); // Go back or to next screen
      } else {
        // Handle registration failure
        toastInfo(msg: result['message'] ?? "Registration failed");
      }
    } catch (e) {
      print("Error: $e");
      toastInfo(msg: "Registration failed. Please try again.");
    }
  }
}
