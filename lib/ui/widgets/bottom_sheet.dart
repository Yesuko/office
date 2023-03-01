import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:office/logic/models/expense.dart' show Author;
import 'package:office/logic/models/breakdown_item.dart' show Modifier;

import '../../util.dart';
import '../../databases/services/textformat_service.dart';

import './date_dropdown_field.dart';
import './dropdown_field.dart';
import './rounded_button.dart';
import './rounded_input_field.dart';
import './text_field_container.dart';

class BottomSheetLayout {
  static Padding buildTitleAndAmountField({
    required BuildContext context,
    required titleHintText,
    required titleIcon,
    required titleOnChanged,
    required amountHintText,
    required amountIcon,
    required amountOnChanged,
    required onPressed,
    required buttonText,
    required header,
    initialTitle,
    initialAmount,
  }) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                header,
                style: const TextStyle(color: kSecondaryColor, fontSize: 16),
              ),
              SizedBox(width: size.width * 0.25),
              IconButton(
                iconSize: 20,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: kSecondaryColor,
                ),
              )
            ],
          ),
          RoundedInputField(
            icon: titleIcon,
            hintText: titleHintText,
            initialValue: initialTitle,
            onChanged: titleOnChanged,
            validator: (String? val) {
              return null;
            },
          ),
          RoundedInputField(
            icon: amountIcon,
            hintText: amountHintText,
            initialValue: initialAmount,
            keyboardType: TextInputType.number,
            onChanged: amountOnChanged ?? (_) {},
            validator: (String? val) {
              return null;
            },
          ),
          RoundedButton(
            text: buttonText,
            press: () => onPressed(),
          ),
        ],
      ),
    );
  }

  static Widget buildTitleField({
    required BuildContext context,
    required String header,
    required IconData titleIcon,
    required String titleHintText,
    required String initialTitle,
    required ValueChanged<String> titleOnChanged,
    required String buttonText,
    required Function() onPressed,
  }) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                header,
                style: const TextStyle(color: kSecondaryColor, fontSize: 16),
              ),
              SizedBox(width: size.width * 0.25),
              IconButton(
                iconSize: 20,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: kSecondaryColor,
                ),
              )
            ],
          ),
          RoundedInputField(
            icon: titleIcon,
            hintText: titleHintText,
            initialValue: initialTitle,
            onChanged: titleOnChanged,
            validator: (String? val) {
              return null;
            },
          ),
          RoundedButton(
            text: buttonText,
            press: onPressed,
          ),
        ],
      ),
    );
  }

  ///[buildJobForm] is used to build bottom sheet for adding new job
  static Widget buildJobForm({
    required BuildContext context,
    required String header,
    required String blNumber,
    required String description,
    required String vesselName,
    required String jobType,
    required String etaDate,
    required bool enableBl,
    String? etdDate,
    required ValueChanged<String> blNumberChanged,
    required ValueChanged<String> descChanged,
    required ValueChanged<String> vesselNameChanged,
    required ValueChanged<String?> jobTypeChanged,
    required ValueChanged<String> etaDateChanged,
    required ValueChanged<String> etdDateChanged,
    required String? Function(String?)? validator,
    required Function() onButtonPressed,
    required buttonText,
  }) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //header section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  header,
                  style: const TextStyle(color: kSecondaryColor, fontSize: 16),
                ),
                SizedBox(width: size.width * 0.25),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: kSecondaryColor,
                  ),
                )
              ],
            ),
            // form fields
            RoundedInputField(
              icon: Icons.tag_sharp,
              hintText: "Bill Number",
              initialValue: blNumber,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [ToUpperCaseTextFormatter()],
              maxLines: 17,
              enabled: enableBl,
              onChanged: blNumberChanged,
              validator: validator,
            ),
            RoundedInputField(
              icon: Icons.description_sharp,
              hintText: "Description",
              initialValue: description,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [UpperCaseBeginningTextFormatter()],
              maxLines: 30,
              onChanged: descChanged,
              validator: validator,
            ),
            RoundedInputField(
              icon: Icons.directions_boat_sharp,
              hintText: "Vessel",
              initialValue: vesselName,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [UpperCaseBeginningTextFormatter()],
              maxLines: 30,
              onChanged: vesselNameChanged,
              validator: validator,
            ),
            TypeDropDownField(
              onChanged: jobTypeChanged,
              selectedValue: jobType,
            ),

            DateDropDownField(
              dateChanged: etaDateChanged,
              hintText: 'ETA',
              initialDate: etaDate,
            ),
            DateDropDownField(
              dateChanged: etdDateChanged,
              hintText: 'ETD',
              initialDate: etdDate ?? "",
            ),
            RoundedButton(
              text: buttonText,
              press: onButtonPressed,
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildChangeStageSheet(
      {required BuildContext context,
      required String blNumber,
      required String prevStage,
      required String currState,
      required ValueChanged<String?> onStageChanged,
      required Function() onButtonPressed}) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    blNumber,
                    style:
                        const TextStyle(color: kSecondaryColor, fontSize: 16),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: kSecondaryColor,
                  ),
                )
              ],
            ),
          ),
          TextFieldContainer(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    toBeginningOfSentenceCase(prevStage) ?? "",
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(
                    Icons.trending_flat_sharp,
                    color: kAbsentColor,
                  ),
                ],
              ),
            ),
          ),
          const Text("To"),
          StageDropDownField(
            onChanged: onStageChanged,
            currentState: currState,
          ),
          RoundedButton(
            text: "Update Stage",
            press: onButtonPressed,
          ),
        ],
      ),
    );
  }

  static Widget buildModifiersLog({
    required BuildContext context,
    required Modifier modifier,
    required String title,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                child: Text(
                  title,
                  style: const TextStyle(color: kSecondaryColor, fontSize: 16),
                ),
              ),
              IconButton(
                iconSize: 20,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: kSecondaryColor,
                ),
              )
            ],
          ),
        ),
        Center(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${modifier.name}  ',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${ModifierFlags.edited.name} amount ',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${modifier.date}, ',
                      style: const TextStyle(
                        color: kFontColorGrey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      modifier.time,
                      style: const TextStyle(
                        color: kFontColorGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  modifier.oldValue,
                  style: const TextStyle(
                    color: kAbsentColor,
                    fontSize: 12,
                  ),
                ),
                const Text("To"),
                Text(
                  modifier.newValue,
                  style: const TextStyle(
                    color: kPresentColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  /// [showListOfItemss] shows list of jobs that are worthy for an expense to
  /// be added to i.e pending and delivered jobs

  static Widget showListOfItems({
    required BuildContext context,
    required String title,
    required Widget child,
    required Widget emptyChild,
    required int itemLength,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    title,
                    style:
                        const TextStyle(color: kSecondaryColor, fontSize: 16),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: kSecondaryColor,
                  ),
                )
              ],
            ),
          ),
          if (itemLength == 0) ...[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Center(child: emptyChild),
            )
          ] else ...[
            child
          ]
        ],
      ),
    );
  }

  static Widget buildChatOptions({
    required BuildContext context,
    required onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: IconButton(
              iconSize: 20,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: kSecondaryColor,
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: TextButton.icon(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
            ),
            label: const Text('Delete'),
            icon: const Icon(Icons.delete_forever_sharp),
          ),
        )
      ],
    );
  }

  static Widget buildAuthorsLog({
    required BuildContext context,
    required List<Author> authors,
    required String title,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FittedBox(
                  child: Text(
                    title,
                    style:
                        const TextStyle(color: kSecondaryColor, fontSize: 16),
                  ),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: kSecondaryColor,
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: authors.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(authors[index].flag),
                      const Text(":"),
                      Text(authors[index].name),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text('${authors[index].date}, '),
                      Text(authors[index].time),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
