import 'package:flutter/material.dart';

import '../../../util.dart';
import '../../widgets/top_bar.dart';
import 'components/account_body.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopBar(
        title: kAccountScreenTitle,
      ),
      body: AccountBody(),
    );
  }
}
