import 'package:office/util.dart';

class Attendance {
  String? date;
  DateTime? arrival;
  DateTime? departure;
  bool isSignIn;
  String? dayOffFlag;

  Attendance() : isSignIn = false;

  Attendance.attributes({
    this.date,
    this.departure,
    this.arrival,
    required this.isSignIn,
  });

  Attendance.dayOff({
    required this.date,
    required this.dayOffFlag,
    required this.isSignIn,
  });

  factory Attendance.fromDB(Map data) {
    if (data.containsKey("dayOffFlag")) {
      return Attendance.dayOff(
        date: data['date'],
        dayOffFlag: data["dayOffFlag"],
        isSignIn: data['isSignIn'],
      );
    } else {
      return Attendance.attributes(
          date: data[KDBFields.date.name],
          departure: data[KDBFields.departure.name],
          arrival: data[KDBFields.arrival.name],
          isSignIn: data[KDBFields.isSignIn.name]);
    }
  }
}
