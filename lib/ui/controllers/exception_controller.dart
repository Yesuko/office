import 'package:office/logic/models/user_exception.dart';

class ExceptionController {
  final Object? error;
  const ExceptionController(this.error);

  String get message {
    String message = "Excepetion not implemented";

    if (error is UserDataException) {
      message = (error as UserDataException).error;
    } else if (error is UserManagementException) {
      message = (error as UserManagementException).error;
    } else if (error is UserControllerException) {
      message = (error as UserControllerException).error;
    }
    return message;
  }
}
