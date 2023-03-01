import 'package:office/ui/controllers/base_controller.dart';
import 'package:office/logic/models/breakdown_item.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/managers/breakdown_manager.dart';
import 'package:office/logic/managers/expense_manager.dart';
import 'package:provider/provider.dart';

class BreakdownController extends BaseController {
  static final breakdownProvider =
      BaseController.context.read<BreakdownManager>();
  static final expenseProvider = BaseController.context.read<ExpenseManager>();

  /// [addBreakdownItem] : Adds brekdown item which posses the passed id
  static Future<void> addBreakdownItem({
    required BreakdownItem breakdownItem,
  }) async {
    /// adding breakdown item: first add item, first check if all the items are settled if yes we remove the author who settled the prev breakdown's info from the expense authors log , then we proceed to add new item.Also expense amount, and is breakdown property are updated

    if (breakdownProvider.isAllBreakdownItemsSettled &&
        breakdownProvider.breakdown.isNotEmpty) {
      await breakdownProvider.addBreakdownItem(breakdownItem);

      await expenseProvider.updateExpense(breakdownProvider.blNumber, {
        'isBreakdownSettled': false,
        'amount': breakdownProvider.totalAmountOfUnsettledBreakdown,
      });
      await expenseProvider.removeAuthor(breakdownProvider.blNumber);
    } else {
      await breakdownProvider.addBreakdownItem(breakdownItem);
      await expenseProvider.updateExpense(breakdownProvider.blNumber, {
        'amount': breakdownProvider.totalAmountOfUnsettledBreakdown,
      });
    }
  }

  static Future<void> editBreakdownItem({
    required String title,
    required double amount,
    required String breakdownItemId,
    Modifier? breakdownItemModifier,
  }) async {
    await breakdownProvider.editBreakdownItem(
      id: breakdownItemId,
      title: title,
      newAmount: amount.toStringAsFixed(2),
      modifier: breakdownItemModifier,
    );

    await expenseProvider.updateExpense(breakdownProvider.blNumber,
        {'amount': breakdownProvider.totalAmountOfUnsettledBreakdown});
  }

  ///[settleBreakdown] :Settles all breakdown items in currently accessed breakdown
  static Future<void> settleBreakdown(
    Author author,
  ) async {
    /// to settle an expense or settling a brekdown: first settle all breakdown items, then add author who settled expense to expense author's log.

    await breakdownProvider.settleBreakdown();

    await expenseProvider.updateExpense(breakdownProvider.blNumber, {
      'amount': '0.00',
      'amountSettled': breakdownProvider.totalAmountOfSettledBreakdown,
      'isBreakdownSettled': true,
    });
    await expenseProvider.addAuthor(breakdownProvider.blNumber, author);
  }

  /// [settleBreakdownItem] : Settles brekdown item which posses the passed id
  static Future<void> settleBreakdownItem({
    required Author author,
    required String id,
  }) async {
    /// to setlle a breakdown item: we settle the item then later check if the item is the last to be settled in the breakdown. if result is true, then we add author who settled the last item to expense. hence will be shown in the author's log as expense has been settled.

    await breakdownProvider.settleBreakdownItem(id);

    if (breakdownProvider.isAllBreakdownItemsSettled) {
      await expenseProvider.updateExpense(breakdownProvider.blNumber, {
        'amount': breakdownProvider.totalAmountOfUnsettledBreakdown,
        'isBreakdownSettled': true,
        'amountSettled': breakdownProvider.totalAmountOfSettledBreakdown,
      });
      await expenseProvider.addAuthor(breakdownProvider.blNumber, author);
    } else {
      await expenseProvider.updateExpense(breakdownProvider.blNumber, {
        'amount': breakdownProvider.totalAmountOfUnsettledBreakdown,
        'amountSettled': breakdownProvider.totalAmountOfSettledBreakdown,
      });
    }
  }

  static dynamic loadUnsettledBreakdown(String blNumber) {
    BaseController.context
        .read<BreakdownManager>()
        .loadUnsettledBreakdown(blNumber);
  }

  static dynamic loadSettledBreakdown(String blNumber) {
    BaseController.context
        .read<BreakdownManager>()
        .loadSettledBreakdown(blNumber);
  }

  static Future<void> removeBreakdown(String blNumber) async {
    await breakdownProvider.removeBreakdown(blNumber);
  }

  static Future<void> removeBreakdownItem(
    String id,
  ) async {
    await breakdownProvider.removeBreakdownItem(id);
  }

  static List<BreakdownItem> getBreakdown({bool listen = false}) {
    if (listen == true) {
      final breakdownProvider =
          BaseController.context.watch<BreakdownManager>();
      return breakdownProvider.breakdown;
    } else {
      final breakdownProvider = BaseController.context.read<BreakdownManager>();
      return breakdownProvider.breakdown;
    }
  }

  static String get totalAmountOfSettledBreakdown {
    return breakdownProvider.totalAmountOfSettledBreakdown;
  }

  static String get totalAmountOfUnsettledBreakdown {
    return breakdownProvider.totalAmountOfUnsettledBreakdown;
  }
}
