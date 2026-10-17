class Validators {
  Validators._();

  static String? email(String value) {
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? password(String value) {
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!value.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  static String? confirmPassword(String password, String confirm) {
    return password == confirm ? null : 'Passwords do not match.';
  }
}