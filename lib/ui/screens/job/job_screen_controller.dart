import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/models/job.dart';
import 'package:provider/provider.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/job_controller.dart';
import '../../../logic/managers/job_manager.dart';
import '../../../databases/services/validator_service.dart';
import '../../../util.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/messenger.dart';
import '../../widgets/transition_screen.dart';
import '../breakdown/breakdown_screen.dart';
import '../expense/expense_screen_controller.dart';
import '../job_detail/job_detail_screen.dart';

class JobScreenController {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  static showBottomSheet(
    BuildContext context, {
    dynamic job = "",
    String blNumber = "",
    String description = "",
    String vesselName = "",
    String jobType = "transhipment",
    String jobState = "",
    String? etaDate = "",
    String? etdDate,
    int bottomSheetOption = 0,
  }) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        builder: (context) {
          bool isNew = bottomSheetOption == BottomSheetOptions.add.index;
          bool showChangeStageSheet =
              bottomSheetOption == BottomSheetOptions.changeStage.index;

          return Consumer<JobManager>(
            builder: (_, jobs, __) {
              if (showChangeStageSheet) {
                String newStage = "";
                return BottomSheetLayout.buildChangeStageSheet(
                  context: context,
                  blNumber: job.blNumber,
                  prevStage: job.stage,
                  currState: job.state,
                  onStageChanged: (value) {
                    newStage = value ?? "";
                  },
                  onButtonPressed: () async {
                    final navigator = Navigator.of(context);
                    if (newStage == DeliveredJobStages.invoiceSubmitted.name) {
                      /// submitted invoice implies all expenses have been settled
                      /// hence, all expense of given job index should be
                      /// moved to the settled expense page, thus if the
                      /// expense exists

                      // check if expense breakdown is settled
                      final expenseData = JobController.getExpenseDataOfJob(
                        job.blNumber,
                      );

                      if (expenseData.keys.first) {
                        // run this if data indicates that expense has been settled
                        await _showAlertForJobStateChange(
                          context: context,
                          job: job,
                          newStage: newStage,
                          expense: expenseData.values.first,
                        );
                      } else if (expenseData.values.first != null) {
                        // else run this block to settle exxpense
                        await _showAlertForExpenseStateChange(
                          context,
                          job.blNumber,
                          expenseData.values.first!.state,
                        );
                      }
                    } else {
                      await jobs.changeJobStage(
                        job: job,
                        newStage: newStage,
                      );
                      Messenger.showSnackBar(
                        message: "Job stage changed",
                        context: context,
                      );
                      navigator.pop();
                    }
                  },
                );
              } else {
                // block to handle editing or adding to Jobs
                return Form(
                  key: formKey,
                  child: BottomSheetLayout.buildJobForm(
                    context: context,
                    header: isNew ? "New Job" : "Edit Job",
                    buttonText: isNew ? "Add Job" : "Edit Job",
                    blNumber: blNumber,
                    description: description,
                    vesselName: vesselName,
                    jobType: jobType,
                    etaDate: etaDate ?? "",
                    etdDate: etdDate,
                    enableBl: isNew ? true : false,
                    blNumberChanged: (value) {
                      blNumber = value;
                    },
                    descChanged: (value) {
                      description = value;
                    },
                    vesselNameChanged: (value) {
                      vesselName = value;
                    },
                    jobTypeChanged: (value) {
                      jobType = value ?? "";
                    },
                    etaDateChanged: (value) {
                      etaDate = value;
                    },
                    etdDateChanged: (value) {
                      etdDate = value;
                    },
                    validator: (value) =>
                        ValidatorService.validateNonEmptyFields(value),
                    onButtonPressed: () async {
                      if (isNew) {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          await jobs.addJob(
                            Job.withAttributes(
                              blNumber: blNumber,
                              description: description,
                              vesselName: vesselName,
                              type: jobType,
                              etaDate: etaDate,
                              etdDate: etdDate,
                            ),
                          );
                        }
                      } else {
                        jobs.editJob(
                          blNumber: blNumber,
                          state: jobState,
                          description: description,
                          vesselName: vesselName,
                          type: jobType,
                          etaDate: etaDate,
                          etdDate: etdDate,
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                );
              }
            },
          );
        });
  }

  static _showAlertForJobStateChange({
    required BuildContext context,
    required String newStage,
    required Job job,
    required Expense? expense,
  }) {
    Messenger.showAlertDialog(
      exitAction: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      proceedAction: () async {
        final navigator = Navigator.of(context);

        await JobController.changeJobStateToCompleted(
          job: job,
          newStage: newStage,
          expense: expense,
        );

        // pop context twice deliberately  to remove
        // first pop is to remove alert dialog
        // second pop is to remove bottom sheet that called it

        navigator.pop();
        navigator.pop();

        Messenger.showSnackBar(
            message: "Job added to Completed Jobs", context: context);
      },
      message: "This stage will mark Job as Completed, and "
          "it's linked expense will also be marked as Settled.\n\n"
          "Do you wish to continue? ",
      exitLabel: "Abort",
      proceedLabel: "Continue",
      context: context,
    );
  }

  static _showAlertForExpenseStateChange(
    BuildContext context,
    String blNumber,
    String expenseState,
  ) {
    Messenger.showAlertDialog(
      exitAction: () {
        Navigator.pop(context);
      },
      proceedAction: () {
        ExpenseScreenController.navigateToBreakdownScreen(
          context,
          blNumber,
          expenseState,
        );
      },
      message: "There are items in this Job's expense that are not settled "
          "yet.\n\n Settle to continue.",
      exitLabel: "Abort",
      proceedLabel: "Go to Expense",
      context: context,
    );
  }

  static showDeleteJobPrompt({
    required BuildContext context,
    required String blNumber,
  }) {
    Messenger.showAlertDialog(
      exitAction: () {
        Navigator.pop(context);
      },
      proceedAction: () async {
        final navigator = Navigator.of(context);

        await JobController.deleteJob(
          blNumber,
        );

        navigator.pop();
      },
      message: "Do you want to delete this job?",
      exitLabel: "No",
      proceedLabel: "Yes",
      context: context,
    );
  }

  static showEditJobInfoSheet(BuildContext context, Job job) {
    showBottomSheet(
      context,
      bottomSheetOption: BottomSheetOptions.edit.index,
      blNumber: job.blNumber,
      description: job.description,
      vesselName: job.vesselName,
      jobType: job.type,
      jobState: job.state,
      etaDate: job.etaDate,
      etdDate: job.etdDate,
    );
  }

  static showChangeJobStageSheet(BuildContext context, Job job) {
    showBottomSheet(
      context,
      job: job,
      bottomSheetOption: BottomSheetOptions.changeStage.index,
    );
  }

  static markAsPending(BuildContext context, Job job) {
    Messenger.showAlertDialog(
      exitAction: () {
        Navigator.pop(context);
      },
      proceedAction: () async {
        final navigator = Navigator.of(context);
        //update job state to pending
        await JobController.changeState(job, JobState.pending.name);

        navigator.pop();
      },
      message: "Do you want to mark this job as pending?",
      exitLabel: "No",
      proceedLabel: "Yes",
      context: context,
    );
  }

  static void navigateToJobDetailScreen(
    BuildContext context,
    String blNumber,
    String state,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailScreen(
          blNumber: blNumber,
          state: state,
        ),
      ),
    );
  }

  static navigateFromJobToBreakdownScreen(
      BuildContext context, String blNumber, String jobState) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder(
          future: ExpenseController.setupExpense(blNumber, jobState),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return BreakDownScreen(
                blNumber: blNumber,
                expenseState: snapshot.data as String,
              );
            } else {
              return const TransitionScreen(
                transition: Transitions.breakdownSkeleton,
              );
            }
          }),
        ),
      ),
    );
  }

  static viewExpense(
      {required BuildContext context,
      required String blNumber,
      required String expenseState,
      required String jobState}) {
    try {
      ExpenseController.getExpense(blNumber, expenseState);
      navigateFromJobToBreakdownScreen(context, blNumber, jobState);
    } catch (e) {
      Messenger.showSnackBar(
          message: "This job has no expense", context: context);
    }
  }
}
