class ValidatorService {
  static String? validateEmail(String? email) {
    if (email != null) {
      RegExp emailRegExp = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

      if (emailRegExp.hasMatch(email)) {
        return null;
      } else {
        return 'Enter a valid email';
      }
    } else {
      return 'Enter a valid email';
    }
  }

  static String? validatePassword(String? password) {
    if (password != null) {
      if (password.length < 6) {
        return 'Enter a password with length at least 6';
      } else {
        return null;
      }
    } else {
      return 'Enter a password with length at least 6';
    }
  }

  static String? validateNonEmptyFields(String? value) {
    if (value != null) {
      if (value.isEmpty) {
        return 'Enter a valid value';
      } else {
        return null;
      }
    } else {
      return 'Enter a valid value';
    }
  }
}
