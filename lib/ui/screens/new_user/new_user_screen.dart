import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:office/ui/controllers/user_controller.dart';

import '../../widgets/header_text.dart';
import '../../widgets/return_button.dart';
import '../../widgets/top_bar.dart';
import '../login/login_screen.dart';

class NewUserScreen extends StatelessWidget {
  const NewUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          centerTitle: true,
          title: "Welcome",
          leading: ReturnButton(
              onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (constext) {
                        UserController.signOut();
                        return const LoginScreen();
                      },
                    ),
                  ))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const HeaderText(
            text: 'Oops! Hold on a moment, \nAdmin will set you up shortly.',
            alignment: Alignment.center,
            size: 20,
          ),
          Center(
            child: SvgPicture.asset(
              "assets/icons/chat.svg",
            ),
          ),
        ],
      ),
    );
  }
}
