import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controllers/attendance_controller.dart';
import '../../../../util.dart';
import 'metrics.dart';

class MetricsCard extends StatelessWidget {
  const MetricsCard({Key? key}) : super(key: key);

  int get daysInMonth {
    final date = DateTime.now();
    return DateTimeRange(
      start: DateTime(date.year, date.month, 1),
      end: DateTime(date.year, date.month + 1),
    ).duration.inDays;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Map<String, int> attendanceCount =
        AttendanceController.attendanceCount;
    final int days = daysInMonth;

    return Card(
      elevation: 3,
      child: Container(
        height: size.height * 0.15,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(DateFormat('yMMMM').format(DateTime.now()),
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Metrics(
              widthFactor: (attendanceCount[kNumOfPresent] ?? 0) / days,
              color: kPresentColor,
              number: attendanceCount[kNumOfPresent] ?? 0,
            ),
            Metrics(
              widthFactor: (attendanceCount[kNumOfAbsent] ?? 0) / days,
              color: kAbsentColor,
              number: attendanceCount[kNumOfAbsent] ?? 0,
            ),
            Metrics(
              widthFactor: (attendanceCount[kNumOfDayOff] ?? 0) / days,
              color: kDayOffColor,
              number: attendanceCount[kNumOfDayOff] ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}
