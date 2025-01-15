import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/page/common_widgets.dart';
import 'package:ulearning_app/page/register/bloc/register_blocs.dart';
import 'package:ulearning_app/page/register/bloc/register_events.dart';
import 'package:ulearning_app/page/register/bloc/register_states.dart';
import 'package:ulearning_app/page/register/register_controller.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_blocs.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_events.dart';
import 'package:ulearning_app/page/sign_in/bloc/sign_in_states.dart';
import 'package:ulearning_app/page/sign_in/sign_in_controller.dart';
// import 'package:ulearning_app/page/sign_in/widgets/sign_in_widget.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBlocs, RegisterStates>(
        builder: (context, state) {
      return Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar("Sign Up"),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Center(
                    child: reusableText(
                        "Enter your details below and free sign up")),
                Container(
                  margin: EdgeInsets.only(top: 60.h),
                  padding: EdgeInsets.only(left: 25.w, right: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText("Username"),
                      buildTextField("Enter your username", "name", "user",
                          (value) {
                        context
                            .read<RegisterBlocs>()
                            .add(UserNameEvents(value));
                      }),
                      reusableText("Email"),
                      buildTextField(
                          "Enter your email address", "email", "user", (value) {
                        context.read<RegisterBlocs>().add(EmailEvent(value));
                      }),
                      reusableText("Password"),
                      buildTextField(
                          "Enter your email password", "password", "lock",
                          (value) {
                        context.read<RegisterBlocs>().add(PasswordEvent(value));
                      }),
                      reusableText("Re-enter your password"),
                      buildTextField("Re-enter your password to confirm",
                          "password", "lock", (value) {
                        context
                            .read<RegisterBlocs>()
                            .add(RePasswordEvents(value));
                      })
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25.w),
                  child: reusableText(
                      "By creating an account you have to agree \nwith our them & condication"),
                ),
                buildLogInAndRegButton("Sign Up", "login", () {
                  // Navigator.of(context).pushNamed("register");
                  RegisterController(context).handleEmailRegister();
                }),
              ],
            ),
          ),
        )),
      );
    });
  }
}
