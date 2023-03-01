import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/logic/models/attendance.dart';
import 'package:office/ui/controllers/attendance_controller.dart';
import 'package:office/ui/widgets/messenger.dart';

class AttendanceScreenController {
  static Future<void> _setAttendanace({
    required BuildContext context,
    required bool markAsArrival,
  }) async {
    if (markAsArrival == false) {
      await AttendanceController.markDeparture();
      Messenger.showSnackBar(context: context, message: "Signed Out");
    } else {
      await AttendanceController.markArrival();
      Messenger.showSnackBar(context: context, message: "Signed In");
    }
  }

  static Future<void> markAttendance(
      Attendance attendance, BuildContext context) async {
    if (attendance.isSignIn) {
      if (attendance.departure == null) {
        await _setAttendanace(context: context, markAsArrival: false);
      } else {
        Messenger.showAlertDialog(
          context: context,
          exitAction: () {
            Navigator.pop(context);
          },
          proceedAction: () async {
            final navigator = Navigator.of(context);
            await _setAttendanace(context: context, markAsArrival: false);
            navigator.pop();
          },
          message: "Do you want to sign out again?",
          exitLabel: "CANCEL",
          proceedLabel: "SIGN OUT",
        );
      }
    } else {
      await _setAttendanace(context: context, markAsArrival: true);
    }
  }

  static String? fmtArrival(DateTime? arrival) {
    if (arrival != null) {
      return DateFormat('jm').format(arrival);
    } else {
      return null;
    }
  }

  static String? fmtDeparture(DateTime? departure) {
    if (departure != null) {
      return DateFormat('jm').format(departure);
    } else {
      return null;
    }
  }
}
