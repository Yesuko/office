import 'package:flutter/material.dart';

import '../../controllers/attendance_controller.dart';
import '../../../util.dart';
import '../../widgets/return_button.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/transition_screen.dart';
import 'components/att_record_body.dart';

class AttendanceRecordScreen extends StatelessWidget {
  const AttendanceRecordScreen({
    Key? key,
    required this.employeeName,
    required this.empId,
  }) : super(key: key);
  final String employeeName;
  final String empId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(
          leading: ReturnButton(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          title: "$employeeName's $kAttendanceTitle",
          actions: const [SizedBox.shrink()],
        ),
        body: FutureBuilder(
            future: AttendanceController.loadMonthlyAttendance(empId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AttendanceRecordBody(
                  empId: empId,
                );
              } else {
                return const TransitionScreen(
                  transition: Transitions.attendanceRecordSkeleton,
                );
              }
            }));
  }
}
