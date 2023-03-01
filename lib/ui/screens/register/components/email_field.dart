import 'package:flutter/material.dart';

import '../../../widgets/rounded_input_field.dart';

class EmailField extends StatefulWidget {
  const EmailField({Key? key, required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedInputField(
      hintText: 'Email',
      icon: Icons.email_sharp,
      controller: widget.controller,
      enabled: false,
    );
  }
}
