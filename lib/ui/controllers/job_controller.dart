import 'package:office/ui/controllers/base_controller.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/models/job.dart';
import 'package:office/logic/managers/breakdown_manager.dart';
import 'package:office/logic/managers/expense_manager.dart';
import 'package:office/logic/managers/job_manager.dart';
import 'package:provider/provider.dart';

class JobController extends BaseController {
  /// [deleteJob] :Removes job, expense and breadown associated with bl number.
  static Future<void> deleteJob(
    String blNumber,
  ) async {
    /// to delete a job: first we delete expense(unsettled, since a settled expense can not be deleted) and breakdown associated with job blNumber if it exists, before job item is also deleted. Also when an expense is created a breakdown item is also created at once, hence in the condition for removal of the expense will automatically apply to the breakdown

    final jobProvider = BaseController.context.read<JobManager>();
    final expensePrivider = BaseController.context.read<ExpenseManager>();
    final breakdownProvider = BaseController.context.read<BreakdownManager>();

    for (Expense exp in expensePrivider.unsettledExpense) {
      if (exp.blNumber == blNumber) {
        await expensePrivider.removeExpense(blNumber);
        await breakdownProvider.removeBreakdown(blNumber);
        break;
      }
    }

    await jobProvider.removeJob(blNumber);
  }

  static Future<void> changeState(Job job, String newState) async {
    await BaseController.context
        .read<JobManager>()
        .changeState(job: job, newState: newState);
  }

  ///[changeJobStateToCompleted] : called when job passes all conditions to warrants a job's state to changed to completed.
  static Future<void> changeJobStateToCompleted({
    required Job job,
    required String newStage,
    required Expense? expense,
  }) async {
    final jobProvider = BaseController.context.read<JobManager>();
    final expenseProvider = BaseController.context.read<ExpenseManager>();
    final breakdownProvider = BaseController.context.read<BreakdownManager>();
    bool hasExpense = !(expense == null);

    if (hasExpense) {
      await expenseProvider.moveToSettledExpenses(expense);
      await breakdownProvider.moveToSettledBreakdown(expense.blNumber);
    }

    await jobProvider.changeJobStage(
      job: job,
      newStage: newStage,
    );
  }

  ///[getExpenseDataOfJob] : Returns a key, value of bool to denote if expense is settled and expense data respectively. Expense data may be null if the job has no expense.
  static Map<bool, Expense?> getExpenseDataOfJob(
    String blNumber,
  ) {
    final expenseProvider = BaseController.context.read<ExpenseManager>();

    for (var exp in expenseProvider.unsettledExpense) {
      if (exp.blNumber == blNumber) {
        if (exp.isBreakdownSettled) {
          return {true: exp};
        } else {
          return {false: exp};
        }
      }
    }

    return {true: null};
  }

  static Job getJob(String blNumber, String jobState) {
    return BaseController.context
        .watch<JobManager>()
        .getJobs(jobState)
        .firstWhere((job) => job.blNumber == blNumber);
  }

  static List<Job> get pendingJobs =>
      BaseController.context.read<JobManager>().pendingJobs;

  static List<Job> get deliveredJobs =>
      BaseController.context.read<JobManager>().deliveredJobs;

  static List<Job> get completedJobs =>
      BaseController.context.read<JobManager>().completedJobs;
}
