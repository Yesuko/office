import 'dart:core';

import 'package:office/databases/services/fireauth_service.dart';

import '../databases/services/fire_rdb_service.dart';
import '../databases/services/firestore_service.dart';

class ConfigurationSetting {
  static Future<void> config() async {
    //setting up for using EMULATOR, LOCAL DEVICE OR INTERNET
    if (const bool.fromEnvironment("USE_FIREBASE_EMU")) {
      await FireAuthService.configureFirebaseAuth();
      FireStoreService.configureFirebaseFirestore();
      FireRDBService.configureFirebaseRDB();
    }
  }
}
