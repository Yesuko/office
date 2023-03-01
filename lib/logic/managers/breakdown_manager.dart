import 'dart:async';

import 'package:flutter/material.dart';
import 'package:office/logic/models/breakdown_item.dart';

import '../../databases/services/fire_rdb_service.dart';
import '../../util.dart';

class BreakdownManager extends ChangeNotifier {
  /// loading a settled or unsettled breakdown will use the same breakdown and subscription variables, since accessing of either settled or unsettled can be done one at a time.
  late StreamSubscription _breakdownSubscription;
  List<BreakdownItem> breakdown = [];
  //List<BreakdownItem> get breakdown => _breakdown;

  ///blNumber would be accessed globally by functions here exept from functions that would be called outsside if the breakdown page. A blNumber will be passsed since a call outside the breakdown page, would mean global blNumber has not been updated.
  late String blNumber;

  loadUnsettledBreakdown(String blNumber) {
    this.blNumber = blNumber;

    _breakdownSubscription =
        FireRDBService.loadUnsettledBreakdown(blNumber).listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        breakdown = BreakdownItem.fromDB(data);
      } else {
        breakdown = [];
      }
      notifyListeners();
    });
  }

  loadSettledBreakdown(String blNumber) {
    this.blNumber = blNumber;
    _breakdownSubscription =
        FireRDBService.loadSettledBreadown(blNumber).listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;
        breakdown = BreakdownItem.fromDB(data);
      } else {
        breakdown = [];
      }
      notifyListeners();
    });
  }

  @override
  dispose() {
    _breakdownSubscription.cancel();
    super.dispose();
  }

  Future<void> removeBreakdown(String blNumber) async {
    await FireRDBService.removeBreakdown(blNumber);
  }

  Future<void> addBreakdownItem(
    BreakdownItem breakdownItem,
  ) async {
    await FireRDBService.addBreakdownItem(breakdownItem, blNumber);
  }

  Future<void> removeBreakdownItem(
    String id,
  ) async {
    await FireRDBService.removeBreakdownItem(id, blNumber);
  }

  Future<void> editBreakdownItem({
    String? title,
    String? newAmount,
    Modifier? modifier,
    required String id,
  }) async {
    await FireRDBService.editBreakdownItem(
      id: id,
      blNumber: blNumber,
      title: title,
      modifier: modifier,
    );
  }

  Future<bool> isBreakdownSettled(String blNumber) async {
    return FireRDBService.isBreakdownSettled(blNumber);
  }

  Future<void> settleBreakdownItem(String breakdownId) async {
    await FireRDBService.settleBreakdownItem(blNumber, breakdownId);
  }

  Future<void> settleBreakdown() async {
    if (isAllBreakdownItemsSettled || breakdown.isEmpty) {
      return;
    } else {
      List<String> breakdownIds = [];
      for (int i = 0; i < breakdown.length; i++) {
        breakdownIds.add(breakdown[i].id);
      }
      await FireRDBService.settleBreakdown(blNumber, breakdownIds);
    }
  }

  Future<void> moveToSettledBreakdown(String blNumber) async {
    await FireRDBService.moveToSettledBreakdown(blNumber);
  }

  String get totalAmountOfUnsettledBreakdown {
    double totalAmount = 0.0;

    if (breakdown.isNotEmpty) {
      for (BreakdownItem item in breakdown) {
        if (item.state == BreakdownState.unsettled.name) {
          totalAmount += double.parse(item.amount);
        }
      }
    }

    return totalAmount.toStringAsFixed(2);
  }

  String get totalAmountOfSettledBreakdown {
    double totalAmount = 0.0;

    if (breakdown.isNotEmpty) {
      for (BreakdownItem item in breakdown) {
        if (item.state == BreakdownState.settled.name) {
          totalAmount += double.parse(item.amount);
        }
      }
    }

    return totalAmount.toStringAsFixed(2);
  }

  bool get isAllBreakdownItemsSettled {
    bool result = true;
    if (breakdown.isNotEmpty) {
      for (BreakdownItem item in breakdown) {
        if (item.state == BreakdownState.unsettled.name) {
          result = false;
          break;
        }
      }
    }
    return result;
  }
}
