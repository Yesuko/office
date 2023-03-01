import 'package:flutter/material.dart';

import '../ui/controllers/base_controller.dart';
import '../ui/screens/home/home.dart';
import '../util.dart';
import 'provider_setting.dart';

class StartAppSettings extends StatelessWidget {
  const StartAppSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderSetting(
      child: Builder(builder: (context) {
        // initiate context to be accessed by all models in the app
        BaseController.initContext(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: kAppTitle,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: const TransitionScreen(transition: Transitions.expenseSkeleton),
          home: const Home(),
        );
      }),
    );
  }
}
