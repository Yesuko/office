import 'package:flutter/material.dart';

import '../../../controllers/chat_controller.dart';
import '../../../../util.dart';
import '../../../widgets/icon_container.dart';
import '../chat_screen_controller.dart';

class ChatAttachment extends StatelessWidget {
  const ChatAttachment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = ChatController.getChatRef;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Row(
        children: [
          Icon(
            Icons.attach_file_sharp,
            size: 18,
            color: ChatScreenController.assignAttachmentColor(
                content!.metaData!['type']),
          ),
          Expanded(
            child: ListTile(
              tileColor: kPrimaryLightColor,
              title: Text(content.title),
              subtitle:
                  content.description == "" ? null : Text(content.description),
              dense: true,
              trailing: IconContainer(
                iconData: Icons.close,
                size: 18,
                color: kSecondaryColor,
                paddingRight: 0,
                paddingLeft: 0,
                onTap: () => ChatController.updateChatRef(null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
