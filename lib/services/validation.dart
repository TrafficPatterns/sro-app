class ValidateAddItem {
  String? validateFirstLastName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (!regExp.hasMatch((value))) {
      return 'Last Name can only be A-Z';
    }
    return null;
  }

  static String? validateName(String? value, {bool required = true}) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = RegExp(patttern);
    if (value == null) {
      return null;
    }
    value = value.trim();
    if ((value).isEmpty) {
      return required ? 'Name cannot be empty' : null;
    } else if (!regExp.hasMatch((value))) {
      return 'Name has to be only A-Z';
    }
    return null;
  }

  static String? validateMobile(String? value, {bool required = false}) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    if (value == null) {
      return null;
    } else if (value.isEmpty) {
      return required ? 'Phone is required' : null;
    } else if (value.length != 10) {
      return 'phone number has to be 10 digits long';
    } else if (!regExp.hasMatch(value)) {
      return 'Phone number can only be digits';
    }
    return null;
  }

  static String? validateMobileWithFormatting(String? value,
      {bool required = false}) {
    if (value == null) {
      return null;
    } else if (value.isEmpty) {
      return required ? 'Phone number is required' : null;
    } else if (value.length != 14) {
      return 'phone number has to be 10 digits long';
    }
    return null;
  }

  static String? validateEmail(String? value, {bool required = true}) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return required ? 'the email is required' : null;
    } else if (!regExp.hasMatch(value.trim())) {
      return 'invalid Email';
    } else {
      return null;
    }
  }

  static String? validatePassword(String? pass, {bool required = true}) {
    if (pass == null) {
      return null;
    }
    var passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    String passwordd = pass.trim();
    if (passwordd.isEmpty) {
      return required ? 'Password is required' : null;
    } else if (passwordd.length < 6) {
      return 'Password is too short';
    } else if (passwordd.length > 20) {
      return 'Password cannot be more than 20 characters';
    } else {
      if (passValid.hasMatch(passwordd)) {
        return null;
      } else {
        return 'Password must be A-Z, a-z, 1-9, and a special charcter';
      }
    }
  }
}
