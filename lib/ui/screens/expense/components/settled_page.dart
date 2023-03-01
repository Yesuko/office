import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart';
import 'package:provider/provider.dart';

import '../expense_screen_controller.dart';
import './background.dart';
import '../../../../logic/managers/expense_manager.dart';

import '../../../../util.dart';
import '../../../widgets/expense_tile.dart';
import '../../../widgets/focused_menu.dart';

class SettledPage extends StatelessWidget {
  const SettledPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: kBottomPaddingOfTopBar,
        child: Consumer<ExpenseManager>(
          builder: (_, expenses, __) {
            final expense = expenses.settledExpense;
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: expense.length,
                itemBuilder: (context, index) {
                  Expense exp = expense[index];

                  return ExpenseTile.settled(
                    authors: exp.authors,
                    title: exp.title,
                    date: exp.date,
                    amount: exp.amountSettled,
                    state: exp.state,
                    onTap: () {
                      ExpenseScreenController.navigateToBreakdownScreen(
                        context,
                        exp.blNumber,
                        exp.state,
                      );
                    },
                    focusedMenuItems: [
                      FocusedMenuItem(
                          title: const Text("Info"),
                          trailingIcon: const Icon(Icons.info_outline),
                          onPressed: () {
                            ExpenseScreenController.showAuthorsLog(
                              context,
                              index,
                              exp.state,
                            );
                          }),
                      FocusedMenuItem(
                          title: const Text("Share expense"),
                          trailingIcon: const Icon(Icons.share_sharp),
                          onPressed: () {})
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
