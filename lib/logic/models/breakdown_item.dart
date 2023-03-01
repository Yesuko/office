import 'package:intl/intl.dart';
import 'package:office/util.dart';
import 'package:uuid/uuid.dart';

class BreakdownItem {
  String id;
  String title;
  String amount;
  Modifier? modifier;
  String state;
  String? settledTime;

  BreakdownItem.withAttributes({
    required this.title,
    required this.amount,
  })  : state = BreakdownState.unsettled.name,
        modifier = null,
        settledTime = "",
        id = const Uuid().v1();

  BreakdownItem.withAttributesfromDB({
    required this.id,
    required this.title,
    required this.amount,
    required this.settledTime,
    required this.state,
    required this.modifier,
  });

  static BreakdownItem _breakdownItemObject(Map data) {
    return BreakdownItem.withAttributesfromDB(
      id: data.keys.first,
      title: data.values.first['title'],
      amount: data.values.first['amount'],
      settledTime: data.values.first['settledTime'],
      state: data.values.first['state'],
      modifier: Modifier.fromDB(data.values.first['modifier']),
    );
  }

  static List<BreakdownItem> fromDB(Map breakdownItems) {
    return breakdownItems.entries
        .map((e) => _breakdownItemObject({e.key: e.value}))
        .toList();
  }

  static Map<String, dynamic> _valueFormat(BreakdownItem bi) {
    return {
      'title': bi.title,
      'amount': bi.amount,
      'settledTime': bi.settledTime,
      'state': bi.state,
      'modifier': Modifier.addToDB(bi.modifier),
    };
  }

  static Map<String, dynamic> addToDB(dynamic breakdown) {
    Map<String, dynamic> result = {};
    List<BreakdownItem> brkdown = [];

    if (breakdown.runtimeType == BreakdownItem) {
      brkdown.add(breakdown);
    } else {
      brkdown = breakdown;
    }

    for (var bi in brkdown) {
      result.putIfAbsent(bi.id, () => _valueFormat(bi));
    }
    return result;
  }
}

class Modifier {
  String name;
  String flag;
  String date;
  String time;
  String oldValue;
  String newValue;

  Modifier.withAttributes({
    required this.name,
    required this.oldValue,
    required this.newValue,
  })  : date = DateFormat(kDateFormat).format(DateTime.now()),
        time = DateFormat(kTimeFormat).format(DateTime.now()),
        flag = ModifierFlags.edited.name;

  Modifier.withAttributesfromDB({
    required this.name,
    required this.oldValue,
    required this.newValue,
    required this.flag,
    required this.date,
    required this.time,
  });

  static Map<String, dynamic>? addToDB(Modifier? modifier) {
    if (modifier == null) {
      return null;
    }
    return {
      'name': modifier.name,
      'date': modifier.date,
      'time': modifier.time,
      'flag': modifier.flag,
      'oldValue': modifier.oldValue,
      'newValue': modifier.newValue,
    };
  }

  static Modifier? fromDB(Map<dynamic, dynamic>? data) {
    if (data == null) {
      return null;
    }
    return Modifier.withAttributesfromDB(
      name: data['name'],
      oldValue: data['oldValue'],
      newValue: data['newValue'],
      flag: data['flag'],
      date: data['date'],
      time: data['time'],
    );
  }
}
