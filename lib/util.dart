import 'package:flutter/material.dart';

// App titles
const String kAppTitle = '2PWaves Attendance';
const String kAttendanceTitle = 'Attendance';
const String kRecordTitle = 'Record';
const String kEmployeesTitle = 'Employees';
const String kExpenseScreenTitle = "Expenses";
const String kAccountScreenTitle = "Account";
const String kJobScreenTitle = "Jobs";
const String kChatScreenTitle = "Chats";
const String kJobDetailTitle = "Job Details";
const String kShowMetricButtonLabel = 'Show metrics';
const String kHideMetricButtonLabel = "Hide metrics";

// color scheme
const kPrimaryColor = Color(0xff3eb489);
//Color(0xFF25E901);
const kPrimaryLightColor = Color(0xFFE4FFE4);
const kAccentColor = Color(0xFF420701);
const kAccentLightColor = Color(0xFF442B2D);
const kFontColorBlack = Color(0xFF000000);
const kFontColorRed = Color(0xffb43e3e);
const kFontColorGreen = Color(0xff3eb489);
const kFontColorGrey = Colors.grey;
const kAccentFontColor = Color(0xFF7D4F52);
const kSecondaryColor = Colors.grey;
const kSnackBarBgColor = Colors.black38;

// Chat bubble colours
const kChatBubblePrimaryBg = Color(0x5EB6F3B6);
const kChatBubbleSecondaryBg = Color(0x6DB9D5F0);

// Chat attachment colors
const kJobAttacment = Color(0xFF442B2D);
const kExpenseAttachment = Color(0xEE599E78);
const kChatReference = Color(0xFF5B8FB1);
const kOtherAttachment = Color(0xFFB15B5B);

// Chat header
const kChatHeaderColor = Color.fromARGB(255, 180, 62, 145);

//Calender colors
const kDayOffColor = Colors.grey;
const kPresentColor = Color(0xff3eb489);
const kAbsentColor = Color(0xffb43e3e);
const kFocusColor = Color(0xFFE4FFE4);
const kDefaultColor = Colors.white;

// Dimensions
const kFontWeight = FontWeight.bold;
const double kToolBarHeight = 50.0;
const double kExtendedToolBarWithTabsHeight = 140;
const double kExtendedToolBarHeight = 100;
// const double kTitleSpacing = 30.0;
const EdgeInsets kBottomPaddingOfTopBar = EdgeInsets.only(top: 1.0);

const List<String> groupOfWifiGateWay = ["192.168.8.1", "172.20.10.1"];

// address to check if app is connected to the internet or database server
const String pingAddress = 'attendance-2pwaves-default-rtdb.firebaseio.com';

//data base fields
const String kDateFormat = 'dd-MM-yyyy';
const String kTimeFormat = 'hh:mm';

//paths
// ignore: constant_identifier_names
const String PENDING_PATH = "jobs_pending";
// ignore: constant_identifier_names
const String DELIVERED_PATH = "jobs_delivered";
// ignore: constant_identifier_names
const String COMPLETED_PATH = "jobs_completed";

// ignore: constant_identifier_names
const String SETTLED_EXPENSE_PATH = "expenses_settled";
// ignore: constant_identifier_names
const String UNSETTLED_EXPENSE_PATH = "expenses_unsettled";

// ignore: constant_identifier_names
const String UNSETTLED_BREAKDOWN_PATH = "breakdown_unsettled";
// ignore: constant_identifier_names
const String SETTLED_BREAKDOWN_PATH = "breakdown_settled";

// ignore: constant_identifier_names
const String AUTHORS_PATH = "authors_log";
// ignore: constant_identifier_names
const String MODIFIERS_PATH = "modifiers_log";

enum KDBFields {
  date,
  isSignIn,
  arrival,
  departure,
  dayOffField,
  empId,
  role,
  attendance,
  department,
  fullName,
  employee,
  userIdsEmails,
  employer,
  expenseTitle,
  expenseDate,
  expenseAmount,
  expenseBreakdown
}

// department

enum Departments { operation, documentation, finance }

// transitions
enum Transitions {
  circular,
  jobSkeleton,
  jobDetailSkeleton,
  attendanceSkeleton,
  breakdownSkeleton,
  expenseSkeleton,
  attendanceRecordSkeleton,
  employeeListSkeleton
}

//bottom sheet options
enum BottomSheetOptions {
  add,
  edit,
  info,
  changeStage,
  addExpense,
  showListOfJobs,
  showListOfExpenses,
}

// chat attachment types
enum ChatAttachments { job, expense, chatItem, other }

// expense flags
enum AuthorFlags { settled, from }

//breakdown flags
enum ModifierFlags { edited }

//expense states
enum ExpenseState {
  settled,
  unsettled,
}

//breakdown states
enum BreakdownState { settled, unsettled }

// job flags
enum JobTypes {
  import,
  export,
  shipSpares,
  transhipment,
  transit,
  devaning,
  others
}

enum JobState { pending, delivered, completed }

//pending state stages
enum PendingJobStages {
  documentation,
  clearance,
  delivered,
}

//delivered state stages
enum DeliveredJobStages {
  invoiceCreated,
  invoiceSubmitted,
}

//app fields
const String kAbsent = "Absent";
const String kDayOff = "Day Off";
const String kWeekEnd = "Week end";
const String kSignInTime = "Sign In Time";
const String kSignOutTime = "Sign Out Time";
const String kEmployeeID = "Employee ID";
const String kFullName = "Full Name";
const String kDepartment = "Department";
const String kNumOfDayOff = "numOffDayOff";
const String kNumOfPresent = "numOfPresent";
const String kNumOfAbsent = "numOfAbsent";
