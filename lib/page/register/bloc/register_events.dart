abstract class RegisterEvents {
  const RegisterEvents();
}

class UserNameEvents extends RegisterEvents {
  final String userName;
  const UserNameEvents(this.userName);
}

class EmailEvent extends RegisterEvents {
  final String email;
  const EmailEvent(this.email);
}

class PasswordEvent extends RegisterEvents {
  final String password;
  const PasswordEvent(this.password);
}

class RePasswordEvents extends RegisterEvents {
  final String rePassword;
  const RePasswordEvents(this.rePassword);
}
