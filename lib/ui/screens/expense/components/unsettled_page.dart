import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart';
import 'package:provider/provider.dart';

import '../../../controllers/expense_controller.dart';
import '../../../widgets/popupmenuitem.dart';
import '../expense_screen_controller.dart';
import './background.dart';

import '../../../../logic/managers/expense_manager.dart';

import '../../../../util.dart';
import '../../../widgets/amount_tile.dart';
import '../../../widgets/expense_tile.dart';
import '../../../widgets/focused_menu.dart';

class UnsettledPage extends StatelessWidget {
  const UnsettledPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: kBottomPaddingOfTopBar,
        child: Consumer<ExpenseManager>(builder: (_, expenses, __) {
          return Column(
            children: [
              AmountTile(
                amount: expenses.totalAmountOfUnsettledExpenses,
                color: kFontColorRed,
              ),
              Expanded(
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: expenses.unsettledExpense.length,
                    itemBuilder: (context, index) {
                      // get actual expense index
                      Expense exp = expenses.unsettledExpense[index];

                      return ExpenseTile(
                        authors: exp.authors,
                        title: exp.title,
                        date: exp.date,
                        amount: exp.amount,
                        state: exp.state,
                        onTap: () {
                          ExpenseScreenController.navigateToBreakdownScreen(
                            context,
                            exp.blNumber,
                            exp.state,
                          );
                        },
                        popMenuItems: [
                          if (ExpenseController.isUserExpenseCreator(
                            exp.blNumber,
                            exp.state,
                          )) ...[
                            PopupMenuItemLayout.build(
                              title: 'Edit expense title',
                              iconData: Icons.title,
                              position: Options.edit.index,
                            ),
                            PopupMenuItemLayout.build(
                              title: 'Delete expense',
                              iconData: Icons.delete_forever_rounded,
                              position: Options.delete.index,
                              color: Colors.redAccent,
                            )
                          ] else ...[
                            PopupMenuItemLayout.build(
                              title: "View breakdown",
                              iconData: Icons.description,
                              position: Options.view.index,
                            ),
                          ]
                        ],
                        onPopMenuItemSelected: (value) {
                          if (value == Options.edit.index) {
                            ExpenseScreenController.showeEditExpenseTitleSheet(
                                context, exp.title, exp.blNumber);
                          } else if (value == Options.delete.index) {
                            ExpenseScreenController.showDeleteExpensePrompt(
                              context,
                              exp.blNumber,
                            );
                          } else {
                            ExpenseScreenController.navigateToBreakdownScreen(
                              context,
                              exp.blNumber,
                              exp.state,
                            );
                          }
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
                            },
                          ),
                          FocusedMenuItem(
                            title: const Text("Share Expense"),
                            trailingIcon: const Icon(Icons.share_sharp),
                            onPressed: () {},
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}

enum Options { settleWithCash, settleWithMoMo, delete, edit, view }
