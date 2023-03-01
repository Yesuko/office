import 'package:intl/intl.dart';
import 'package:office/util.dart';

class Expense {
  String blNumber;
  String title;
  String date;
  String amount;
  String amountSettled;
  List<Author> authors;
  bool isBreakdownSettled;
  String state;

  Expense.withDefaultDateAndBreakdown({
    required this.title,
    required this.amount,
    required this.authors,
    required this.blNumber,
  })  : date = DateFormat(kDateFormat).format(DateTime.now()),
        state = ExpenseState.unsettled.name,
        amountSettled = '0.00',
        isBreakdownSettled = false;

  Expense.withAttFromDB({
    required this.blNumber,
    required this.title,
    required this.amount,
    required this.date,
    required this.authors,
    required this.state,
    required this.isBreakdownSettled,
    required this.amountSettled,
  });

  // returns an object of the class
  static Expense _expenceObject(Map data) {
    return Expense.withAttFromDB(
      blNumber: data.keys.first,
      title: data.values.first["title"],
      amount: data.values.first["amount"],
      amountSettled: data.values.first["amountSettled"],
      date: data.values.first["date"],
      authors: Author.fromDB(data.values.first['authors']),
      state: data.values.first["state"],
      isBreakdownSettled: data.values.first['isBreakdownSettled'],
    );
  }

  static List<Expense> fromDB(Map data) {
    return data.entries.map((e) {
      return _expenceObject({e.key: e.value});
    }).toList();
  }

  static Map<String, dynamic> addToDB(Expense expense) {
    return {expense.blNumber: addToDBValueFormat(expense)};
  }

  static Map<String, dynamic> addToDBValueFormat(Expense expense) {
    return {
      'title': expense.title,
      'amount': expense.amount,
      'amountSettled': expense.amountSettled,
      'date': expense.date,
      'authors': Author.addToDB(expense.authors),
      'state': expense.state,
      'isBreakdownSettled': expense.isBreakdownSettled,
    };
  }
}

class Author {
  String name;
  String flag;
  String date;
  String time;

  Author()
      : name = "",
        date = DateFormat(kDateFormat).format(DateTime.now()),
        time = DateFormat(kTimeFormat).format(DateTime.now()),
        flag = AuthorFlags.from.name;

  Author.withAttributes({
    required this.name,
    required this.flag,
  })  : date = DateFormat(kDateFormat).format(DateTime.now()),
        time = DateFormat(kTimeFormat).format(DateTime.now());

  Author.withAttributesfromDB({
    required this.name,
    required this.flag,
    required this.date,
    required this.time,
  });

  /// [addToDB] : converts author objects into Maps for database. Recieves both List and object values of Author class.
  static Map<String, Map<String, String>> addToDB(
    dynamic authors,
  ) {
    Map<String, Map<String, String>> result = {};
    List<Author> auths = [];

    if (authors.runtimeType == Author) {
      auths.add(authors);
    } else {
      auths = authors;
    }

    for (var auth in auths) {
      result.putIfAbsent(auth.flag, () => _valueFormat(auth));
    }

    return result;
  }

  static List<Author> fromDB(Map authors) {
    return authors.entries.map((e) {
      return Author._authorObject({e.key: e.value});
    }).toList();
  }

  static Map<String, String> _valueFormat(Author author) {
    return {
      'name': author.name,
      'date': author.date,
      'time': author.time,
    };
  }

  static Author _authorObject(Map data) {
    return Author.withAttributesfromDB(
      flag: data.keys.first,
      name: data.values.first['name'],
      date: data.values.first['date'],
      time: data.values.first['time'],
    );
  }
}
