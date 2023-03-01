import 'package:flutter/material.dart';
import 'package:office/logic/models/breakdown_item.dart';

import '../../../controllers/breakdown_controller.dart';
import '../../../../util.dart';
import '../../../widgets/breakdown_tile.dart';
import '../../../widgets/amount_tile.dart';
import '../breakdown_screen_controller.dart';

class SettledBreakdownBody extends StatelessWidget {
  const SettledBreakdownBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BreakdownItem> breakdown = BreakdownController.getBreakdown();

    return Column(
      children: [
        AmountTile(amount: BreakdownController.totalAmountOfSettledBreakdown),
        Expanded(
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: breakdown.length,
              itemBuilder: (context, itemIndex) {
                return BreakdownTile.settled(
                  title: breakdown[itemIndex].title,
                  amount: breakdown[itemIndex].amount.toString(),
                  state: breakdown[itemIndex].state,
                  settleTime: breakdown[itemIndex].settledTime ?? '',
                  showInfo: breakdown[itemIndex].modifier != null,
                  onInfoPressed: () {
                    _showModifiersLog(
                      context: context,
                      itemIndex: itemIndex,
                    );
                  },
                );
              }),
        ),
      ],
    );
  }

  void _showModifiersLog({
    required BuildContext context,
    required int itemIndex,
  }) {
    BreakdownScreenController.showBottomSheet(
      context,
      itemIndex: itemIndex,
      bottomSheetOption: BottomSheetOptions.info.index,
    );
  }
}
