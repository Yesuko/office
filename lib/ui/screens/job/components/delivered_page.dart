import 'package:flutter/material.dart';
import 'package:office/logic/models/job.dart';
import 'package:provider/provider.dart';

import '../../../../logic/managers/job_manager.dart';

import '../../../widgets/popupmenuitem.dart';
import '../job_screen_controller.dart';
import './background.dart';

import '../../../../util.dart';

import '../../../widgets/focused_menu.dart';
import '../../../widgets/job_tile.dart';

class DeliveredPage extends StatelessWidget {
  const DeliveredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: kBottomPaddingOfTopBar,
        child: Consumer<JobManager>(
          builder: (_, jobs, __) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: jobs.deliveredJobs.length,
                itemBuilder: (context, jobIndex) {
                  //get actual job index from list of jobs
                  Job job = jobs.deliveredJobs[jobIndex];

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
                          title: const Text("Mark as Pending"),
                          trailingIcon: const Icon(
                            Icons.done_sharp,
                          ),
                          onPressed: () {
                            // mark state as pending
                            JobScreenController.markAsPending(context, job);
                          }),
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
