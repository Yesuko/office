import 'package:office/logic/managers/attendance_manager.dart';
import 'package:office/logic/managers/chat_manager.dart';

import 'package:office/logic/models/user.dart';
import 'package:office/logic/models/user_exception.dart';
import 'package:provider/provider.dart';

import '../../logic/managers/user_manager.dart';
import 'base_controller.dart';

class UserController extends BaseController {
  static final UserManager provider =
      BaseController.context.read<UserManager>();

  static Future<CurrentUser> authenticateUser({
    String? email,
    String? password,
  }) async {
    return await provider.authenticateUser(
      email,
      password,
    );
  }

  static Future<void> updatePassword({
    required String? oldPassword,
    required String? email,
    required String? newPassword,
  }) async {
    if (email == null || oldPassword == null || newPassword == null) {
      return;
    }

    await provider.signInAndUpdateUserPassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  static Future<CurrentUser> registerUser({
    required String? displayName,
    required String? email,
    required String? password,
    required String? department,
  }) async {
    try {
      if (displayName == null ||
          email == null ||
          password == null ||
          department == null) {
        throw const UserControllerException("user data can't be found");
      } else {
        return await provider.registerNewUser(
            displayName: displayName,
            email: email,
            password: password,
            department: department);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signOut() async {
    final attProv = BaseController.context.read<AttendanceManager>();
    final chatProv = BaseController.context.read<ChatManager>();

    await chatProv.tidyUp();
    await attProv.tidyUp();
    await provider.signOut();
  }

  static CurrentUser get currentUser => provider.currentUser;
}
