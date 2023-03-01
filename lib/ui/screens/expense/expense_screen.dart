import 'package:flutter/material.dart';

import '../../../util.dart';

import '../../widgets/icon_container.dart';
import '../../widgets/search_screen.dart';
import './components/body.dart';

import '../../widgets/fab.dart';
import '../../widgets/top_bar.dart';
import 'expense_screen_controller.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TopBarWithTabs(
          title: kExpenseScreenTitle,
          actions: [
            IconContainer(
              iconData: Icons.search_sharp,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SearchScreen(title: kExpenseScreenTitle),
                    ));
              },
            )
          ],
          tabs: const [
            Tab(text: "Unsettled"),
            Tab(text: "Settled"),
          ],
        ),
        body: const Body(),
        floatingActionButton: Fab.buildWithIcon(
          icon: Icons.post_add_sharp,
          onPressed: () {
            ExpenseScreenController.showBottomSheet(
              context,
              bottomSheetOption: BottomSheetOptions.showListOfJobs.index,
            );
          },
        ),
      ),
    );
  }
}
