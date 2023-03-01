import 'package:flutter/material.dart';
import 'package:office/ui/controllers/attendance_controller.dart';

import '../../../../logic/models/user.dart';

import '../../../widgets/employee_tile.dart';
import '../../attendance_record/att_record_screen.dart';
import 'employees_bg.dart';

class EmployeesBody extends StatefulWidget {
  const EmployeesBody({Key? key}) : super(key: key);

  @override
  State<EmployeesBody> createState() => _EmployeesBodyState();
}

class _EmployeesBodyState extends State<EmployeesBody> {
  late List<CurrentUser> employees;
  @override
  void initState() {
    super.initState();
    employees = AttendanceController.listOfEmployees;
  }

  @override
  Widget build(BuildContext context) {
    return EmployeesBackground(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return EmployeeTile(
            fullName: employees[index].displayName,
            department: employees[index].department,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return AttendanceRecordScreen(
                      employeeName: employees[index].displayName,
                      empId: employees[index].empId);
                }),
              );
            },
          );
        },
        itemCount: employees.length,
      ),
    );
  }
}
