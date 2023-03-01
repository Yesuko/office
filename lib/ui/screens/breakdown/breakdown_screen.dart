import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart' show Author;
import 'package:provider/provider.dart';

import '../../controllers/breakdown_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../controllers/user_controller.dart';
import '../../../logic/managers/expense_manager.dart';
import '../../../util.dart';
import '../../widgets/fab.dart';
import '../../widgets/header_text.dart';
import '../../widgets/popupmenuitem.dart';
import '../../widgets/return_button.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/popupmenubutton.dart';
import '../../widgets/transition_screen.dart';
import '../expense/expense_screen_controller.dart';
import 'breakdown_screen_controller.dart';
import 'components/settled_breakdown.dart';
import 'components/unsettled_breakdown.dart';

class BreakDownScreen extends StatefulWidget {
  final String blNumber;
  final String expenseState;

  const BreakDownScreen({
    Key? key,
    required this.blNumber,
    required this.expenseState,
  }) : super(key: key);

  @override
  State<BreakDownScreen> createState() => _BreakDownScreenState();
}

class _BreakDownScreenState extends State<BreakDownScreen> {
  late bool isUserExpenseCreator;
  late bool isUserEmployer;
  late bool isUserAllowedToEdit;
  late String expenseTitle;
  late dynamic loadbreakdown;
  late bool showFAB;

  @override
  initState() {
    super.initState();

    isUserExpenseCreator = ExpenseController.isUserExpenseCreator(
      widget.blNumber,
      widget.expenseState,
    );

    isUserAllowedToEdit = ExpenseController.isUserAllowedToEdit(
      widget.blNumber,
      widget.expenseState,
    );
    expenseTitle = ExpenseController.getExpense(
      widget.blNumber,
      widget.expenseState,
    ).title;

    isUserEmployer = ExpenseController.isUserEmployer;

    loadbreakdown = widget.expenseState == ExpenseState.settled.name
        ? BreakdownController.loadSettledBreakdown(widget.blNumber)
        : BreakdownController.loadUnsettledBreakdown(widget.blNumber);

    showFAB = (isUserEmployer || isUserExpenseCreator) &&
        widget.expenseState == ExpenseState.unsettled.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          titleWidget: Consumer<ExpenseManager>(
            builder: (_, data, __) {
              return HeaderText(text: expenseTitle);
            },
          ),
          centerTitle: true,
          leading: ReturnButton(onTap: () => Navigator.pop(context)),
          actions: [
            widget.expenseState == ExpenseState.unsettled.name
                ? PopUpMenuButtonLayout(
                    iconColor: kPrimaryColor,
                    iconSize: 24,
                    popMenuItems: [
                      if (isUserEmployer) ...{
                        PopupMenuItemLayout.build(
                          title: 'Settle all with Cash',
                          iconData: Icons.paid_outlined,
                          position: Options.settleAllWithCash.index,
                        ),
                        PopupMenuItemLayout.build(
                          title: 'Settle all with MoMo',
                          iconData: Icons.paid_outlined,
                          position: Options.settleAllWithMomo.index,
                        ),
                      },
                      if (isUserExpenseCreator) ...{
                        PopupMenuItemLayout.build(
                          title: 'Edit expense title',
                          iconData: Icons.title,
                          position: Options.edit.index,
                        ),
                      }
                    ],
                    onPopMenuItemSelected: (value) {
                      if (value == Options.settleAllWithCash.index) {
                        BreakdownController.settleBreakdown(
                            Author.withAttributes(
                          name: UserController.currentUser.displayName,
                          flag: AuthorFlags.settled.name,
                        ));
                      } else if (value == Options.settleAllWithMomo.index) {
                      } else if (value == Options.edit.index) {
                        // only unsettled expenses can have their title edited

                        ExpenseScreenController.showeEditExpenseTitleSheet(
                            context, expenseTitle, widget.blNumber);
                      }
                    },
                  )
                : const SizedBox.shrink(),
          ]),
      body: StreamBuilder(
          stream: loadbreakdown,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return widget.expenseState == ExpenseState.settled.name
                  // ignore: prefer_const_constructors
                  ? SettledBreakdownBody()
                  : UnsettledBreakdownBody(
                      isUserAllowedToEdit: isUserAllowedToEdit,
                    );
            } else {
              return const TransitionScreen(
                transition: Transitions.breakdownSkeleton,
              );
            }
          }),
      floatingActionButton: Visibility(
        visible: showFAB,
        child: Fab.buildExtended(
          label: "Add Breakdown Item",
          onPressed: () {
            ///itemIndex 0 is not neccessary, but provided to follow the parameter requirement of [_showModalBottomSheet]
            BreakdownScreenController.showBottomSheet(
              context,
              bottomSheetOption: BottomSheetOptions.add.index,
              itemIndex: 0,
            );
          },
        ),
      ),
    );
  }
}

enum Options { settleAllWithCash, settleAllWithMomo, edit, delete }
