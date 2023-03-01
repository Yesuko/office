import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/logic/managers/attendance_manager.dart';
import 'package:office/ui/controllers/attendance_controller.dart';

import 'package:office/ui/screens/attendance/components/attendance_screen_controller.dart';
import 'package:provider/provider.dart';

import '../../../../logic/models/user.dart';

import '../../../controllers/user_controller.dart';
import '../../../../util.dart';
import '../../../widgets/label_field_tile.dart';

import '../../../widgets/rounded_button.dart';
import 'attendance_bg.dart';

///this class builds layout that allows employee to clock in/out attendance
///for today

class AttendanceBody extends StatefulWidget {
  const AttendanceBody({Key? key}) : super(key: key);

  @override
  State<AttendanceBody> createState() => _AttendanceBodyState();
}

class _AttendanceBodyState extends State<AttendanceBody> {
  @override
  void didChangeDependencies() {
    AttendanceController.loadDailyAttendance();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen

    CurrentUser employee = UserController.currentUser;
    return AttendanceBackground(
      child: Container(
        margin: EdgeInsets.only(
          top: size.height * 0.03,
          bottom: size.height * 0.09,
        ),
        child: Column(
          children: [
            /// time stamp section
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LabelFieldTile(
                    label: "Date",
                    fieldValue: DateFormat(kDateFormat).format(DateTime.now()),
                    isVertical: true,
                  ),
                ],
              ),
            ),

            /// employee details section
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LabelFieldTile(
                    label: kEmployeeID,
                    fieldValue: employee.empId,
                    isVertical: false,
                  ),
                  LabelFieldTile(
                    label: kFullName,
                    fieldValue: employee.displayName,
                    isVertical: false,
                  ),

                  LabelFieldTile(
                    label: kDepartment,
                    fieldValue: employee.department,
                    isVertical: false,
                  ),

                  /// sign in/out section
                  Consumer<AttendanceManager>(
                    builder: (_, manager, __) {
                      return LabelFieldTile(
                        label: kSignInTime,
                        fieldValue: AttendanceScreenController.fmtArrival(
                            manager.attendance.arrival),
                        isVertical: false,
                      );
                    },
                  ),

                  Consumer<AttendanceManager>(
                    builder: (_, manager, __) {
                      return LabelFieldTile(
                        label: kSignOutTime,
                        fieldValue: AttendanceScreenController.fmtDeparture(
                            manager.attendance.departure),
                        isVertical: false,
                      );
                    },
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),

            /// buttons section
            Column(
              children: [
                Consumer<AttendanceManager>(
                  builder: (_, manager, __) {
                    return RoundedButton(
                      text: "Sign in",
                      color: manager.attendance.isSignIn
                          ? kPrimaryLightColor
                          : kPrimaryColor,
                      press: () async {
                        if (manager.attendance.isSignIn) {
                          return null;
                        } else {
                          await AttendanceScreenController.markAttendance(
                            manager.attendance,
                            context,
                          );
                        }
                      },
                    );
                  },
                ),
                Consumer<AttendanceManager>(
                  builder: (_, manager, __) {
                    return RoundedButton(
                      text: "Sign Out",
                      color: manager.attendance.isSignIn
                          ? kPrimaryColor
                          : kPrimaryLightColor,
                      press: () async {
                        if (manager.attendance.isSignIn) {
                          await AttendanceScreenController.markAttendance(
                            manager.attendance,
                            context,
                          );
                        } else {
                          return null;
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            // SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
