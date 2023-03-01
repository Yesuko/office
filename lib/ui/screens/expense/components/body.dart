import 'package:flutter/material.dart';

import './settled_page.dart';
import './unsettled_page.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabBarView(children: [
      UnsettledPage(),
      SettledPage(),
    ]);
  }
}
