import 'package:office/ui/controllers/attendance_controller.dart';
import 'package:office/ui/controllers/base_controller.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/models/job.dart';
import 'package:office/logic/models/user.dart';
import 'package:office/logic/managers/expense_manager.dart';
import 'package:office/logic/managers/job_manager.dart';
import 'package:provider/provider.dart';

class SearchController extends BaseController {
  static List<CurrentUser> filterUserResults(String query) {
    List<CurrentUser> itemList = [];
    if (query.isNotEmpty) {
      for (CurrentUser item in AttendanceController.listOfEmployees) {
        if (item.department
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item.empId.toString().toLowerCase().contains(query.toLowerCase()) ||
            item.displayName
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          itemList.add(item);
        }
      }
    } else {
      itemList.clear();
    }
    return itemList;
  }

  static List<Job> filterJobsResults(String query) {
    List<Job> itemList = [];
    if (query.isNotEmpty) {
      for (var item in BaseController.context.read<JobManager>().allJobs) {
        if (item.blNumber.toLowerCase().contains(query.toLowerCase()) ||
            item.vesselName.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase()) ||
            item.type.toLowerCase().contains(query.toLowerCase()) ||
            item.etaDate!.toLowerCase().contains(query.toLowerCase()) ||
            item.stage.toLowerCase().contains(query.toLowerCase())) {
          itemList.add(item);
        }
      }
    } else {
      itemList.clear();
    }
    return itemList;
  }

  static List<Expense> filterExpensesResults(String query) {
    List<Expense> itemList = [];
    if (query.isNotEmpty) {
      for (var item
          in BaseController.context.read<ExpenseManager>().allExpenses) {
        if (item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.date.toLowerCase().contains(query.toLowerCase()) ||
            item.authors.first.name
                .toLowerCase()
                .contains(query.toLowerCase())) {
          itemList.add(item);
        }
      }
    } else {
      itemList.clear();
    }
    return itemList;
  }
}
