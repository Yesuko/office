import 'package:flutter/material.dart';

import '../../../util.dart';
import '../../widgets/popupmenubutton.dart';
import '../../widgets/popupmenuitem.dart';
import '../../widgets/top_bar.dart';

import 'chat_screen_controller.dart';
import 'components/chat_body.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: kChatScreenTitle,
        centerTitle: false,
        actions: [
          PopUpMenuButtonLayout(
            iconColor: kPrimaryColor,
            iconData: Icons.attachment_sharp,
            iconSize: 24,
            popMenuItems: [
              PopupMenuItemLayout.build(
                title: 'Job',
                iconData: Icons.work_outline_sharp,
                position: Options.job.index,
              ),
              PopupMenuItemLayout.build(
                title: 'Expense',
                iconData: Icons.show_chart_sharp,
                position: Options.expense.index,
              ),
              PopupMenuItemLayout.build(
                title: 'Other',
                iconData: Icons.file_upload_sharp,
                position: Options.others.index,
              ),
            ],
            onPopMenuItemSelected: (value) {
              if (value == Options.job.index) {
                ChatScreenController.showBottomSheet(
                  context,
                  bottomSheetOption: BottomSheetOptions.showListOfJobs.index,
                );
              } else if (value == Options.expense.index) {
                ChatScreenController.showBottomSheet(
                  context,
                  bottomSheetOption:
                      BottomSheetOptions.showListOfExpenses.index,
                );
              }
            },
          )
        ],
      ),
      body: const ChatBody(),
    );
  }
}

enum Options { job, expense, others }
