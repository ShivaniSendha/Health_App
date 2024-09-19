class CustomValidator {
  // check if name is empty or not
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    // check if emaiL is empty or not
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    // check if password is empty or not
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    // check if  address is empty or not
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  static String? validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    } else if (value.length != 10 || !RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must be exactly 10 digits & contain only numbers';
    }
    return null;
  }

  static String? validateDOB(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter DOB';
    }
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your gender';
    }
    return null;
  }

  static String? validateBloodGroup(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your blood group';
    }
    return null;
  }
}
