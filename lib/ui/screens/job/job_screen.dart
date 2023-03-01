import 'package:flutter/material.dart';

import '../../widgets/icon_container.dart';
import '../../widgets/search_screen.dart';
import './components/body.dart';

import '../../../util.dart';
import '../../widgets/fab.dart';

import '../../widgets/top_bar.dart';
import 'job_screen_controller.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({Key? key}) : super(key: key);
  //static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TopBarWithTabs(
          title: kJobScreenTitle,
          actions: [
            IconContainer(
              iconData: Icons.search_sharp,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SearchScreen(
                        title: kJobScreenTitle,
                      ),
                    ));
              },
            )
          ],
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Delivered"),
            Tab(text: "Completed"),
          ],
        ),
        body: const Body(),
        floatingActionButton: Fab.buildWithIcon(
          icon: Icons.add_sharp,
          onPressed: () {
            JobScreenController.showBottomSheet(context);
          },
        ),
      ),
    );
  }
}
