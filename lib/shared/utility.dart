class Utility {
  static String? phoneNumberValidator(String? phoneNumber) {
    if (phoneNumber?.length != 10) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? passwordLengthValidator(String? password) {
    if (password!.length < 6) {
      return 'Pleas enter a valid phone number';
    }
    return null;
  }
}
