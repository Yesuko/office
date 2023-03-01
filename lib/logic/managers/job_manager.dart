import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:office/logic/models/job.dart';

import '../../databases/services/fire_rdb_service.dart';
import '../../util.dart';

class JobManager extends ChangeNotifier {
  List<Job> _pendingJobs = [];
  List<Job> _deliveredJobs = [];
  List<Job> _completedJobs = [];

  late StreamSubscription<DatabaseEvent> pendingJobStramSubscription;
  late StreamSubscription<DatabaseEvent> deliveredJobStreamSubscrption;
  late StreamSubscription<DatabaseEvent> completedJobStreamSubscription;

  List<Job> get pendingJobs => _pendingJobs;
  List<Job> get completedJobs => _completedJobs;
  List<Job> get deliveredJobs => _deliveredJobs;

  JobManager() {
    initialisePendingJobs();
    initialiseDeliveredJobs();
    initialiseCompletedJobs();
  }

  @override
  void dispose() {
    pendingJobStramSubscription.cancel();
    deliveredJobStreamSubscrption.cancel();
    completedJobStreamSubscription.cancel();
    super.dispose();
  }

// setting up list of jobs with data
  void initialisePendingJobs() {
    pendingJobStramSubscription = FireRDBService.loadPendingJob().listen(
      (event) {
        final value = event.snapshot.value;
        if (value != null) {
          value as Map;
          _pendingJobs =
              value.entries.map((e) => Job.fromDB(e.value, e.key)).toList();
        } else {
          _pendingJobs = [];
        }
        notifyListeners();
      },
    );
  }

  void initialiseDeliveredJobs() {
    deliveredJobStreamSubscrption = FireRDBService.loadDeliveredJob().listen(
      (event) {
        final value = event.snapshot.value;
        if (value != null) {
          value as Map;
          _deliveredJobs =
              value.entries.map((e) => Job.fromDB(e.value, e.key)).toList();
        } else {
          _deliveredJobs = [];
        }
        notifyListeners();
      },
    );
  }

  void initialiseCompletedJobs() {
    completedJobStreamSubscription =
        FireRDBService.loadCompletedJob().listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        value as Map;
        _completedJobs =
            value.entries.map((e) => Job.fromDB(e.value, e.key)).toList();
      } else {
        _completedJobs = [];
      }
      notifyListeners();
    });
  }

  // add job to db
  Future<void> addJob(Job job) async {
    await FireRDBService.addJob(job);
  }

  // remove job: only pending and delivered jobs can use this function
  Future<void> removeJob(String blNumber) async {
    await FireRDBService.removeJob(blNumber);
  }

  Future<void> changeState({
    required Job job,
    required String newState,
  }) async {
    await FireRDBService.changeState(job: job, newState: newState);
  }

  // change job stage: only pending and delivered jobs can use this function
  Future<void> changeJobStage({
    required Job job,
    required String newStage,
  }) async {
    await FireRDBService.changeJobStage(job: job, newStage: newStage);
  }

  ///[editJob] will update job property in db
  // properties here are those shown on the job form exluding "state"
  Future<void> editJob({
    required String blNumber,
    required String state,
    String? description,
    String? vesselName,
    String? type,
    String? etaDate,
    String? etdDate,
  }) async {
    await FireRDBService.editJob(blNumber: blNumber, state: state);
  }

  List<Job> getJobs(String state) {
    if (state == JobState.pending.name) {
      return _pendingJobs;
    } else if (state == JobState.delivered.name) {
      return _deliveredJobs;
    } else {
      return _completedJobs;
    }
  }

  List<Job> get allJobs {
    List<Job> result = [];
    result.addAll(_pendingJobs);
    result.addAll(_deliveredJobs);
    result.addAll(_completedJobs);

    return result;
  }
}
