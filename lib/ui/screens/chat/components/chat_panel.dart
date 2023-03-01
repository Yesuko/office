import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../logic/managers/chat_manager.dart';
import 'chat_attachment.dart';
import 'chat_input.dart';

class ChatPanel extends StatelessWidget {
  const ChatPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !(context.watch<ChatManager>().chatRef == null),
          child: const ChatAttachment(),
        ),
        const ChatInput(),
      ],
    );
  }
}
