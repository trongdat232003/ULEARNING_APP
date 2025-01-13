import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulearning_app/common/values/constant.dart';
import 'package:ulearning_app/common/widgets/flutter_toast.dart';
import 'package:ulearning_app/global.dart';
import 'package:ulearning_app/main.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_blocs.dart';

class SignInController {
  final BuildContext context;
  const SignInController({required this.context});
  Future<void> handleSignIn(String type) async {
    try {
      if (type == "email") {
        //BlocProvider.of<SignInBlocs>(context).state
        final state = context.read<SignInBlocs>().state;
        String emailAddress = state.email;
        String password = state.password;
        if (emailAddress.isEmpty) {
          //
          toastInfo(msg: "Your need to fill email address");
          return;
        }
        if (password.isEmpty) {
          //
          toastInfo(msg: "Your need to fill password");
          return;
        }
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: emailAddress, password: password);
          if (credential.user == null) {
            //
            toastInfo(msg: "Your don't exits");
            return;
          }
          if (!credential.user!.emailVerified) {
            //
            toastInfo(msg: "Your need to verify your email account");
            return;
          }
          var user = credential.user;
          if (user != null) {
            Global.storageService.setString(AppConstant.STORAGE_USER_TOKEN_KEY, "12345678");
            //we got verify user from firebase
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/application", (route) => false);
            print("user exits");
          } else {
            //we have error getting user from firebase
            toastInfo(msg: "Currently email format is wrong");
            return;
          }
          print("User signed in successfully");
        } on FirebaseAuthException catch (e) {
          print("---------------------------------------");
          print("FirebaseAuthException: ${e.code}");
          if (e.code == "user-not-found") {
            print("User not found");
            toastInfo(msg: "No user found that email");
          } else if (e.code == "wrong-password") {
            print("Wrong password triggered");
            toastInfo(msg: "Wrong password provided for that user");
          } else if (e.code == "invalid-email") {
            print("Invalid email format triggered");
            toastInfo(msg: "Your email format is wrong");
          }
        }
      }
    } catch (e) {
      print("Error");
    }
  }
}
