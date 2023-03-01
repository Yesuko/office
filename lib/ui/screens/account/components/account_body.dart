import 'package:flutter/material.dart';

import '../../../controllers/user_controller.dart';
import '../../../../util.dart';
import '../../../widgets/transition_screen.dart';
import '../../login/login_screen.dart';
import '../../password_update/password_update_screen.dart';
import 'background.dart';

class AccountBody extends StatelessWidget {
  const AccountBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ListTile(
            title: const Text("Update password"),
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PasswordUpdateScreen())),
          ),
          ListTile(
            title: const Text("Log out"),
            textColor: kFontColorRed,
            onTap: () async {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return FutureBuilder(
                    future: UserController.signOut(),
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return const LoginScreen();
                      } else {
                        return const TransitionScreen();
                      }
                    });
              }));
            },
          )
        ],
      ),
    );
  }
}
