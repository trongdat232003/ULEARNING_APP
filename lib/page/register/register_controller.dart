import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:ulearning_app/common/widgets/flutter_toast.dart';
import 'package:ulearning_app/page/register/bloc/register_blocs.dart';

Future<void> sendMail(String userName, String email) async {
  // Cài đặt Mailtrap SMTP Server
  final smtpServer = SmtpServer(
    'smtp.mailtrap.io', // Mailtrap SMTP Host
    port: 587, // Port
    username: 'ee549f8574a3c1', // Mailtrap username
    password: 'c995c8116c362c', // Mailtrap password
  );

  // Soạn email thông báo
  final message = Message()
    ..from = Address('no-reply@ulearning.com', 'ULearning Support')
    ..recipients.add(email) // Người nhận
    ..subject = 'Verify your email for ULearning'
    ..text = '''
Hello $userName,

Thank you for registering with ULearning.

Please follow the link below to verify your email address:
https://ulearning-app-d11ad.firebaseapp.com/__/auth/action?mode=verifyEmail&oobCode=generated_oob_code

If you didn’t ask to verify this address, you can ignore this email.

Thanks,
Your ULearning Team
''';

  try {
    await send(message, smtpServer);
    print("Mail sent successfully!");
  } catch (e) {
    print("Failed to send email: $e");
    toastInfo(msg: "Failed to send welcome email.");
  }
}

class RegisterController {
  final BuildContext context;
  const RegisterController(this.context);

  Future<void> handleEmailRegister() async {
    final state = context.read<RegisterBlocs>().state;

    String userName = state.userName;
    String email = state.email;
    String password = state.password;
    String rePassword = state.rePassword;

    // Kiểm tra các trường thông tin
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
      // Đăng ký người dùng với Firebase
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Cập nhật tên hiển thị của người dùng
        await credential.user?.updateDisplayName(userName);

        // Gửi email xác minh thông qua Firebase
        await credential.user?.sendEmailVerification();
        // Gửi email với Mailtrap
        await sendMail(userName, email);

        // Thông báo thành công
        toastInfo(
          msg:
              "An email has been sent to your registered email. Please check your inbox and click on the link to verify your account.",
        );

        // Quay lại màn hình trước
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi Firebase
      if (e.code == 'weak-password') {
        toastInfo(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        toastInfo(msg: "The email is already in use.");
      } else if (e.code == 'invalid-email') {
        toastInfo(msg: "Your email is invalid.");
      } else {
        toastInfo(msg: "Registration failed: ${e.message}");
      }
    }
  }
}
