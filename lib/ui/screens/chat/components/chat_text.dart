import 'package:flutter/material.dart';

class ChatText extends StatelessWidget {
  const ChatText({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.5),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          message,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
