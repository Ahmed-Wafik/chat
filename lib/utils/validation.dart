class ValidateInput {
  static String validateEmail(String value) {
    if (value.isEmpty) {
      return 'e-mail can\'t be empty';
    } else {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'invalid e-mail';
      } else {
        return null;
      }
    }
  }

  static validateConformPass(String first, String second) =>
      first != second ? 'password doesn\'t match' : null;

  static String validatePassword(String value) {
    if (value.isEmpty || value == null) {
      return 'password can\'t be empty';
    } else if (value.length < 8) {
      return 'password must be at least 8 characters';
    }
    return null;
  }

  static String validateUsername(String value) {
    if (value.isEmpty || value == null)
      return 'username can\'t be empty';
    else
      return null;
  }

  static String validatePhone(String value) {
    if (value.isEmpty || value == null)
      return 'phone can\'t be empty';
    else
      return null;
  }
}
