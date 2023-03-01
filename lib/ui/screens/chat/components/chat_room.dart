import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/logic/managers/chat_manager.dart';
import 'package:office/ui/controllers/chat_controller.dart';
import 'package:office/ui/screens/chat/chat_screen_controller.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../controllers/user_controller.dart';
import 'chat_bubble.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ItemScrollController _itemScrollController;
  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();

    // assign controller to be accessible to other widgets
    ChatScreenController.screenChatController = _itemScrollController;

    ChatController.loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatManager>(
      builder: (_, manager, __) => ScrollablePositionedList.builder(
        key: widget.key,
        physics: const BouncingScrollPhysics(),
        itemScrollController: _itemScrollController,
        itemCount: manager.chats.length,
        itemBuilder: (BuildContext context, int index) {
          return ChatBubble(
            indexofChatBubble: index,
            attachment: manager.chats[index].attachment,
            author: manager.chats[index].sentBy,
            isFromCurrentUser: manager.chats[index].sentBy['displayName'] ==
                    UserController.currentUser.displayName
                ? true
                : false,
            chatText: manager.chats[index].messageText,
            chatTime: DateFormat('hh:mm').format(manager.chats[index].sentAt),
          );
        },
      ),
    );
  }
}
