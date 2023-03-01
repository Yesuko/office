import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:office/ui/controllers/user_controller.dart';
import 'package:provider/provider.dart';

import '../../../../logic/managers/user_manager.dart';
import '../../../../databases/services/validator_service.dart';
import '../../../widgets/account_setting.dart';
import '../../../widgets/rounded_button.dart';
import '../../../widgets/rounded_input_field.dart';
import '../../../widgets/rounded_password_field.dart';
import '../../../widgets/transition_screen.dart';
import '../../login/login_screen.dart';
import '../password_update_screen.dart';
import 'background.dart';

class Body extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String id = "";
    String password = "";
    String newPassword = "";

    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/icons/register.svg",
                height: size.height * 0.35,
              ),
              RoundedInputField(
                hintText: "Your Employee ID",
                onChanged: (value) {
                  id = value;
                },
                validator: (_) => ValidatorService.validateEmail(id),
              ),
              RoundedPasswordField(
                hintText: "Old password",
                onChanged: (value) {
                  password = value;
                },
                validator: (_) => ValidatorService.validatePassword(password),
              ),
              RoundedPasswordField(
                hintText: "New password",
                onChanged: (value) {
                  newPassword = value;
                },
                validator: (_) =>
                    ValidatorService.validatePassword(newPassword),
              ),
              Consumer<UserManager>(
                builder: (_, employee, __) => RoundedButton(
                    text: "UPDATE",
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FutureBuilder(
                              future: UserController.updatePassword(
                                email: id,
                                oldPassword: password,
                                newPassword: newPassword,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const TransitionScreen();
                                }
                                return const PasswordUpdateScreen();
                              },
                            ),
                          ),
                        );
                      }
                    }),
              ),
              SizedBox(height: size.height * 0.03),
              AccountSetting(
                  isLoginPage: false,
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginScreen();
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
