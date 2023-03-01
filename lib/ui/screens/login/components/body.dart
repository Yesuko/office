import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:office/ui/controllers/exception_controller.dart';
import 'package:office/ui/widgets/messenger.dart';

import '../../../../logic/models/user.dart';
import '../../../widgets/account_setting.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/rounded_button.dart';
import '../../../widgets/rounded_input_field.dart';
import '../../../widgets/rounded_password_field.dart';
import '../../../widgets/transition_screen.dart';
import '../../home/home_screen.dart';
import '../../../../databases/services/validator_service.dart';

import '../../../screens/login/login_screen.dart';
import '../../new_user/new_user_screen.dart';
import '../../register/register_screen.dart';
import './background.dart';

class LoginBody extends StatelessWidget {
  LoginBody({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    String? email;
    String? password;

    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Email",
                onChanged: (value) {
                  email = value;
                },
                validator: (_) => ValidatorService.validateEmail(email),
              ),
              RoundedPasswordField(
                onChanged: (value) {
                  password = value;
                },
                validator: (_) => ValidatorService.validatePassword(password),
              ),

              RoundedButton(
                  text: "LOGIN",
                  press: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return FutureBuilder(
                            // get  user and navigate to the right screen
                            future: UserController.authenticateUser(
                              email: email,
                              password: password,
                            ),
                            builder: (_, snapshot) {
                              Widget widget = const LoginScreen();
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  CurrentUser user =
                                      snapshot.data as CurrentUser;

                                  if (user.role == null) {
                                    widget = const NewUserScreen();
                                  } else {
                                    widget = const HomeScreen();
                                  }
                                } else if (snapshot.hasError) {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    String message =
                                        ExceptionController(snapshot.error)
                                            .message;

                                    Messenger.showSnackBar(
                                        message: (message), context: context);
                                  });
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                //if future is not done, run this branch
                                widget = const TransitionScreen();
                              }
                              return widget;
                            },
                          );
                        }),
                      );
                    }
                  }),
              // on press navigate to update user password
              SizedBox(height: size.height * 0.03),
              AccountSetting(press: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const RegisterScreen();
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
