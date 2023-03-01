import 'package:office/logic/managers/chat_manager.dart';
import 'package:office/logic/models/chat.dart';
import 'package:provider/provider.dart';

import 'base_controller.dart';

class ChatController extends BaseController {
  static final provider = BaseController.context.read<ChatManager>();
  static updateChatRef(Attachment? chatRef) {
    provider.chatRef = chatRef;
  }

  static Attachment? get getChatRef => provider.chatRef;

  static addNewChat(Chat chat) {
    provider.addNewChat(chat);
  }

  static removeChat(int index) {
    provider.removeChat(index);
  }

  static void loadChats() {
    provider.loadChats();
  }

  static List<Chat> get chats => provider.chats;
}
