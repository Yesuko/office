import 'package:flutter/material.dart';
import 'package:office/logic/models/chat.dart' show Attachment;
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/models/job.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../controllers/chat_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../controllers/job_controller.dart';
import '../../../util.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/expense_tile.dart';
import '../../widgets/job_tile.dart';

class ChatScreenController {
  static ItemScrollController? screenChatController;

  static Color assignAttachmentColor(String type) {
    if (type == ChatAttachments.job.name) {
      return kJobAttacment;
    } else if (type == ChatAttachments.expense.name) {
      return kExpenseAttachment;
    } else if (type == ChatAttachments.chatItem.name) {
      return kChatReference;
    } else {
      return kOtherAttachment;
    }
  }

  static jumpToChatRef(int index) {
    if (screenChatController != null) {
      screenChatController!.jumpTo(
        index: index,
      );
    } else {
      debugPrint('chat screen controller not assigned');
    }
  }

  static attachChatReference(String chatText, int index) {
    ChatController.updateChatRef(
      Attachment.withAttributes(title: chatText, description: "", metaData: {
        'type': ChatAttachments.chatItem.name,
        'state': 'chat_item',
        'index': index,
      }),
    );
  }

  static showBottomSheet(
    BuildContext context, {
    int bottomSheetOption = 0,
    int? index,
  }) {
    final double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: height * 0.9),
        builder: (context) {
          if (bottomSheetOption == BottomSheetOptions.showListOfJobs.index) {
            //get list of jobs
            List<Job> jobs = [];
            for (Job job in JobController.pendingJobs) {
              jobs.add(job);
            }
            for (Job job in JobController.deliveredJobs) {
              jobs.add(job);
            }

            for (Job job in JobController.completedJobs) {
              jobs.add(job);
            }

            return BottomSheetLayout.showListOfItems(
              context: context,
              title: 'Choose job: ',
              emptyChild: const Text("No Jobs added yet"),
              itemLength: jobs.length,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    return JobTile.withMinimalFunctionality(
                      blNumber: jobs[index].blNumber,
                      description: jobs[index].description,
                      etaDate: jobs[index].etaDate,
                      jobType: jobs[index].type,
                      jobStage: jobs[index].stage,
                      onTap: () {
                        ChatController.updateChatRef(
                          Attachment.withAttributes(
                              title: jobs[index].blNumber,
                              description: jobs[index].description,
                              metaData: {
                                'type': ChatAttachments.job.name,
                                'state': jobs[index].state,
                                'blNumber': jobs[index].blNumber,
                              }),
                        );
                        Navigator.pop(context);
                      },
                    );
                  }),
            );
          } else if (bottomSheetOption ==
              BottomSheetOptions.showListOfExpenses.index) {
            //get list of expenses
            List<Expense> expense = ExpenseController.allExpense;
            return BottomSheetLayout.showListOfItems(
              context: context,
              title: 'Choose expense: ',
              emptyChild: const Text("No Expenses added yet"),
              itemLength: expense.length,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: expense.length,
                  itemBuilder: (context, index) {
                    String amount =
                        (expense[index].state == ExpenseState.unsettled.name)
                            ? expense[index].amount
                            : expense[index].amountSettled;
                    return ExpenseTile.withMinimalFunctionality(
                        date: expense[index].date,
                        title: expense[index].title,
                        amount: amount,
                        state: expense[index].state,
                        authors: expense[index].authors,
                        onTap: () {
                          ChatController.updateChatRef(
                            Attachment.withAttributes(
                                title: expense[index].title,
                                description: amount,
                                metaData: {
                                  'type': ChatAttachments.expense.name,
                                  'state': expense[index].state,
                                  'blNumber': expense[index].blNumber,
                                }),
                          );
                          Navigator.pop(context);
                        });
                  }),
            );
          } else {
            return BottomSheetLayout.buildChatOptions(
                context: context,
                onPressed: () {
                  ChatController.removeChat(index!);
                  Navigator.pop(context);
                });
          }
        });
  }
}
