import 'package:flutter/material.dart';
import 'package:office/logic/models/breakdown_item.dart';
import 'package:office/logic/models/expense.dart' show Author;

import '../../controllers/breakdown_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../util.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/messenger.dart';

class BreakdownScreenController {
  static showBottomSheet(
    BuildContext context, {
    required int bottomSheetOption,
    required int itemIndex,
    String title = "",
    double amount = 0,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        /// initialise  [breakdownProvider] this to gain access functions in the the breakdown model and also b[breakdownItem] contains the particular item being accessed.

        late BreakdownItem breakdownItem;
        final breakdown = BreakdownController.getBreakdown();
        if (breakdown.isNotEmpty) {
          breakdownItem = breakdown[itemIndex];
        }

        if (bottomSheetOption == BottomSheetOptions.info.index) {
          /// for cases where the bottom sheet is called to show the log of moderator on a breakdown item
          return BottomSheetLayout.buildModifiersLog(
            context: context,
            modifier: breakdownItem.modifier!,
            title: breakdownItem.title,
          );
        } else {
          /// both add and edit use the same layout for bottom sheet isNewItem checks if user wants to edit or add.
          /// with edit inital title and amount will null be null, but in the case of add, the initial title will be a empty string and initial amount will be 0.0.
          bool isNewItem = bottomSheetOption == BottomSheetOptions.add.index;

          // initAmount will be needed for adding to modifier of breadown item
          String initAmount = amount.toStringAsFixed(2);

          return BottomSheetLayout.buildTitleAndAmountField(
            context: context,
            header: isNewItem ? "New Breakdown Item" : "Edit Breakdown Item",
            titleHintText: 'item',
            titleIcon: Icons.edit,
            initialTitle: title,
            initialAmount: amount.toStringAsFixed(2),
            titleOnChanged: (value) {
              title = value;
            },
            amountHintText: 'amount',
            amountIcon: Icons.money,
            amountOnChanged: (value) {
              try {
                amount = double.parse(value);
              } on FormatException catch (_) {
                value = "0.00";
                amount = double.parse(value);
              }
            },

            // on botton press actions
            onPressed: () async {
              final navigator = Navigator.of(context);
              if (bottomSheetOption == BottomSheetOptions.add.index) {
                await BreakdownController.addBreakdownItem(
                  breakdownItem: BreakdownItem.withAttributes(
                    title: title,
                    amount: amount.toStringAsFixed(2),
                  ),
                );
              } else {
                /// this runs when obviously the bottom sheet option is not to add but to edit.

                bool addNodifier = (ExpenseController.isUserEmployer == true) &&
                    (initAmount != amount.toStringAsFixed(2));

                await BreakdownController.editBreakdownItem(
                  title: title,
                  amount: amount,
                  breakdownItemId: breakdownItem.id,
                  breakdownItemModifier: addNodifier
                      ? Modifier.withAttributes(
                          name: UserController.currentUser.displayName,
                          oldValue: initAmount,
                          newValue: amount.toStringAsFixed(2),
                        )
                      : null,
                );
              }

              navigator.pop();
            },
            buttonText: isNewItem ? 'Add item' : "Edit Item",
          );
        }
      },
    );
  }

  static showModifiersLog({
    required BuildContext context,
    required int itemIndex,
  }) {
    showBottomSheet(
      context,
      itemIndex: itemIndex,
      bottomSheetOption: BottomSheetOptions.info.index,
    );
  }

  static settleBreakDown(BuildContext context, Author author) {
    Messenger.showAlertDialog(
      exitAction: () {
        Navigator.pop(context);
      },
      proceedAction: () async {
        final navigator = Navigator.of(context);

        await BreakdownController.settleBreakdown(author);
        navigator.pop();
      },
      message: "Do you want to settle all items?",
      exitLabel: "No",
      proceedLabel: "Yes",
      context: context,
    );
  }
}
