import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class FireAuthService {
  static final _singleton = FireAuthService._internal();

  factory FireAuthService() {
    return _singleton;
  }

  FireAuthService._internal();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static FirebaseAuth get ref => _auth;

  // initial confiiguration to indicate where to point to to access data for app
  static Future<void> configureFirebaseAuth() async {
    String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
    int configPort = const int.fromEnvironment("AUTH_EMU_PORT");

    // Android emulator must be pointed to 10.0.2.2
    var defaultHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    var host = configHost.isNotEmpty ? configHost : defaultHost;
    var port = configPort != 0 ? configPort : 9099;

    await _auth.useAuthEmulator(host, port);
  }
}
