import 'dart:io';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../util.dart';

class FireStoreService {
  static final FirebaseFirestore _fb = FirebaseFirestore.instance;
 
  /// employee functions - atttendance
  static DocumentReference<Map<String, dynamic>>
      fetchEmployeeAttendanceForToday(String empId) {
    return _fb.collection('attendances').doc(empId);
  }

  static Future<void> markArrival(String empId, DateTime date) async {
    _fb.collection('attendances').doc(empId).set({
      'recentAttendance': {
        'arrival': Timestamp.fromDate(date),
        'date': DateFormat(kDateFormat).format(date),
      },
    }, SetOptions(merge: true));
  }

  static Future<void> markDeparture(String empId, DateTime date) async {
    // update db
    _fb.collection('attendances').doc(empId).set({
      'recentAttendance': {
        'departure': Timestamp.fromDate(date),
      },
    }, SetOptions(merge: true));
  }

  /// employer function - attendance

  static Future<List<Map<String, dynamic>>> fetchEmployees() async {
    final List<Map<String, dynamic>> empData = [];
    await _fb
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .orderBy('displayName')
        .get()
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (final snap in value.docs) {
            empData.add(snap.data());
          }
        }
      },
    );
    return empData;
  }

  static Future<Map> getAttendanceByDate(DateTime date, String empId) async {
    Map attendance = {};
    bool isWeekend = date.weekday == 6 || date.weekday == 7;

    // format date to match date in database
    String fmtDate = DateFormat(kDateFormat).format(date);

    final snapshot = await _fb
        .collection('attendances')
        .doc(empId)
        .collection('attendances')
        .doc(fmtDate)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();

      if (data != null && data.containsKey(fmtDate)) {
        attendance = data[fmtDate];
      } else if (!isWeekend) {
        attendance = {kAbsent: ""};
      } else if (isWeekend) {
        attendance = {kWeekEnd: ""};
      }
    }

    return attendance;
  }

  static Future<Map<String?, dynamic>> fetchMonthlyAttendance(
      String empId) async {
    Map<String?, dynamic> attendanceForThisMonth = {};

    DateTime today = DateTime.now();
    //set date

    var fmt = NumberFormat("00", "en_US");
    // format pattern for day and month

    String month = fmt.format(today.month);
    int year = today.year;
    // get month and year

    int yesterday = today.day - 1;
    // get yesterday's day

    bool isToday = yesterday == 0;

    if (isToday) {
      return attendanceForThisMonth;
    } else {
      for (int i = 1; i <= yesterday; i++) {
        String day = fmt.format(i); //set day
        String date = '$day-$month-$year';
        dynamic attendanceValue; //holds true, false or day off.
        String path = 'attendances';

        await _fb
            .collection(path)
            .doc(empId)
            .collection(path)
            .limit(31)
            .get()
            .then((snapshot) {
          for (var doc in snapshot.docs) {
            Map<String, dynamic>? data = doc.data();

            if (data.containsKey(date)) {
              if (data.containsKey('dayOffField')) {
                attendanceValue = 'dayOff';
              } else {
                attendanceValue = true;
              }
            } else {
              attendanceValue = false;
            }
          }
        });

        // attendanceValue would hold a true, false or dayOff to each date
        attendanceForThisMonth.putIfAbsent(date, () => attendanceValue);
      }
    }
    return attendanceForThisMonth;
  }

  /// chat section
  static Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessages() {
    return _fb
        .collection('spaces')
        .doc('general')
        .collection('messages')
        .orderBy('sentAt')
        .snapshots(includeMetadataChanges: true);
  }

  static Future<String> saveMessage(
    Map<String, dynamic> message,
  ) async {
    if (message.isNotEmpty) {
      //convert datetime to firestore timestaamp;
      message.update('sentAt', (date) => Timestamp.fromDate(date));
      return await _fb
          .collection('spaces')
          .doc('general')
          .collection('messages')
          .add(message)
          .then((docRef) {
        return 'success';
      }).onError((error, stackTrace) => 'failure');
    } else {
      return 'message is empty';
    }
  }

  static Future deleteMessage(String messageId) async {
    _fb.collection('spaces/general/messages').doc(messageId).delete();
  }

  static Future<Map> saveUserDetails(user, department) async {
    Map<String, dynamic> update = {
      'uid': user.uid,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'department': department,
      'role': null,
      'empId': "",
    };

    var userRef = _fb.collection('users').doc(user.uid);
    userRef.set(update);

    return update;
  }

  static Future<dynamic> getUserInitData(String uid) async {
    var snapshot = await _fb.collection('users').doc(uid).get();
    return snapshot.data();
  }
}
