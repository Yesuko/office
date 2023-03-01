import 'package:flutter/material.dart';
import 'package:office/logic/models/job.dart';
import 'package:provider/provider.dart';

import '../../../widgets/popupmenuitem.dart';
import '../job_screen_controller.dart';
import './background.dart';
import '../../../../logic/managers/job_manager.dart';
import '../../../../util.dart';
import '../../../widgets/focused_menu.dart';
import '../../../widgets/job_tile.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: kBottomPaddingOfTopBar,
        child: Consumer<JobManager>(
          builder: (_, jobs, __) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: jobs.completedJobs.length,
                itemBuilder: (context, jobIndex) {
                  //get actual job index from list of jobs
                  Job job = jobs.completedJobs[jobIndex];

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
                        title: 'View Expense',
                        iconData: Icons.post_add_sharp,
                        position: Options.view.index,
                        color: Colors.teal,
                      )
                    ],
                    onPopMenuItemSelected: (value) {
                      if (value == Options.view.index) {
                        JobScreenController.viewExpense(
                          context: context,
                          blNumber: job.blNumber,
                          expenseState: ExpenseState.settled.name,
                          jobState: job.state,
                        );
                      }
                    },
                    focusedMenuItems: [
                      FocusedMenuItem(
                          title: const Text("share"),
                          trailingIcon: const Icon(
                            Icons.share_sharp,
                          ),
                          onPressed: () {}),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}

enum Options { view }
