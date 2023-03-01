import 'package:office/logic/managers/attendance_manager.dart';

import 'package:provider/provider.dart';

import '../../logic/models/attendance.dart';
import 'base_controller.dart';
import 'user_controller.dart';

class AttendanceController extends BaseController {
  static final attProv = BaseController.context.read<AttendanceManager>();
  static Future<void> loadEmployees() async {
    // set attendance details for employer
    await attProv.loadEmployees();
  }

  static dynamic loadDailyAttendance() {
    //set today's attendance details for employee.
    final user = UserController.currentUser;
    
      attProv.loadDailyAttendance(user.empId);
    
  }

  static Future<void> loadMonthlyAttendance(String empId) async {
    //empId would vary per employee selected by employe, hence the need to supply empId as a parameter.

    // set attendance for the month for an employee
    await attProv.loadMonthlyAttendance(empId);
  }

  static Future<void> markArrival() async {
    final user = UserController.currentUser;

    attProv.markArrival(user.empId);
  }

  static Future<void> markDeparture() async {
    final user = UserController.currentUser;
    attProv.markDeparture(user.empId);
  }

  static Future<Map> fetchAttendanceByDate(DateTime date, String empId) async {
    return attProv.fetchAttendanceByDate(empId, date);
  }

  static void updateAttendanceCount(Map<String, int> value) {
    attProv.updateAttendanceCount(value);
  }

  static Map<String, int> get attendanceCount => attProv.attendanceCount;

  static Map<String, dynamic> get monthlyAttendance {
    return attProv.monthlyAttendance;
  }

  static get listOfEmployees => attProv.listOfEmployees;
  static Attendance get attendance => attProv.attendance;
}
