import 'package:flutter/material.dart';
import 'package:office/logic/models/breakdown_item.dart';
import 'package:office/logic/models/expense.dart' show Author;
import 'package:provider/provider.dart';

import '../../../controllers/breakdown_controller.dart';
import '../../../../logic/managers/user_manager.dart';
import '../../../../util.dart';
import '../../../widgets/messenger.dart';
import '../../../widgets/amount_tile.dart';
import '../../../widgets/breakdown_tile.dart';
import '../../../widgets/separator.dart';
import '../breakdown_screen_controller.dart';

class UnsettledBreakdownBody extends StatelessWidget {
  final bool isUserAllowedToEdit;

  const UnsettledBreakdownBody({
    Key? key,
    required this.isUserAllowedToEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    List<BreakdownItem> breakdown =
        BreakdownController.getBreakdown(listen: true);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //mainAxisSize: MainAxisSize.min,
          children: [
            AmountTile(
              amount: BreakdownController.totalAmountOfSettledBreakdown,
              color: kFontColorGreen,
              width: width * 0.5,
            ),
            AmountTile(
              amount: BreakdownController.totalAmountOfUnsettledBreakdown,
              color: kFontColorBlack,
              width: width * 0.5,
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (cont, index) => const SeperatorLine(),
              physics: const BouncingScrollPhysics(),
              itemCount: breakdown.length,
              itemBuilder: (context, itemIndex) {
                /// is editable makes sure to prevent settled breakdown items from being deleted.
                bool isEditable =
                    breakdown[itemIndex].state != BreakdownState.settled.name;

                if (isUserAllowedToEdit) {
                  return BreakdownTile(
                    enabled: isEditable,
                    title: breakdown[itemIndex].title,
                    amount: breakdown[itemIndex].amount,
                    state: breakdown[itemIndex].state,
                    settleTime: breakdown[itemIndex].settledTime,
                    showInfo: breakdown[itemIndex].modifier != null,
                    onTap: () {
                      //edit breakdown item
                      if (isEditable) {
                        BreakdownScreenController.showBottomSheet(
                          context,
                          bottomSheetOption: BottomSheetOptions.edit.index,
                          title: breakdown[itemIndex].title,
                          amount: double.parse(breakdown[itemIndex].amount),
                          itemIndex: itemIndex,
                        );
                      }
                    },
                    onDelete: (context) async {
                      // remove breakdown item
                      await BreakdownController.removeBreakdownItem(
                        breakdown[itemIndex].id,
                      );

                      Messenger.showSnackBar(
                        message: "${breakdown[itemIndex].title} deleted",
                        context: context,
                        seconds: 3,
                      );
                    },
                    onSettle: (context) async {
                      String fullName =
                          context.read<UserManager>().currentUser.displayName;

                      // settle breakdown item

                      await BreakdownController.settleBreakdownItem(
                        author: Author.withAttributes(
                          name: fullName,
                          flag: AuthorFlags.settled.name,
                        ),
                        id: breakdown[itemIndex].id,
                      );
                    },
                    onInfoPressed: () {
                      BreakdownScreenController.showModifiersLog(
                        context: context,
                        itemIndex: itemIndex,
                      );
                    },
                  );
                } else {
                  return BreakdownTile.settled(
                    title: breakdown[itemIndex].title,
                    amount: breakdown[itemIndex].amount.toString(),
                    state: breakdown[itemIndex].state,
                    settleTime: breakdown[itemIndex].settledTime ?? '',
                  );
                }
              }),
        ),
      ],
    );
  }
}
