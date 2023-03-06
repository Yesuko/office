import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/logic/models/breakdown_item.dart';
import 'package:office/logic/models/expense.dart';
import 'package:office/logic/models/job.dart';
import 'package:office/util.dart';

class FireRDBService {
  static final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

 

  /// Job Section
  /// ------------
  static Stream<DatabaseEvent> loadPendingJob() {
    return _dbRef.child(PENDING_PATH).onValue;
  }

  static Stream<DatabaseEvent> loadDeliveredJob() {
    return _dbRef.child(DELIVERED_PATH).onValue;
  }

  static Stream<DatabaseEvent> loadCompletedJob() {
    return _dbRef.child(COMPLETED_PATH).onValue;
  }

  // add job to db
  static Future<void> addJob(Job job) async {
    await _dbRef.child(PENDING_PATH).update(Job.addToDB(job));
  }

  // remove job: only pending and delivered jobs can use this function
  static Future<void> removeJob(String blNumber) async {
    await _dbRef.child('$PENDING_PATH/$blNumber').remove();
  }

  // update path value: only pending and delivered jobs can use this function
  static Future<void> _updateJob({
    required String state,
    required String blNumber,
    required Map<String, dynamic> value,
  }) async {
    if (state == JobState.pending.name) {
      await _dbRef.child('$PENDING_PATH/$blNumber').update(value);
    } else {
      await _dbRef.child('$DELIVERED_PATH/$blNumber').update(value);
    }
  }

  // change job state
  /// jobs can be moved from pending to delivered and vice versa.
  /// jobs can also be movered move from delivered to completed but not vice versa.
  static Future<void> _movefromPendingToDelivered(Job job,
      {bool reverse = false}) async {
    Map<String, dynamic> updates = {};
    if (reverse == true) {
      updates = {
        '$PENDING_PATH/${job.blNumber}': Job.addToDBValueFormat(
          job..state = JobState.pending.name,
        ),
        '$DELIVERED_PATH/${job.blNumber}': null,
      };
    } else {
      updates = {
        '$DELIVERED_PATH/${job.blNumber}': Job.addToDBValueFormat(
          job..state = JobState.delivered.name,
        ),
        '$PENDING_PATH/${job.blNumber}': null,
      };
    }
    _dbRef.update(updates);
  }

  static Future<void> _movefromDeliveredToCompleted(Job job) async {
    Map<String, dynamic> updates = {
      '$COMPLETED_PATH/${job.blNumber}': Job.addToDBValueFormat(
        job..state = JobState.completed.name,
      ),
      '$DELIVERED_PATH/${job.blNumber}': null,
    };

    _dbRef.update(updates);
  }

  static Future<void> changeState({
    required Job job,
    required String newState,
  }) async {
    if (newState == JobState.completed.name &&
        job.state == JobState.delivered.name) {
      await _movefromDeliveredToCompleted(job);
    } else if (newState == JobState.delivered.name &&
        job.state == JobState.pending.name) {
      await _movefromPendingToDelivered(job);
    } else {
      await _movefromPendingToDelivered(
          job..stage = PendingJobStages.clearance.name,
          reverse: true);
    }
  }

  // change job stage: only pending and delivered jobs can use this function
  static Future<void> changeJobStage({
    required Job job,
    required String newStage,
  }) async {
    final String date = DateFormat(kDateFormat).format(DateTime.now());

    if (newStage == PendingJobStages.delivered.name) {
      // new stage of job would show in the delivered jobs with it stage set to the last stage in pending jobs
      await _movefromPendingToDelivered(
        job
          ..stage = newStage
          ..stageDate = date,
      );
    } else if (newStage == DeliveredJobStages.invoiceSubmitted.name) {
      //add to completed jobs
      await _movefromDeliveredToCompleted(
        job
          ..stage = newStage
          ..stageDate = date,
      );
    } else {
      //just update stage
      await _updateJob(state: job.state, blNumber: job.blNumber, value: {
        'stage': newStage,
        'stageDate': date,
      });
    }
  }

  ///[editJob] will update job property in db
  // properties here are those shown on the job form exluding "state"
  static Future<void> editJob({
    required String blNumber,
    required String state,
    String? description,
    String? vesselName,
    String? type,
    String? etaDate,
    String? etdDate,
  }) async {
    Map<String, dynamic> updates = {};

    if (description != null) {
      updates.putIfAbsent('description', () => description);
    }
    if (vesselName != null) {
      updates.putIfAbsent('vesselName', () => vesselName);
    }
    if (type != null) {
      updates.putIfAbsent('type', () => type);
    }
    if (etaDate != null) {
      updates.putIfAbsent('etaDate', () => etaDate);
    }
    if (etdDate != null) {
      updates.putIfAbsent('etdDate', () => etdDate);
    }

    await _updateJob(state: state, blNumber: blNumber, value: updates);
  }

  /// Expenses section
  /// -------------------

  static Stream<DatabaseEvent> loadUnsettledExpense() {
    return _dbRef.child(UNSETTLED_EXPENSE_PATH).onValue;
  }

  static Stream<DatabaseEvent> loadSettledExpense() {
    return _dbRef.child(SETTLED_EXPENSE_PATH).onValue;
  }

  /// [removeExpense] operation can only be used by unsettled expenses
  static Future<void> removeExpense(String blNumber) async {
    await _dbRef.child('$UNSETTLED_EXPENSE_PATH/$blNumber').remove();
  }

  /// [addExpense] operation can only be used by unsettled expenses
  static Future<void> addExpense(Expense expense) async {
    await _dbRef
        .child('$UNSETTLED_EXPENSE_PATH/')
        .update(Expense.addToDB(expense));
  }

  static Future<void> moveToSettledExpenses(Expense expense) async {
    Map<String, dynamic> updates = {
      '$SETTLED_EXPENSE_PATH/${expense.blNumber}': Expense.addToDBValueFormat(
        expense..state = ExpenseState.settled.name,
      ),
      '$UNSETTLED_EXPENSE_PATH/${expense.blNumber}': null,
    };

    await _dbRef.update(updates);
  }

  /// [editExpenseTitle] operation can only be used by unsettled expenses
  /// the function updates values shown on expense form
  static Future<void> editExpenseTitle(
    String blNumber,
    String title,
  ) async {
    await updateExpense(blNumber, {'title': title});
  }

  /// [updateExpense] operation can only be used by unsettled expenses
  static Future<void> updateExpense(
    String blNumber,
    Map<String, dynamic> value,
  ) async {
    await _dbRef.child('$UNSETTLED_EXPENSE_PATH/$blNumber').update(value);
  }

  static Future<void> addAuthor(String blNumber, Author author) async {
    await _dbRef
        .child('$UNSETTLED_EXPENSE_PATH/$blNumber/authors')
        .update(Author.addToDB(author));
  }

  static Future<void> removeAuthor(String blNumber) async {
    // Expense expense =
    //     unsettledExpense.firstWhere((element) => element.id == blNumber);
    await _dbRef
        .child('$UNSETTLED_EXPENSE_PATH/$blNumber/authors')
        .update({'settled': null});
  }

  /// Breakdown Section
  /// ------------------

  static Stream<DatabaseEvent> loadUnsettledBreakdown(String blNumber) {
    return _dbRef.child('$UNSETTLED_BREAKDOWN_PATH/$blNumber/').onValue;
  }

  static Stream<DatabaseEvent> loadSettledBreadown(String blNumber) {
    return _dbRef.child('$SETTLED_BREAKDOWN_PATH/$blNumber/').onValue;
  }

  static Future<void> removeBreakdown(String blNumber) async {
    await _dbRef.child('$UNSETTLED_BREAKDOWN_PATH/$blNumber').remove();
  }

  static Future<void> addBreakdownItem(
    BreakdownItem breakdownItem,
    String blNumber,
  ) async {
    ///[addBreakdownItem] operation can only be used by un settled expense breakdown

    await _dbRef
        .child('$UNSETTLED_BREAKDOWN_PATH/$blNumber')
        .update(BreakdownItem.addToDB(breakdownItem));
  }

  static Future<void> removeBreakdownItem(
    String id,
    String blNumber,
  ) async {
    ///[removeBreakdownitem] can only be used by an item that is found in the unsettled expense breakdown
    await _dbRef.child('$UNSETTLED_BREAKDOWN_PATH/$blNumber/$id').remove();
  }

  static Future<void> editBreakdownItem({
    String? title,
    String? newAmount,
    Modifier? modifier,
    required String id,
    required String blNumber,
  }) async {
    // get values to update
    Map<String, dynamic> values = {};
    if (newAmount != null) {
      values.putIfAbsent('amount', () => newAmount);
    }
    if (title != null) {
      values.putIfAbsent('amount', () => newAmount);
    }
    if (modifier != null) {
      values.putIfAbsent('modifier', () => Modifier.addToDB(modifier));
    }

    await _dbRef
        .child('$UNSETTLED_BREAKDOWN_PATH/$blNumber/$id')
        .update(values);
  }

  static Future<bool> isBreakdownSettled(String blNumber) async {
    bool result = true;

    final event =
        await _dbRef.child('$UNSETTLED_BREAKDOWN_PATH/$blNumber').once();
    if (event.snapshot.exists && event.snapshot.value != null) {
      List<BreakdownItem> items =
          BreakdownItem.fromDB(event.snapshot.value as Map);

      for (var i in items) {
        if (i.state == BreakdownState.unsettled.name) {
          result = false;
          break;
        }
      }
    }
    return result;
  }

  static Future<void> settleBreakdownItem(
    String blNumber,
    String breakdownId,
  ) async {
    String date =
        '${DateFormat(kDateFormat).format(DateTime.now())}, ${DateFormat(kTimeFormat).format(DateTime.now())}';

    await _dbRef
        .child('$UNSETTLED_BREAKDOWN_PATH/$blNumber/$breakdownId')
        .update({
      'state': BreakdownState.settled.name,
      'settledTime': date,
    });
  }

  static Future<void> settleBreakdown(
      String blNumber, List<String> breakdownIds) async {
    if (breakdownIds.isEmpty) {
      return;
    } else {
      String date =
          '${DateFormat(kDateFormat).format(DateTime.now())}, ${DateFormat(kTimeFormat).format(DateTime.now())}';
      Map<String, dynamic> updates = {};

      for (int i = 0; i < breakdownIds.length; i++) {
        updates.putIfAbsent(
            '$UNSETTLED_BREAKDOWN_PATH/$blNumber/${breakdownIds[i]}/state',
            () => BreakdownState.settled.name);
        updates.putIfAbsent(
            '$UNSETTLED_BREAKDOWN_PATH/$blNumber/${breakdownIds[i]}/settledTime',
            () => date);
      }
      await _dbRef.update(updates);
    }
  }

  static Future<Map?> getUnsettledBreakdown(String blNumber) async {
    Map? data;
    final snapshot =
        await _dbRef.child('$UNSETTLED_BREAKDOWN_PATH/$blNumber').get();
    if (snapshot.exists) {
      data = snapshot.value as Map;
    }
    return data;
  }

  static Future<void> moveToSettledBreakdown(String blNumber) async {
    final data = await getUnsettledBreakdown(blNumber);
    if (data != null) {
      Map<String, dynamic> updates = {
        '$UNSETTLED_BREAKDOWN_PATH/$blNumber': null,
        '$SETTLED_BREAKDOWN_PATH/$blNumber': data,
      };
      await _dbRef.update(updates);
    }
  }
}
