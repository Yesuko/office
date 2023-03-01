import 'package:flutter/material.dart';

import '../../../controllers/attendance_controller.dart';
import '../../../../util.dart';
import '../../../widgets/label_field_tile.dart';
import '../../../widgets/transition_screen.dart';

class RecordSheet extends StatefulWidget {
  final DateTime date;
  final String empId;

  const RecordSheet({Key? key, required this.date, required this.empId})
      : super(key: key);

  @override
  State<RecordSheet> createState() => _RecordSheetState();
}

class _RecordSheetState extends State<RecordSheet> {
  late Future<Map> _future;
  @override
  void initState() {
    super.initState();

    _future = AttendanceController.fetchAttendanceByDate(
      widget.date,
      widget.empId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            widget = buildRecordSheet(snapshot.data as Map);
          } else {
            widget = const TransitionScreen();
          }
          return widget;
        });
  }

  Widget buildRecordSheet(Map attendanceByDay) {
    Widget child;

    if (attendanceByDay.containsKey(kWeekEnd)) {
      child = const LabelFieldTile(
        label: kWeekEnd,
        fieldValue: "",
        isVertical: false,
      );
    } else if (attendanceByDay.containsKey(kAbsent)) {
      child = const LabelFieldTile(
        label: kAbsent,
        fieldValue: "",
        isVertical: false,
      );
    } else if (attendanceByDay.containsKey(KDBFields.dayOffField.name)) {
      child = LabelFieldTile(
        label: "$kDayOff :",
        fieldValue: attendanceByDay[KDBFields.dayOffField.name],
        isVertical: false,
      );
    } else {
      child = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelFieldTile(
            label: "arrival :",
            fieldValue: attendanceByDay[KDBFields.arrival.name],
            isVertical: false,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: LabelFieldTile(
              label: "departure :",
              fieldValue: attendanceByDay[KDBFields.departure.name],
              isVertical: false,
            ),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
      child: child,
    );
  }
}
