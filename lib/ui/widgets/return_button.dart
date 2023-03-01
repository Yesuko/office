import 'package:flutter/material.dart';

import '../../util.dart';

class ReturnButton extends StatelessWidget {
  final Function() onTap;

  const ReturnButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(
        Icons.arrow_back_sharp,
        color: kPrimaryColor,
        size: 24,
      ),
    );
  }
}
