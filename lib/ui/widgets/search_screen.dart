import 'package:flutter/material.dart';
import 'package:office/logic/managers/attendance_manager.dart';
import 'package:provider/provider.dart';

import '../controllers/search_controller.dart';

import '../screens/breakdown/breakdown_screen.dart';
import '../screens/job_detail/job_detail_screen.dart';
import '../screens/attendance_record/att_record_screen.dart';
import '../../util.dart';
import 'employee_tile.dart';
import 'expense_tile.dart';
import 'job_tile.dart';
import 'return_button.dart';
import 'search_field.dart';
import 'top_bar.dart';
import 'transition_screen.dart';

class SearchScreen extends StatefulWidget {
  final String title;

  const SearchScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        leading: ReturnButton(onTap: () => Navigator.pop(context)),
        title: 'Search ${widget.title}',
      ),
      body: Column(children: [
        SearchField(
          onChanged: (String query) {
            if (widget.title == kAttendanceTitle) {
              itemList = SearchController.filterUserResults(query);
            } else if (widget.title == kJobScreenTitle) {
              itemList = SearchController.filterJobsResults(query);
            } else {
              itemList = SearchController.filterExpensesResults(query);
            }
            if (mounted) {
              setState(() {});
            }
          },
        ),
        Expanded(child: _buildSearchResult())
      ]),
    );
  }

  Widget _buildSearchResult() {
    return ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          if (widget.title == kExpenseScreenTitle) {
            return ExpenseTile.withMinimalFunctionality(
                date: itemList[index].date,
                title: itemList[index].title,
                amount: itemList[index].amount,
                authors: itemList[index].authors,
                state: itemList[index].state,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BreakDownScreen(
                        blNumber: itemList[index].isUserAllowedToEdit,
                        expenseState: itemList[index].state,
                      ),
                    ),
                  );
                });
          } else if (widget.title == kJobScreenTitle) {
            return JobTile.withMinimalFunctionality(
                blNumber: itemList[index].blNumber,
                description: itemList[index].description,
                etaDate: itemList[index].etaDate,
                jobStage: itemList[index].stage,
                jobType: itemList[index].type,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(
                        blNumber: itemList[index].blNumber,
                        state: itemList[index].state,
                      ),
                    ),
                  );
                });
          } else {
            return EmployeeTile(
              fullName: itemList[index].displayName,
              department: itemList[index].department,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FutureBuilder(
                      future: context
                          .read<AttendanceManager>()
                          .loadMonthlyAttendance(itemList[index].empId),
                      builder: (context, snapshot) {
                        Widget widget = const TransitionScreen();
                        if (snapshot.connectionState == ConnectionState.done) {
                          widget = AttendanceRecordScreen(
                              employeeName: itemList[index].displayName,
                              empId: itemList[index].empId);
                        }
                        return widget;
                      },
                    );
                  }),
                );
              },
            );
          }
        });
  }
}
