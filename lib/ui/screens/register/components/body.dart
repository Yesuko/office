import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:office/logic/models/user.dart';
import 'package:office/ui/controllers/exception_controller.dart';
import 'package:office/ui/widgets/messenger.dart';

import '../../../controllers/user_controller.dart';
import '../../../../databases/services/textformat_service.dart';
import '../../../../databases/services/validator_service.dart';
import '../../../widgets/account_setting.dart';
import '../../../widgets/dropdown_field.dart';
import 'email_field.dart';
import '../../../widgets/rounded_button.dart';
import '../../../widgets/rounded_input_field.dart';
import '../../../widgets/rounded_password_field.dart';
import '../../../widgets/transition_screen.dart';
import '../../home/home_screen.dart';
import '../../login/login_screen.dart';
import '../../new_user/new_user_screen.dart';
import '../register_screen.dart';
import 'first_name_field.dart';
import 'social_divider.dart';
import 'social_icon.dart';
import 'background.dart';

class RegisterBody extends StatelessWidget {
  RegisterBody({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String? password;
    String? department;
    String? firstName;
    String? lastName;

    return RegisterBackground(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.03),
              CircleAvatar(
                radius: size.height * 0.08,
                child: Icon(
                  Icons.camera_alt,
                  size: size.height * 0.10,
                ),
              ),
              FirstNameField(
                otherController: _emailController,
                onSaved: (value) {
                  firstName = value;
                },
                validator: (value) =>
                    ValidatorService.validateNonEmptyFields(value),
              ),
              RoundedInputField(
                hintText: "Last Name",
                inputFormatters: [UpperCaseBeginningTextFormatter()],
                onSaved: (value) {
                  lastName = value;
                },
                validator: (value) =>
                    ValidatorService.validateNonEmptyFields(value),
              ),
              DepartmentDropDownField(
                onSaved: (value) => department = value,
                validator: (value) =>
                    ValidatorService.validateNonEmptyFields(value),
              ),
              EmailField(
                controller: _emailController,
              ),
              RoundedPasswordField(
                onSaved: (value) {
                  password = value;
                },
                validator: (value) => ValidatorService.validatePassword(value),
              ),
              RoundedButton(
                text: "REGISTER",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    // save fields
                    _formKey.currentState!.save();
                    //navigate to appropriate
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return FutureBuilder(
                          // get  user and navigate to the right screen

                          future: UserController.registerUser(
                            email: "$firstName@2pwaves.com",
                            password: password,
                            department: department,
                            displayName: "$firstName $lastName",
                          ),
                          builder: (_, snapshot) {
                            Widget widget = const RegisterScreen();
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                CurrentUser user = UserController.currentUser;
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
                },
              ),
              SizedBox(height: size.height * 0.03),
              AccountSetting(
                isLoginPage: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginScreen();
                      },
                    ),
                  );
                },
              ),
              const SocialDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
