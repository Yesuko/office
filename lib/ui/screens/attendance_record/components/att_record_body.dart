import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/ui/screens/attendance_record/components/ledger_panel.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../controllers/attendance_controller.dart';
import '../../../../util.dart';
import 'metrics_card.dart';
import 'record_sheet.dart';

class AttendanceRecordBody extends StatefulWidget {
  final String empId;
  const AttendanceRecordBody({Key? key, required this.empId}) : super(key: key);

  @override
  State<AttendanceRecordBody> createState() => _AttendanceRecordBodyState();
}

class _AttendanceRecordBodyState extends State<AttendanceRecordBody> {
  late DateTime _selectedDay, _focusedDay, _today;
  late int _numOfDayOff, _numOfPresent, _numOfAbsent;
  late bool _showMetricsCard;
  late final Map<String, dynamic> _monthlyAttendance;

  @override
  void initState() {
    super.initState();
    _monthlyAttendance = AttendanceController.monthlyAttendance;
    _selectedDay = _focusedDay = _today = DateTime.now();
    _numOfAbsent = _numOfDayOff = _numOfPresent = 0;
    _showMetricsCard = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Flexible(
          flex: 7,
          fit: FlexFit.tight,
          child: Card(
            margin: EdgeInsets.only(
              bottom: size.height * 0.02,
              top: 4,
              left: 4,
              right: 4,
            ),
            elevation: 3,
            child: TableCalendar(
              availableGestures: AvailableGestures.all,
              calendarBuilders: _calendarBuilder(),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                  color: kFocusColor,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kFocusColor, width: 6.0),
                ),
                todayTextStyle: const TextStyle(color: Colors.black),
              ),
              firstDay: _today.subtract(const Duration(days: 31)),
              lastDay: _today,
              focusedDay: _focusedDay,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (DateTime sd, DateTime fd) async {
                setState(() {
                  _selectedDay = sd;
                  _focusedDay = fd;
                });

                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return RecordSheet(date: sd, empId: widget.empId);
                    });
              },
            ),
          ),
        ),
        const Flexible(
          child: LedgerPanel(),
        ),
        Flexible(
          flex: 2,
          child: Visibility(
            visible: _showMetricsCard,
            child: Container(
              margin: EdgeInsets.only(bottom: size.height * 0.02),
              child: const MetricsCard(),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              child: Text(
                _showMetricsCard
                    ? kHideMetricButtonLabel
                    : kShowMetricButtonLabel,
                style: const TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                if (_showMetricsCard == false) {
                  _showMetricsCard = true;
                } else if (_showMetricsCard == true) {
                  _showMetricsCard = false;
                }
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  CalendarBuilders _calendarBuilder() {
    return CalendarBuilders(
      markerBuilder: (context, date, events) {
        var color = kPresentColor;
        var attendanceDate = DateFormat(kDateFormat).format(date);
        bool isWeekEnd = date.weekday == 6 || date.weekday == 7;

        if (isWeekEnd && _monthlyAttendance[attendanceDate] == false) {
          color = kDefaultColor; // this code checks if date is a weekend and
          // applies the color white if there was no attendance on the weekend
          // numOfAbsent++;
        } else {
          if (_monthlyAttendance[attendanceDate] == true) {
            color = kPresentColor;
            _numOfPresent++;
          } else if (_monthlyAttendance[attendanceDate] == false) {
            color = kAbsentColor;
            _numOfAbsent++;
          } else if (date.day == _today.day) {
            color = kFocusColor;
          } else if (_monthlyAttendance[attendanceDate] == "dayOff") {
            color = kDayOffColor;
            _numOfDayOff++;
          } else {
            color = kDefaultColor; // this applies to the color white to all
            // other days of previous months
          }
        }
        // update matrics values
        AttendanceController.updateAttendanceCount({
          kNumOfPresent: _numOfPresent,
          kNumOfAbsent: _numOfAbsent,
          kNumOfDayOff: _numOfDayOff,
        });

        return Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 6.0),
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
