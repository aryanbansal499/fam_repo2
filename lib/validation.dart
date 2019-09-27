enum FormType{login, register}

class EmailValidator {
  static String validate(String value)
  {
    return value.isEmpty ? "Email can't be empty " : null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    return value.isEmpty ? "Password can't be empty" : null;
  }
}

class NonEmptyValidator {
  static String validate(String value) {
    return value.isEmpty ? "Password can't be empty" : null;
  }
}

class DateValidator {
  static String validate(String value) {
    NonEmptyValidator.validate(value);

    value.replaceAll(" ", "");
    value.replaceAll("\n", "");

    var date;

    //convert value to date
    if(!((value.contains('/', 2)) && (value.contains('/', 5)))
        ||  value.length != 10) {
      return "date should be in this format: dd/mm/yyyy";
    } else if ((date = DateTime.parse(value)) != null) {
      return "date should be in this format: dd/mm/yyyy";
    }
    else {
      return value;
    }

  }
}