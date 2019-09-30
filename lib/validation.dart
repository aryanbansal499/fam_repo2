import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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

class NameValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return 'This field cannot be empty. Please enter name of the artefact';
    }
    return null;
  }
}

class DescriptionValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return 'This field cannot be empty. Please enter name of the artefact';
    }
    return null;
  }
}

class DateValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return 'This field cannot be empty. Enter a date';
    }

    else if (!(value.contains('/', 2))
        || !(value.contains('/', 5))
        || value.length != 10) {
      return "date should be in this format: dd/mm/yyyy";
    }

    return null;

//    String date = value;
//    date.replaceAll(" ", "");
//    date.replaceAll("\n", "");
//
//    DateTime dateFinal;
//
//    //convert value to date
//    if(!((value.contains('/', 2)) && (value.contains('/', 5)))
//        ||  value.length != 10
//        || value.isEmpty) {
//      return "date should be in this format: dd/mm/yyyy";
//    }
//    if ((dateFinal = DateTime.parse(value)) == null) {
//      return "date should be in this format: dd/mm/yyyy";
//    }
//    return null;
  }
}
