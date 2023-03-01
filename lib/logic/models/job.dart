import 'package:intl/intl.dart';
import 'package:office/util.dart';

class Job {
  String blNumber;
  String description;
  String vesselName;
  String type;
  String? etaDate;
  String? etdDate;
  String? expenseId;
  String state;
  String stage;
  String stageDate;

  //default constructor
  Job()
      : blNumber = "",
        description = "",
        vesselName = "",
        type = "",
        stage = "",
        stageDate = "",
        state = "",
        etaDate = null,
        etdDate = null,
        expenseId = null;

  // for creating new job with some defaults values
  Job.withAttributes({
    required this.blNumber,
    required this.description,
    required this.vesselName,
    required this.type,
    this.etaDate,
    this.etdDate,
    this.expenseId,
  })  : stage = PendingJobStages.documentation.name,
        state = JobState.pending.name,
        stageDate = DateFormat(kDateFormat).format(DateTime.now());

  // for getting job fields from Data base
  Job.withAttFromDB(
      {required this.blNumber,
      required this.description,
      required this.vesselName,
      required this.type,
      this.etaDate,
      this.etdDate,
      this.expenseId,
      required this.stage,
      required this.stageDate,
      required this.state});

  // factory constructor to call Job.withAttFromDB
  factory Job.fromDB(Map<dynamic, dynamic> data, String key) {
    return Job.withAttFromDB(
      blNumber: key,
      description: data["description"],
      vesselName: data["vesselName"],
      type: data["type"],
      etaDate: data["etaDate"],
      etdDate: data["etdDate"],
      expenseId: data["expenseId"],
      state: data["state"],
      stage: data["stage"],
      stageDate: data["stageDate"],
    );
  }

  // format for adding job to database
  static Map<String, dynamic> addToDB(Job job) {
    return {job.blNumber: addToDBValueFormat(job)};
  }

  static Map<String, dynamic> addToDBValueFormat(Job job) {
    return {
      'description': job.description,
      'vesselName': job.vesselName,
      'type': job.type,
      'etaDate': job.etaDate,
      'etdDate': job.etdDate,
      'stage': job.stage,
      'stageDate': job.stageDate,
      'state': job.state,
      'expenseId': job.expenseId,
    };
  }
}
