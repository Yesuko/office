import 'package:flutter/material.dart';

import '../../util.dart';

class AccountSetting extends StatelessWidget {
  final bool isLoginPage;
  final Function press;

  const AccountSetting({this.isLoginPage = true, required this.press, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLoginPage ? "Not Registered ? " : "",
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: () => press(),
          child: Text(
            isLoginPage ? "Register" : "I have already Registered",
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
