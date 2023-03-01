import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office/logic/models/job.dart';
import 'package:office/ui/screens/job_detail/components/job_detail_bg.dart';
import 'package:office/util.dart';
import 'package:office/ui/widgets/label_field_tile.dart';

class JobDetailBody extends StatelessWidget {
  final Job job;

  const JobDetailBody({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return JobDetailBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: size.height * 0.02,
          ),
          LabelFieldTile(
            label: "BL#: ",
            fieldValue: job.blNumber,
            color: kAccentFontColor,
            isVertical: false,
          ),
          LabelFieldTile(
            label: "Description",
            fieldValue: job.description,
            isVertical: false,
          ),
          LabelFieldTile(
            label: "Vessel Name",
            fieldValue: job.vesselName,
            isVertical: false,
          ),
          LabelFieldTile(
            label: "Job Type",
            fieldValue: toBeginningOfSentenceCase(job.type),
            isVertical: false,
          ),
          LabelFieldTile(
            label: "ETA",
            fieldValue: job.etaDate,
            isVertical: false,
          ),
          LabelFieldTile(
            label: "ETD",
            fieldValue: job.etdDate,
            isVertical: false,
          ),
          LabelFieldTile(
            label: "Job Stage",
            fieldValue: toBeginningOfSentenceCase(job.stage),
            color: Colors.teal,
            isVertical: false,
          ),
          LabelFieldTile(
            label: "Job Stage Date",
            fieldValue: job.stageDate,
            color: Colors.teal,
            isVertical: false,
          ),
        ],
      ),
    );
  }
}
