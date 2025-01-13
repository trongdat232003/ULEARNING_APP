class SigninStates {
  final String email;
  final String password;
  const SigninStates({this.email = "", this.password = ""});
  SigninStates copyWith({String? email, String? password}) {
    return SigninStates(
        email: email ?? this.email, password: password ?? this.password);
  }
}
