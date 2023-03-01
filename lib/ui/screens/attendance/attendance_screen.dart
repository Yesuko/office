import 'package:flutter/material.dart';
import '../../../util.dart';
import '../../widgets/top_bar.dart';

import 'components/attendance_body.dart';

///this class sets the layout for an employee's attendance screen
/// layout composed of :
/// top bar and body.

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: TopBar(
          title: kAttendanceTitle,
          actions: [SizedBox.shrink()],
        ),
        body: AttendanceBody());
  }
}
