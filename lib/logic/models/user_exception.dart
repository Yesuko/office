class UserManagementException {
  final String error;
  const UserManagementException(this.error);
}

class UserControllerException {
  final String error;
  const UserControllerException(this.error);
}

class UserDataException {
  late final String error;
  UserDataException(String error) {
    int index = 0;
    String? message = error;

    index = message.indexOf('.');
    message = message.substring(0, index + 1);
    this.error = message;
  }
}
