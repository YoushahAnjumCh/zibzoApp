class FormValidator {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field can\'t be empty';
    } else if (value.length < 4) {
      return 'This field must be at least 4 characters long';
    }
    final regex = RegExp(r'^[a-zA-Z]+$');
    if (!regex.hasMatch(value)) {
      return 'Please enter only alphabetic characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password should minimum 8 characters';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    } else if (value.length < 8) {
      return 'Password should minimum 8 characters';
    }
    return null;
  }
}
