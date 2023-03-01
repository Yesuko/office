import 'dart:async';

import 'package:flutter/material.dart';
import 'package:office/logic/models/chat.dart';
import 'package:office/databases/services/firestore_service.dart';

class ChatManager extends ChangeNotifier {
  Attachment? _chatRef;
  List<Chat> _chats = [];
  late StreamSubscription _chatSub;

  Future<void> tidyUp() async {
    await _chatSub.cancel();
    chatRef = null;

    notifyListeners();
  }

  void loadChats() {
    _chatSub = FireStoreService.fetchMessages().listen((event) {
      List<Chat> chat = [];
      for (var element in event.docs) {
        var data = element.data();
        //add id to data
        data.putIfAbsent('id', () => element.id);

        // convert from firestore timestamp to flutter datetime
        data.update('sentAt', (timestamp) => timestamp.toDate());

        chat.add(Chat.fromDB(data));
      }

      _chats = chat;

      notifyListeners();
    });
  }

  void addNewChat(Chat chat) {
    FireStoreService.saveMessage(Chat.addToDB(chat));
  }

  void removeChat(int index) {
    String? messageId = _chats.elementAt(index).id;

    if (messageId != null) {
      FireStoreService.deleteMessage(messageId);
    }
  }

  List<Chat> get chats => _chats;

  set chatRef(Attachment? chatRef) {
    _chatRef = chatRef;
    notifyListeners();
  }

  Attachment? get chatRef => _chatRef;
}
