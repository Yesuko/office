import 'package:flutter/material.dart';
import 'package:office/ui/controllers/job_controller.dart';
import 'package:office/logic/models/job.dart';
import 'package:office/ui/screens/job/job_screen_controller.dart';
import 'package:office/ui/screens/job_detail/components/job_detail_body.dart';
import 'package:office/util.dart';
import 'package:office/ui/widgets/popupmenubutton.dart';
import 'package:office/ui/widgets/popupmenuitem.dart';
import 'package:office/ui/widgets/return_button.dart';
import 'package:office/ui/widgets/top_bar.dart';

class JobDetailScreen extends StatelessWidget {
  final String blNumber;
  final String state;

  const JobDetailScreen({
    Key? key,
    required this.blNumber,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Job job = JobController.getJob(blNumber, state);
    return Scaffold(
      appBar: TopBar(
        leading: ReturnButton(
          onTap: () => Navigator.pop(context),
        ),
        title: kJobDetailTitle,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopUpMenuButtonLayout(
              iconColor: kPrimaryColor,
              iconSize: 24,
              popMenuItems: [
                PopupMenuItemLayout.build(
                  title: 'Edit job info',
                  iconData: Icons.title_sharp,
                  position: Options.edit.index,
                ),
                PopupMenuItemLayout.build(
                  title: 'Change Stage',
                  iconData: Icons.trending_flat_sharp,
                  position: Options.changeStatus.index,
                ),
                PopupMenuItemLayout.build(
                  title: state == JobState.completed.name
                      ? 'View Expense'
                      : 'Add Expense',
                  iconData: Icons.post_add_sharp,
                  position: state == JobState.completed.name
                      ? Options.viewExpense.index
                      : Options.addExpense.index,
                  color: Colors.teal,
                ),
              ],
              onPopMenuItemSelected: (value) {
                if (value == Options.edit.index) {
                  JobScreenController.showEditJobInfoSheet(context, job);
                } else if (value == Options.changeStatus.index) {
                  JobScreenController.showChangeJobStageSheet(context, job);
                } else if (value == Options.viewExpense.index) {
                  JobScreenController.viewExpense(
                    context: context,
                    blNumber: job.blNumber,
                    expenseState: ExpenseState.settled.name,
                    jobState: job.state,
                  );
                } else {
                  JobScreenController.navigateFromJobToBreakdownScreen(
                    context,
                    job.blNumber,
                    job.state,
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: JobDetailBody(job: job),
    );
  }
}

enum Options { edit, changeStatus, addExpense, viewExpense }
