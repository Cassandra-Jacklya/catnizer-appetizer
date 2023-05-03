//error class for possible errors thrown by firebase auth
const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'wrong-password': AuthErrorWrongPassword(),
};

abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(String exception) =>
      authErrorMapping[exception.toLowerCase().trim()] ??
      const AuthErrorUnknown();
}

// auth/unknown

class AuthErrorUnknown extends AuthError {
  const AuthErrorUnknown()
      : super(
          dialogTitle: 'Authentication error',
          dialogText: 'Unknown authentication error',
        );
}

// auth/user-not-found

class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: 'User not found',
          dialogText: 'The given user was not found on the server!',
        );
}

// auth/weak-password

class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: 'Weak password',
          dialogText:
              'Please choose a stronger password consisting of more characters!',
        );
}

// auth/invalid-email

class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: 'Invalid email',
          dialogText: 'Please double check your email and try again!',
        );
}

// auth/email-already-in-use

class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: 'Email already in use',
          dialogText: 'Please choose another email to register with!',
        );
}

// auth/wrong-password

class AuthErrorWrongPassword extends AuthError {
  const AuthErrorWrongPassword()
      : super(
          dialogTitle: 'Wrong Password',
          dialogText: 'Please double check your password and try again!',
        );
}