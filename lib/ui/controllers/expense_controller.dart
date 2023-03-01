import 'package:office/ui/controllers/base_controller.dart';
import 'package:office/ui/controllers/user_controller.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/managers/breakdown_manager.dart';
import 'package:office/logic/managers/expense_manager.dart';
import 'package:office/logic/managers/user_manager.dart';
import 'package:office/util.dart';
import 'package:provider/provider.dart';

class ExpenseController extends BaseController {
  static bool isUserExpenseCreator(String blNumber, String expenseState) {
    // get expense and check if creator of expense name(i.e first author of list of expense authors) maches name of current user
    Expense exp = getExpense(blNumber, expenseState);
    return UserController.currentUser.displayName == exp.authors.first.name;
  }

  static bool get isUserEmployer {
    return UserController.currentUser.role == KDBFields.employer.name;
  }

  static bool isUserAllowedToEdit(String blNumber, String expenseState) {
    /// other user don't have access to edit expcept the employer and the creator of the expense and its breakdown
    return isUserExpenseCreator(blNumber, expenseState) || isUserEmployer;
  }

  /// [setupExpense] : used when navigating to a brakdown screen, checks if associated expense is available else sets expense properties. Returns state of expense.
  static Future<String> setupExpense(
    String blNumber,
    String jobState,
  ) async {
    // blNumber is used to find corresponding expense
    // jobstae: a completed job state indicates the expense we looking for is settled else unsettled.
    final expenseProvider = BaseController.context.read<ExpenseManager>();
    late String state;
    bool foundexpense = false;

    // get exp with that matches blnumber
    if (jobState == JobState.completed.name) {
      for (var exp in expenseProvider.settledExpense) {
        if (exp.blNumber == blNumber) {
          state = exp.state;
          foundexpense = true;
          break;
        }
      }
    } else {
      for (var exp in expenseProvider.unsettledExpense) {
        if (exp.blNumber == blNumber) {
          state = exp.state;
          foundexpense = true;
          break;
        }
      }
      if (foundexpense == false) {
        /// this block is executed when no match is found for expense matching
        ///  blNumber. This means, expense has been deleted from the
        /// list of expenses or has not been created yet
        Expense expense = Expense.withDefaultDateAndBreakdown(
          blNumber: blNumber,
          title: blNumber,
          amount: "0.00",
          authors: [
            Author.withAttributes(
              name: BaseController.context
                  .read<UserManager>()
                  .currentUser
                  .displayName,
              flag: AuthorFlags.from.name,
            ),
          ],
        );

        state = expense.state;

        await expenseProvider.addExpense(expense);
      }
    }

    return state;
  }

  /// [deleteExpense] : Deletes expense that is associated with bl number
  static Future<void> deleteExpense({
    required String blNumber,
  }) async {
    /// to remove an expense: first remove expense, then remove breakdown associated with it

    final expenseProvider = BaseController.context.read<ExpenseManager>();
    final breakdownProvider = BaseController.context.read<BreakdownManager>();

    await expenseProvider.removeExpense(blNumber);
    await breakdownProvider.removeBreakdown(blNumber);
  }

  static Expense getExpense(String blNumber, expenseState) {
    return BaseController.context
        .read<ExpenseManager>()
        .getExp(blNumber, expenseState);
  }

  static List<Expense> get allExpense =>
      BaseController.context.read<ExpenseManager>().allExpenses;
}
