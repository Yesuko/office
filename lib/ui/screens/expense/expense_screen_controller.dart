import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/models/job.dart';
import 'package:provider/provider.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/job_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../logic/managers/expense_manager.dart';
import '../../../util.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/job_tile.dart';
import '../../widgets/messenger.dart';
import '../breakdown/breakdown_screen.dart';
import '../job/job_screen_controller.dart';

class ExpenseScreenController {
  static showBottomSheet(
    BuildContext context, {
    String blNumber = "",
    String title = "",
    String amount = "",
    int expIndex = 0,
    String state = "",
    int bottomSheetOption = 0,
  }) {
    final double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: height * 0.9),
        builder: (context) {
          final expenseProvider = context.read<ExpenseManager>();

          if (bottomSheetOption == BottomSheetOptions.info.index) {
            if (state == ExpenseState.unsettled.name) {
              return BottomSheetLayout.buildAuthorsLog(
                context: context,
                authors: expenseProvider.unsettledExpense[expIndex].authors,
                title: expenseProvider.unsettledExpense[expIndex].title,
              );
            } else {
              return BottomSheetLayout.buildAuthorsLog(
                context: context,
                authors: expenseProvider.settledExpense[expIndex].authors,
                title: expenseProvider.settledExpense[expIndex].title,
              );
            }
          } else if (bottomSheetOption ==
              BottomSheetOptions.showListOfJobs.index) {
            //get list of jobs that an expense can be added to
            List<Job> jobs = [];
            for (Job job in JobController.pendingJobs) {
              jobs.add(job);
            }
            for (Job job in JobController.deliveredJobs) {
              jobs.add(job);
            }

            return BottomSheetLayout.showListOfItems(
              context: context,
              title: "Add Expense To",
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
                      onTap: () =>
                          JobScreenController.navigateFromJobToBreakdownScreen(
                        context,
                        jobs[index].blNumber,
                        jobs[index].state,
                      ),
                    );
                  }),
            );
          } else {
            bool isNew = bottomSheetOption == BottomSheetOptions.add.index;
            return BottomSheetLayout.buildTitleField(
              header: isNew
                  ? "New "
                      "Expense"
                  : "Edit Expense",
              titleHintText: 'title',
              titleIcon: Icons.edit,
              initialTitle: title,
              titleOnChanged: (value) {
                title = value;
              },
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (bottomSheetOption == BottomSheetOptions.add.index) {
                  await expenseProvider.addExpense(
                    Expense.withDefaultDateAndBreakdown(
                      blNumber: blNumber,
                      title: title,
                      amount: amount,
                      authors: [
                        Author.withAttributes(
                          name: UserController.currentUser.displayName,
                          flag: AuthorFlags.from.name,
                        ),
                      ],
                    ),
                  );
                } else if (bottomSheetOption == BottomSheetOptions.edit.index) {
                  await expenseProvider.editExpenseTitle(blNumber, title);
                }
                navigator.pop();
              },
              buttonText: isNew ? 'Add Expense' : "Edit Expense",
              context: context,
            );
          }
        });
  }

  static showDeleteExpensePrompt(BuildContext context, String blNumber) {
    Messenger.showAlertDialog(
      exitAction: () {
        Navigator.pop(context);
      },
      proceedAction: () async {
        final navigator = Navigator.of(context);
        await ExpenseController.deleteExpense(
          blNumber: blNumber,
        );
        navigator.pop();
      },
      message: "Do you want to delete this expense?",
      exitLabel: "No",
      proceedLabel: "Yes",
      context: context,
    );
  }

  static navigateToBreakdownScreen(
    BuildContext context,
    String blNumber,
    String state,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreakDownScreen(
          blNumber: blNumber,
          expenseState: state,
        ),
      ),
    );
  }

  static showAuthorsLog(BuildContext context, int expIndex, String state) {
    showBottomSheet(
      context,
      expIndex: expIndex,
      state: state,
      bottomSheetOption: BottomSheetOptions.info.index,
    );
  }

  static showeEditExpenseTitleSheet(
    BuildContext context,
    String title,
    String blNumber,
  ) {
    showBottomSheet(
      context,
      title: title,
      blNumber: blNumber,
      bottomSheetOption: BottomSheetOptions.edit.index,
    );
  }
}
