// Purpose: Test for authentication

// email validation
bool checkValidEmail(String email) {
  RegExp emailValidator = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailValidator.hasMatch(email);
}

// check for strong password
bool checkValidPassword(String password) {
  if (password.length < 8) {
    return false;
  }
  RegExp passwordValidator = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  return passwordValidator.hasMatch(password);
}
