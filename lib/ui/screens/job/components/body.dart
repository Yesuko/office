import 'package:flutter/material.dart';

import './pending_page.dart';
import './completed_page.dart';
import './delivered_page.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarView(children: [
      PendingPage(),
      DeliveredPage(),
      CompletedPage(),
    ]);
  }
}
