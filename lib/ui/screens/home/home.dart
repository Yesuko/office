import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:office/ui/controllers/exception_controller.dart';
import 'package:office/ui/screens/new_user/new_user_screen.dart';
import 'package:office/ui/widgets/messenger.dart';

import '../../../logic/models/user.dart';
import '../../controllers/user_controller.dart';
import '../login/login_screen.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic _initUserData;

  @override
  initState() {
    super.initState();

    // ConnAuthService.tryConnection(context);
    _initUserData = UserController.authenticateUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initUserData,
      builder: (_, snapshot) {
        Widget widget = const LoginScreen();
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            CurrentUser? user = snapshot.data as CurrentUser;
            if (user.role == null) {
              widget = const NewUserScreen();
            } else {
              widget = const HomeScreen();
            }
          } else if (snapshot.hasError) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              String message = ExceptionController(snapshot.error).message;

              Messenger.showSnackBar(message: (message), context: context);
            });
          }
        }
        return widget;
      },
    );
  }
}
