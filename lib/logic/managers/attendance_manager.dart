import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:office/databases/attendance_database.dart';
import 'package:office/logic/models/attendance.dart';
import 'package:office/logic/models/user.dart';
import 'package:office/util.dart';

class AttendanceManager extends ChangeNotifier {
  late StreamSubscription _attsub;
  late final List<CurrentUser> _listOfEmp;
  late final Map<String, dynamic> _monthlyAtt;
  final Map<String, int> _attendanceCount = {};
  Attendance _attendance = Attendance();

  Future<void> tidyUp() async {
    await _attsub.cancel();
    _attendance = Attendance();
    _attendanceCount.clear();
    notifyListeners();
  }

  Attendance get attendance => _attendance;
  List<CurrentUser> get listOfEmployees => _listOfEmp;
  Map<String, dynamic> get monthlyAttendance => _monthlyAtt;
  Map<String, int> get attendanceCount => _attendanceCount;

  void loadDailyAttendance(String empId) async {
    _attsub =
        AttendanceDatabase.fetchDailyAttendanceQuery(empId).listen((snapshot) {
      //initialising variable to hold attendance data
      Map<String, dynamic> data = {};
      final dBData = snapshot.data();

      if (dBData != null) {
        if (snapshot.exists && dBData.containsKey('recentAttendance')) {
          //assert date of attendance is today
          String today = DateFormat(kDateFormat).format(DateTime.now());

          if (dBData['recentAttendance']['date'] == today) {
            //get data
            data = dBData['recentAttendance'];
            //update arrival and departure from time stamp to datetime
            data.update(
              'arrival',
              (timestamp) => AttendanceDatabase.toDateTime(timestamp),
              ifAbsent: () => null,
            );

            data.update(
              'departure',
              (timestamp) => AttendanceDatabase.toDateTime(timestamp),
              ifAbsent: () => null,
            );
          }
        }
      }

      //set isSignIn property of attendance model
      bool isSignIn = data['arrival'] == null ? false : true;
      data.putIfAbsent('isSignIn', () => isSignIn);

      _attendance = Attendance.fromDB(data);

      notifyListeners();
    });
  }

  Future<void> markArrival(String empId) async {
    // set arrival
    await AttendanceDatabase.markArrivalQuery(empId, {
      'recentAttendance': {
        'arrival': AttendanceDatabase.toTimestamp(DateTime.now()),
        'date': DateFormat(kDateFormat).format(DateTime.now()),
      },
    });
  }

  Future<void> markDeparture(String empId) async {
    // set departure
    await AttendanceDatabase.markDepartureQuery(empId, {
      'recentAttendance': {
        'departure': AttendanceDatabase.toTimestamp(DateTime.now()),
      },
    });
  }

  Future<Map> fetchAttendanceByDate(String empId, DateTime dateTime) async {
    Map attendance = {};
    bool isWeekend = dateTime.weekday == 6 || dateTime.weekday == 7;

    // format date to match date in database
    String fmtDate = DateFormat(kDateFormat).format(dateTime);
    //get query result
    await AttendanceDatabase.fetchAttendanceByDateQuery(empId, fmtDate)
        .then((value) {
      if (value.exists) {
        //get attendance value
        Map<String, dynamic>? data = value.data();

        //set attendance base on the availabilty of attendance value
        if (data != null) {
          attendance = data[fmtDate];
        } else if (!isWeekend) {
          attendance = {kAbsent: ""};
        } else if (isWeekend) {
          attendance = {kWeekEnd: ""};
        }
      }
    });
    return attendance;
  }

  Future<void> loadMonthlyAttendance(String empId) async {
    _monthlyAtt = {};
    // get and structure date to have dd-mm-yy format
    // format pattern for day and month
    var fmt = NumberFormat("00", "en_US");
    //set date
    DateTime todayDate = DateTime.now();
    String month = fmt.format(todayDate.month);
    int year = todayDate.year;

    AttendanceDatabase.fetchMonthlyAttendanceQuery(empId).then((value) {
      if (value.docs.isNotEmpty) {
        for (var snap in value.docs) {
          // obtain tha data values from the DB
          _monthlyAtt.addEntries(snap.data().entries);
        }
      }

      // assign attendance value to each date
      for (int dayNum = 1; dayNum <= 31; dayNum++) {
        String day = fmt.format(dayNum); //set day
        String date = '$day-$month-$year';
        dynamic attendanceValue; //holds true, false or day off.

        if (_monthlyAtt.containsKey(date)) {
          if (_monthlyAtt.containsKey('dayOffField')) {
            attendanceValue = 'dayOff';
          } else {
            attendanceValue = true;
          }
        } else {
          attendanceValue = false;
        }

        // attendanceValue would hold a true, false or dayOff to each date
        _monthlyAtt.putIfAbsent(date, () => attendanceValue);
      }
      notifyListeners();
    });
  }

  Future<void> loadEmployees() async {
    // initialise variable to hold employees
    _listOfEmp = [];
    await AttendanceDatabase.fetchEmployeesQuery().then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (final snap in value.docs) {
            // add employee data to list
            _listOfEmp.add(CurrentUser.withAttributes(
                empId: snap.data()['empId'],
                department: snap.data()['department'],
                displayName: snap.data()['displayName'],
                uid: snap.data()['uid'],
                role: snap.data()['role'],
                photoURL: snap.data()['photoURL']));
          }
        }
      },
    );

    notifyListeners();
  }

  void updateAttendanceCount(Map<String, int> val) {
    for (final item in val.entries) {
      _attendanceCount.update(
        item.key,
        (value) => item.value,
        ifAbsent: () => item.value,
      );
    }
    notifyListeners();
  }
}
