import 'dart:async';

import 'package:flutter/material.dart';
import 'package:office/logic/models/expense.dart';

import '../../databases/services/fire_rdb_service.dart';
import '../../util.dart';

class ExpenseManager extends ChangeNotifier {
  List<Expense> _settledExpenses = [];
  List<Expense> _unsettledExpenses = [];

  late StreamSubscription _settledExpenseStreamSubscription;
  late StreamSubscription _unsettledExpenseStreamSubscription;

  List<Expense> get unsettledExpense => _unsettledExpenses;
  List<Expense> get settledExpense => _settledExpenses;

  ExpenseManager() {
    loadUnsettledExpense();
    loadSettledExpense();
  }

  @override
  void dispose() {
    _settledExpenseStreamSubscription.cancel();
    _unsettledExpenseStreamSubscription.cancel();

    super.dispose();
  }

  void loadUnsettledExpense() {
    _unsettledExpenseStreamSubscription =
        FireRDBService.loadUnsettledExpense().listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        _unsettledExpenses = Expense.fromDB(data);
      } else {
        _unsettledExpenses = [];
      }
      notifyListeners();
    });
  }

  void loadSettledExpense() {
    _settledExpenseStreamSubscription =
        FireRDBService.loadSettledExpense().listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        _settledExpenses = Expense.fromDB(data);
      } else {
        _settledExpenses = [];
      }
      notifyListeners();
    });
  }

  /// [removeExpense] operation can only be used by unsettled expenses
  Future<void> removeExpense(String blNumber) async {
    await FireRDBService.removeExpense(blNumber);
  }

  /// [addExpense] operation can only be used by unsettled expenses
  Future<void> addExpense(Expense expense) async {
    await FireRDBService.addExpense(expense);
  }

  Future<void> moveToSettledExpenses(Expense expense) async {
    await FireRDBService.moveToSettledExpenses(expense);
  }

  /// [editExpenseTitle] operation can only be used by unsettled expenses
  /// the function updates values shown on expense form
  Future<void> editExpenseTitle(
    String blNumber,
    String title,
  ) async {
    await FireRDBService.editExpenseTitle(blNumber, title);
  }

  /// [updateExpense] operation can only be used by unsettled expenses
  Future<void> updateExpense(
    String blNumber,
    Map<String, dynamic> value,
  ) async {
    await FireRDBService.updateExpense(blNumber, value);
  }

  Future<void> addAuthor(String blNumber, Author author) async {
    await FireRDBService.addAuthor(blNumber, author);
  }

  Future<void> removeAuthor(String blNumber) async {
    await FireRDBService.removeAuthor(blNumber);
  }

  String get totalAmountOfUnsettledExpenses {
    double result = _unsettledExpenses.fold(
        0.0, (previousValue, exp) => previousValue + double.parse(exp.amount));

    return result.toStringAsFixed(2);
  }

  // double get totalAmountOfSettledExpenses {

  //   return _unsettledExpenses.fold(
  //       0.0, (previousValue, exp) => previousValue + double.parse(exp.amount));
  // }

  List<Expense> getExpenses(String state) {
    if (state == ExpenseState.unsettled.name) {
      return _unsettledExpenses;
    } else {
      return _settledExpenses;
    }
  }

  Expense getExp(String blNumber, String expenseState) {
    return getExpenses(expenseState)
        .firstWhere((exp) => exp.blNumber == blNumber);
  }

  List<Expense> get allExpenses {
    List<Expense> result = [];
    result.addAll(_unsettledExpenses);
    result.addAll(_settledExpenses);
    return result;
  }
}
