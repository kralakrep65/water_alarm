import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_alarm/constant/notification_helper.dart';
import 'package:water_alarm/constant/notification_service.dart';
import 'package:water_alarm/constant/shared_preferences_helper.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/ui/home/home_page.dart';
import 'package:water_alarm/ui/settings/widgets/picker_button.dart';
import 'package:water_alarm/ui/widgets/item_padding.dart';
import 'package:water_alarm/ui/widgets/primary_button.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';
import 'package:water_alarm/util/dialog.dart';

class SelectTimeSchema extends StatefulWidget {
  const SelectTimeSchema({super.key, this.isFromSetting});
  final bool? isFromSetting;
  @override
  State<SelectTimeSchema> createState() => _SelectTimeSchemaState();
}

class _SelectTimeSchemaState extends State<SelectTimeSchema> {
  String? selectedIntervalValue;
  String? selectedStartOfDay;
  String? selectedEndOfDay;
  late TextEditingController _controller;
  bool isChangedStart = false;
  bool isChangedEnd = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> stringList = [
    "every half hour",
    "every 1 hours",
    "every one and a half hours"
        "every 2 hours",
    "every two and a half hours"
        "every 3 hours",
  ];
  @override
  void initState() {
    getSharedData();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getSharedData() async {
    selectedIntervalValue = await SharedPreferencesHelper()
        .getDataFromSharedPref("selectedIntervalValue");
    selectedStartOfDay = await SharedPreferencesHelper()
        .getDataFromSharedPref("selectedStartOfDay");
    selectedEndOfDay = await SharedPreferencesHelper()
        .getDataFromSharedPref("selectedEndOfDay");
    _controller.text = selectedIntervalValue ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios))
            ],
          ),
          const VerticalSpace(height: 22),
          const ItemHorizontalPadding(
              child: Text("Choose your time schema",
                  style: TextStyle(fontSize: 36))),
          const VerticalSpace(height: 16),
          Padding(
              padding:
                  EdgeInsets.only(bottom: sizeConfig.heightSize(context, 64))),
          const ItemHorizontalPadding(
            child: Text(
              "Notification period:",
              style: TextStyle(fontSize: 12),
            ),
          ),
          const VerticalSpace(height: 4),
          ItemHorizontalPadding(
            child: Row(
              children: [
                Expanded(
                  child: CustomPickerButton(
                    onPressed: () {
                      showPickerDialog(
                        context,
                        stringList: stringList,
                        formkey: formKey,
                        onSelectedItemChanged: (value) {
                          setState(() {
                            _controller.text = "";
                            selectedIntervalValue = stringList[value];
                          });
                        },
                        textEditingController: _controller,
                        onConfirm: () {
                          if (formKey.currentState!.validate()) {
                            if (_controller.text.isNotEmpty) {
                              setState(() {
                                selectedIntervalValue = _controller.text;
                              });
                            }
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                    title: createAPeriodTitle() ?? "",
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpace(height: 16),
          const ItemHorizontalPadding(
            child: Text(
              "Start of day:",
              style: TextStyle(fontSize: 12),
            ),
          ),
          const VerticalSpace(height: 4),
          ItemHorizontalPadding(
            child: Row(
              children: [
                Expanded(
                  child: CustomPickerButton(
                    onPressed: () {
                      selectTime(context, (value) {
                        setState(() {
                          isChangedStart = true;
                          selectedStartOfDay =
                              "${value.hour.toString().length == 1 ? ('0${value.hour}') : value.hour}:${value.minute.toString().length == 1 ? ('0${value.minute}') : value.minute}";
                        });
                      }).whenComplete(() {
                        // if (!isChangedStart) {
                        //   setState(() {
                        //     selectedStartOfDay =
                        //         "${DateTime.now().hour}:${DateTime.now().minute}";
                        //   });
                        // }
                      });
                    },
                    title: selectedStartOfDay ?? "Select start of day",
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpace(height: 16),
          const ItemHorizontalPadding(
            child: Text(
              "End of day:",
              style: TextStyle(fontSize: 12),
            ),
          ),
          const VerticalSpace(height: 4),
          ItemHorizontalPadding(
            child: Row(
              children: [
                Expanded(
                  child: CustomPickerButton(
                    onPressed: () {
                      selectTime(context, (value) {
                        setState(() {
                          isChangedEnd = true;
                          selectedEndOfDay =
                              "${value.hour.toString().length == 1 ? ('0${value.hour}') : value.hour}:${value.minute.toString().length == 1 ? ('0${value.minute}') : value.minute}";
                        });
                      }).whenComplete(() {
                        // if (!isChangedEnd) {
                        //   setState(() {
                        //     selectedEndOfDay =
                        //         "${DateTime.now().hour + 8}:${DateTime.now().minute}";
                        //   });
                        // }
                      });
                    },
                    title: selectedEndOfDay ?? "Select end of day",
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpace(height: 16),
          ItemHorizontalPadding(
            child: PrimaryButton(
              onPressed: () {
                if (selectedIntervalValue == null ||
                    selectedStartOfDay == null ||
                    selectedEndOfDay == null) {
                  showAnimatedPopup(
                    context,
                    "Please select all fields",
                  );
                } else {
                  saveAndComplete().whenComplete(() {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                        (route) => false);
                  });
                }
              },
              title: "Save and complete",
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  createAPeriodTitle() {
    if (_controller.text.isNotEmpty) {
      return "every ${_controller.text} minutes";
    } else {
      return selectedIntervalValue ?? "Chose Notification Sending Interval";
    }
  }

  Future saveAndComplete() async {
    try {
      if (widget.isFromSetting ?? false) {
        stopNotification();
      }
      if (getIntervalPeriodTime(selectedIntervalValue ?? "0") > 0) {
        await SharedPreferencesHelper().setDataToSharedPref(
            "selectedIntervalValue",
            getIntervalPeriodTime(selectedIntervalValue ?? "").toString());
        await SharedPreferencesHelper().setDataToSharedPref(
            "selectedStartOfDay", selectedStartOfDay ?? "");
        await SharedPreferencesHelper()
            .setDataToSharedPref("selectedEndOfDay", selectedEndOfDay ?? "");
        // await initializeNotificationService();
        initialNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("interval cannot be 0"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  initialNotifications() async {
    try {
      int hour = int.parse(selectedStartOfDay!.split(":")[0]);
      int endHour = int.parse(selectedEndOfDay!.split(":")[0]);
      int interval = getIntervalPeriodTime(selectedIntervalValue ?? "");

      await showNotifications(hour, endHour, interval);
    } catch (e) {
      print(e);
    }
  }

  calculateIntervalDate(String intervalName) {
    switch (intervalName) {
      case "every half hour":
        return 30;
      case "every 1 hours":
        return 60;
      case "every one and a half hours":
        return 90;
      case "every 2 hours":
        return 120;
      case "every two and a half hours":
        return 150;
      case "every 3 hours":
        return 180;
      default:
        return 60;
    }
  }

  int getIntervalPeriodTime(String intervalName) {
    if (_controller.text.isNotEmpty) {
      return int.parse(_controller.text);
    } else {
      return calculateIntervalDate(intervalName);
    }
  }

  Future<void> showNotifications(
      int hour, int endHour, int minuteIncrement) async {
    int minute = minuteIncrement % 60;
    if (minuteIncrement < 60) {
      for (int i = hour; i <= endHour; i++) {
        for (int j = 0; j < 60; j += minute) {
          await NotificationService().showSheduleDailyNotification(
            id: int.parse("$i$j"),
            body: "How about a glass of water",
            payLoad: 'payload',
            sheduleTime: Time(i, j),
            title: "Drink Water!!",
            finishTime: DateTime(2024),
          );
        }
      }
    } else {
      for (int i = hour; i <= endHour; i += minuteIncrement ~/ 60) {
        await NotificationService().showSheduleDailyNotification(
          id: int.parse("$i$minute"),
          body: "How about a glass of water",
          payLoad: 'payload',
          sheduleTime: Time(i, minute),
          title: "Drink Water!!",
          finishTime: DateTime(2024),
        );
      }
    }
  }
}
