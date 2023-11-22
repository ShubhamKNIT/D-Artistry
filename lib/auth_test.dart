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

// check valid name (alphabets only)
// with allowance of two spaces only
bool checkValidName(String name) {
  RegExp regex = RegExp(r'^[a-zA-Z ]+$');
  return regex.hasMatch(name);
}

// check validDOB
// user must be 7 years old or above
// dob format is dd//mm/yyyy
bool checkValidDOB(String dob) {
  DateTime now = DateTime.now();
  List<String> dobList = dob.split('/');
  int day = int.parse(dobList[0]);
  int month = int.parse(dobList[1]);
  int year = int.parse(dobList[2]);
  DateTime dobDate = DateTime(year, month, day);
  int age = now.year - dobDate.year;
  if (now.month < dobDate.month) {
    age--;
  } else if (now.month == dobDate.month) {
    if (now.day < dobDate.day) {
      age--;
    }
  }
  return age >= 7;
}