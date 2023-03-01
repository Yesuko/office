import 'package:flutter/material.dart';

import '../../controllers/user_controller.dart';
import '../../../util.dart';
import '../account/account_screen.dart';
import '../chat/chat_screen.dart';
import '../employees/employees_screen.dart';
import '../expense/expense_screen.dart';
import '../job/job_screen.dart';
import '../attendance/attendance_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Widget customScreen;
  late IconData customScreenIcon;

  @override
  void initState() {
    super.initState();

    if (UserController.currentUser.role == KDBFields.employee.name) {
      //if user is employee, let the first page of the homescreen be the attendance page of the currently signed in employee

      customScreen = const AttendanceScreen();
      customScreenIcon = Icons.timelapse_sharp;
    } else {
      //else if user is employer, let the first page of the homscreen show the attendace of all employees i.e the employees page
      customScreen = const EmployeesScreen();
      customScreenIcon = Icons.group_sharp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: navigationItems.keys.toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kPrimaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (mounted) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: navigationItems.values.toList(),
      ),
    );
  }

  Map<Widget, BottomNavigationBarItem> get navigationItems {
    /// build a map of bottom navigation item and their respective
    /// screens
    return {
      customScreen: BottomNavigationBarItem(
        icon: Icon(customScreenIcon),
        label: kAttendanceTitle,
      ),
      const JobScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.work_sharp),
        label: kJobScreenTitle,
      ),
      const ExpenseScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.show_chart_sharp),
        label: kExpenseScreenTitle,
      ),
      const ChatScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.chat_sharp),
        label: kChatScreenTitle,
      ),
      const AccountScreen(): const BottomNavigationBarItem(
        icon: Icon(Icons.settings_sharp),
        label: kAccountScreenTitle,
      ),
    };
  }
}
