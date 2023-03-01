import 'dart:io';

import 'package:flutter/material.dart';

import '../../util.dart';
import '../../ui/widgets/messenger.dart';

class ConnAuthService {
  static Future<bool> tryConnection(BuildContext context) async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup(pingAddress);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      Messenger.showAlertDialog(
        exitAction: () {
          Navigator.pop(context);
        },
        proceedAction: () {
          Navigator.pop(context);
          tryConnection(context);
        },
        message: 'No internet access. Retry?',
        exitLabel: 'CANCEL',
        proceedLabel: 'RETRY',
        context: context,
      );
    }
    return isConnected;
  }
}
