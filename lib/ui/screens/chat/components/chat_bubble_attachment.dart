import 'package:flutter/material.dart';
import 'package:office/logic/models/chat.dart';

import '../../../../util.dart';
import '../../expense/expense_screen_controller.dart';
import '../../job/job_screen_controller.dart';
import '../chat_screen_controller.dart';

class ChatBubbleAttachment extends StatelessWidget {
  const ChatBubbleAttachment({
    Key? key,
    required this.attachment,
  }) : super(key: key);
  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        var metaData = attachment.metaData;

        if (metaData != null) {
          switch (metaData['state']) {
            case 'unsettled':
              ExpenseScreenController.navigateToBreakdownScreen(
                context,
                metaData['blNumber'],
                ExpenseState.unsettled.name,
              );
              break;
            case 'settled':
              ExpenseScreenController.navigateToBreakdownScreen(
                context,
                metaData['blNumber'],
                ExpenseState.settled.name,
              );
              break;
            case 'pending':
              JobScreenController.navigateToJobDetailScreen(
                context,
                metaData['blNumber'],
                JobState.pending.name,
              );
              break;
            case 'delivered':
              JobScreenController.navigateToJobDetailScreen(
                context,
                metaData['blNumber'],
                JobState.delivered.name,
              );
              break;
            case 'completed':
              JobScreenController.navigateToJobDetailScreen(
                context,
                metaData['blNumber'],
                JobState.completed.name,
              );

              break;
            default:
              ChatScreenController.jumpToChatRef(metaData['index']);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 2, bottom: 4, top: 1),
        constraints: BoxConstraints(maxWidth: size.width * 0.5),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.attach_file_sharp,
              size: 18,
              color: ChatScreenController.assignAttachmentColor(
                  attachment.metaData!['type']),
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  attachment.title,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: attachment.description == ""
                    ? null
                    : Text(
                        attachment.description,
                        overflow: TextOverflow.ellipsis,
                      ),
                dense: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
