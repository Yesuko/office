class Chat {
  final String? id;
  final String messageText;
  final DateTime sentAt;
  final Map<String, dynamic> sentBy;

  final Attachment? attachment;

  Chat.withAttributes({
    required this.messageText,
    required this.sentAt,
    required this.sentBy,
    this.id,
    this.attachment,
  });

  static Chat fromDB(Map data) {
    return _chatObject(data);
  }

  static Chat _chatObject(Map data) {
    var att = data['attachment'];
    return att != null
        ? Chat.withAttributes(
            id: data['id'],
            messageText: data['messageText'],
            sentAt: data['sentAt'],
            sentBy: data['sentBy'],
            attachment: Attachment.fromDB(data['attachment']),
          )
        : Chat.withAttributes(
            id: data['id'],
            messageText: data['messageText'],
            sentAt: data['sentAt'],
            sentBy: data['sentBy']);
  }

  static Map<String, dynamic> addToDB(Chat chat) {
    var att = chat.attachment;
    return att != null
        ? {
            'messageText': chat.messageText,
            'sentAt': chat.sentAt,
            'sentBy': chat.sentBy,
            'attachment': Attachment.addToDB(att),
          }
        : {
            'messageText': chat.messageText,
            'sentAt': chat.sentAt,
            'sentBy': chat.sentBy,
          };
  }
}

class Attachment {
  final String title;
  final String description;
  final Map<String, dynamic>? metaData;

  Attachment()
      : title = "",
        description = "",
        metaData = null;

  Attachment.withAttributes({
    required this.title,
    required this.description,
    this.metaData,
  });

  static Attachment fromDB(Map data) {
    return _attachmentObject(data);
  }

  static Attachment _attachmentObject(Map data) {
    var md = data['metaData'];

    return md != null
        ? Attachment.withAttributes(
            title: data['title'],
            description: data['description'],
            metaData: md,
          )
        : Attachment.withAttributes(
            title: data['title'],
            description: data['description'],
          );
  }

  static Map<String, dynamic> addToDB(Attachment attachment) {
    var md = attachment.metaData;
    return md != null
        ? {
            'title': attachment.title,
            'description': attachment.description,
            'metaData': md,
          }
        : {
            'title': attachment.title,
            'description': attachment.description,
          };
  }
}
