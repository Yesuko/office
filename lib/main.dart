import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'settings/config_setting.dart';
import 'settings/startapp_settings.dart';

void main() async {
  // initialize all firebase dependencies
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //setting up for using EMULATOR, LOCAL DEVICE OR INTERNET
  await ConfigurationSetting.config();

  // main point to start flutter app
  runApp(const StartAppSettings());
}

