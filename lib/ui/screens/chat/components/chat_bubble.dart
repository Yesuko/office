import 'package:flutter/material.dart';
import 'package:office/logic/models/chat.dart';

import '../../../controllers/chat_controller.dart';
import '../../../../util.dart';
import '../../../widgets/focused_menu.dart';
import '../../../widgets/header_text.dart';
import '../chat_screen_controller.dart';
import 'chat_bubble_attachment.dart';
import 'chat_text.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isFromCurrentUser,
    required this.author,
    required this.chatText,
    this.attachment,
    required this.indexofChatBubble,
    required this.chatTime,
  }) : super(key: key);

  // message can be a text or attachment
  final Attachment? attachment;
  final String chatText;

  // the variable determines position of avatar
  final bool isFromCurrentUser;

  // auther of mesage
  final Map<String, dynamic> author;

  // chat time
  final String chatTime;

  // chat index in the list of chat
  final int indexofChatBubble;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isFromCurrentUser ? _buildRightBubble() : _buildLeftBubble(),
    );
  }

  Widget _buildLeftBubble() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const UserAvartar("assets/images/IMG_1363.jpg"),
        ChatBubbleBody(
          authorName: author['displayName'] ?? "",
          chatText: chatText,
          isfromCurrentUser: isFromCurrentUser,
          chatTime: chatTime,
          indexOfChatBubble: indexofChatBubble,
        ),
        ReplyButton(chatText: chatText, index: indexofChatBubble),
      ],
    );
  }

  Widget _buildRightBubble() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ReplyButton(chatText: chatText, index: indexofChatBubble),
        ChatBubbleBody(
          authorName: author['displayName'],
          chatText: chatText,
          isfromCurrentUser: isFromCurrentUser,
          chatTime: chatTime,
          indexOfChatBubble: indexofChatBubble,
        ),
      ],
    );
  }
}

class ReplyButton extends StatelessWidget {
  final String chatText;
  final int index;
  const ReplyButton({Key? key, required this.chatText, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.reply_sharp),
      color: Colors.grey,
      onPressed: () {
        ChatScreenController.attachChatReference(chatText, index);
      },
    );
  }
}

class ChatBubbleBody extends StatelessWidget {
  final bool isfromCurrentUser;
  final int indexOfChatBubble;
  final String authorName;
  final String chatText;
  final String chatTime;
  final Attachment? attachment;
  const ChatBubbleBody(
      {Key? key,
      required this.isfromCurrentUser,
      required this.indexOfChatBubble,
      required this.authorName,
      required this.chatText,
      required this.chatTime,
      this.attachment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FocusedMenuHolder(
      menuItems: [
        if (isfromCurrentUser) ...[
          FocusedMenuItem(
            title: const Text("Delete"),
            trailingIcon: const Icon(
              Icons.delete_outline_sharp,
              color: Colors.redAccent,
            ),
            onPressed: () => ChatController.removeChat(indexOfChatBubble),
          ),
        ]
      ],
      menuWidth: size.width * 0.5,
      menuOffset: 14,
      onPressed: () {},
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:
              isfromCurrentUser ? kChatBubblePrimaryBg : kChatBubbleSecondaryBg,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !isfromCurrentUser,
              child: HeaderText(
                text: authorName,
                size: 14,
                color: kChatHeaderColor,
              ),
            ),
            if (attachment != null) ...[
              ChatBubbleAttachment(
                attachment: attachment ?? Attachment(),
              )
            ],
            ChatText(message: chatText),
            Row(
              children: [
                if (isfromCurrentUser) ...[
                  const ChatRead(),
                ],
                ChatTime(chatTime: chatTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvartar extends StatelessWidget {
  final String photoURL;
  const UserAvartar(this.photoURL, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage(photoURL),
      backgroundColor: kSecondaryColor,
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint("could not load user images");
      },
    );
  }
}

class ChatTime extends StatelessWidget {
  const ChatTime({Key? key, required this.chatTime}) : super(key: key);
  final String chatTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 4.0),
      child: Text(
        chatTime,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: kSecondaryColor,
          fontSize: 10,
        ),
      ),
    );
  }
}

class ChatRead extends StatelessWidget {
  const ChatRead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4.0, left: 4.0),
      child: Icon(
        Icons.done,
        color: kSecondaryColor,
        size: 14,
      ),
    );
  }
}
