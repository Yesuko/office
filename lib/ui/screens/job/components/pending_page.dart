import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/job_controller.dart';
import '../../../../logic/managers/job_manager.dart';

import '../../../widgets/popupmenuitem.dart';
import '../job_screen_controller.dart';
import './background.dart';

import '../../../../util.dart';
import '../../../widgets/focused_menu.dart';
import '../../../widgets/job_tile.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: kBottomPaddingOfTopBar,
        child: Consumer<JobManager>(
          builder: (_, jobs, __) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: jobs.pendingJobs.length,
                itemBuilder: (context, jobIndex) {
                  var job = jobs.pendingJobs[jobIndex];
                  return JobTile(
                    blNumber: job.blNumber,
                    description: job.description,
                    etaDate: job.etaDate,
                    jobStage: job.stage,
                    jobType: job.type,
                    onTap: () {
                      JobScreenController.navigateToJobDetailScreen(
                        context,
                        job.blNumber,
                        job.state,
                      );
                    },
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
                        title: 'Add Expense',
                        iconData: Icons.post_add_sharp,
                        position: Options.addExpense.index,
                        color: Colors.teal,
                      )
                    ],
                    focusedMenuItems: [
                      FocusedMenuItem(
                        title: const Text("Delete"),
                        trailingIcon: const Icon(
                          Icons.delete_forever_sharp,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          JobController.deleteJob(job.blNumber);
                        },
                      ),
                    ],
                    onPopMenuItemSelected: (value) {
                      if (value == Options.edit.index) {
                        JobScreenController.showEditJobInfoSheet(context, job);
                      } else if (value == Options.changeStatus.index) {
                        JobScreenController.showChangeJobStageSheet(
                            context, job);
                      } else {
                        JobScreenController.navigateFromJobToBreakdownScreen(
                          context,
                          job.blNumber,
                          job.state,
                        );
                      }
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}

enum Options { edit, changeStatus, addExpense }
