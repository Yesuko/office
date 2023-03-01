import 'package:flutter/material.dart';
import 'package:office/logic/models/chat.dart';

import '../../../controllers/chat_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../../util.dart';
import '../../../widgets/icon_container.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({Key? key}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  late TextEditingController _controller;
  late FocusNode _focus;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 8.0,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kSecondaryColor),
            ),
            child: TextField(
              maxLines: 8,
              minLines: 1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter message here',
              ),
              controller: _controller,
              focusNode: _focus,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconContainer(
            iconData: Icons.send_sharp,
            paddingRight: 0,
            onTap: () {
              final String text = _controller.text.trim();

              if (text.isNotEmpty) {
                ChatController.addNewChat(Chat.withAttributes(
                  messageText: text,
                  sentBy: {
                    'photoURL': UserController.currentUser.photoURL,
                    'displayName': UserController.currentUser.displayName,
                  },
                  sentAt: DateTime.now(),
                  attachment: ChatController.getChatRef,
                ));
                _controller.text = "";
                _focus.unfocus();
                ChatController.updateChatRef(null);
              }
            },
          ),
        )
      ]),
    );
  }
}
