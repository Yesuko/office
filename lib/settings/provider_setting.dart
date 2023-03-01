import 'package:flutter/material.dart';
import 'package:office/logic/managers/attendance_manager.dart';
import 'package:office/logic/managers/chat_manager.dart';
import 'package:provider/provider.dart';

import '../logic/managers/breakdown_manager.dart';
import '../logic/managers/expense_manager.dart';
import '../logic/managers/job_manager.dart';
import '../logic/managers/user_manager.dart';

class ProviderSetting extends StatelessWidget {
  const ProviderSetting({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserManager>(
          create: (_) => UserManager(),
        ),
        ChangeNotifierProvider<JobManager>(
          create: (_) => JobManager(),
        ),
        ChangeNotifierProvider<ExpenseManager>(
          create: (_) => ExpenseManager(),
        ),
        ChangeNotifierProvider<BreakdownManager>(
          create: (_) => BreakdownManager(),
        ),
        ChangeNotifierProvider<ChatManager>(
          create: (_) => ChatManager(),
        ),
        ChangeNotifierProvider<AttendanceManager>(
          create: (_) => AttendanceManager(),
        ),
      ],
      child: child,
    );
  }
}
