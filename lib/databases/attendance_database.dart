import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office/databases/firestore_service.dart';

class AttendanceDatabase {
  static final _singleton = AttendanceDatabase._internal();

  factory AttendanceDatabase() {
    return _singleton;
  }
  //initialize the class's internal state when
  //the single instance of the class is created.
  AttendanceDatabase._internal();

  //fetch the daily attendance of an employee
  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      fetchDailyAttendanceQuery(String empId) {
    return FirestoreService.ref
        .collection('attendances')
        .doc(empId)
        .snapshots();
  }

  // set arrival
  static Future<void> markArrivalQuery(
    String empId,
    Map<String, dynamic> data,
  ) async {
    FirestoreService.ref
        .collection('attendances')
        .doc(empId)
        .set(data, SetOptions(merge: true));
  }

  // set departure
  static Future<void> markDepartureQuery(
    String empId,
    Map<String, dynamic> data,
  ) async {
    FirestoreService.ref
        .collection('attendances')
        .doc(empId)
        .set(data, SetOptions(merge: true));
  }

  //fetch details of employees
  static Future<QuerySnapshot<Map<String, dynamic>>>
      fetchEmployeesQuery() async {
    return await FirestoreService.ref
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .orderBy('displayName')
        .get();
  }

// fetch attendnace per passed date
  static Future<DocumentSnapshot<Map<String, dynamic>>>
      fetchAttendanceByDateQuery(String empId, String fmtDate) async {
    return await FirestoreService.ref
        .collection('attendances')
        .doc(empId)
        .collection('attendances')
        .doc(fmtDate)
        .get();
  }

// fetch 31 attendances record of employer
  static Future<QuerySnapshot<Map<String, dynamic>>>
      fetchMonthlyAttendanceQuery(String empId) async {
    return await FirestoreService.ref
        .collection('attendances')
        .doc(empId)
        .collection('attendances')
        .limit(31)
        .get();
  }

  static DateTime toDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static Timestamp toTimestamp(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
