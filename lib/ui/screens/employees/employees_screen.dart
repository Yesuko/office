import 'package:flutter/material.dart';

import '../../controllers/attendance_controller.dart';
import '../../../util.dart';
import '../../widgets/icon_container.dart';
import '../../widgets/search_screen.dart';
import '../../widgets/top_bar.dart';
import '../../widgets/transition_screen.dart';
import 'components/employees_body.dart';

/// class layouts the employer's view of all the employees with name, picture
/// and department.
class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  dynamic _future;
  @override
  void initState() {
    super.initState();
    _future = AttendanceController.loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: kAttendanceTitle,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconContainer(
            iconData: Icons.search_sharp,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(title: kAttendanceTitle),
                  ));
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const EmployeesBody();
            } else {
              return const TransitionScreen(
                transition: Transitions.employeeListSkeleton,
              );
            }
          }),
    );
  }
}
