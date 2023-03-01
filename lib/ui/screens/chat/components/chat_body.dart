import 'package:flutter/material.dart';

import 'chat_panel.dart';
import 'chat_room.dart';

class ChatBody extends StatelessWidget {
  const ChatBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(child: ChatRoom()),
          ChatPanel(),
        ]);
  }
}
