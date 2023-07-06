import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_alarm/constant/notification_helper.dart';
import 'package:water_alarm/constant/notification_service.dart';
import 'package:water_alarm/constant/shared_preferences_helper.dart';
import 'package:water_alarm/domain/repository/person_repository.dart';
import 'package:water_alarm/logic/hydration_pool_logic.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_page_builder.dart';
import 'package:water_alarm/ui/settings/consumption_calculation.dart';
import 'package:water_alarm/ui/settings/past_consumption.dart';
import 'package:water_alarm/ui/settings/select_time_schuled.dart';
import 'package:water_alarm/ui/settings/rolling_switch_button.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';
import 'package:water_alarm/util/dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PersonRepository get _personRepository => PersonRepository();
  HydrationPoolLogic get _hydrationPoolLogic => HydrationPoolLogic();
  int count = 0;
  bool alarmStatus = true;
  String? selectedIntervalValue;
  String? selectedStartOfDay;
  String? selectedEndOfDay;
  TextEditingController controller = TextEditingController();
  List<String> stringList = [
    "every half hour",
    "every 1 hours",
    "every one and a half hours"
        "every 2 hours",
    "every two and a half hours"
        "every 3 hours",
  ];

  getConsumptionCount() async {
    count = await _personRepository.getConsumptionCount();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getConsumptionCount();
  }

  changeAlarmSituation(bool value) async {
    if (false == value) {
      showSureDialog(context, value);
    } else {
      await initialNotifications();
      setState(() {
        alarmStatus = value;
      });
    }
  }

  initialNotifications() async {
    try {
      selectedIntervalValue = await SharedPreferencesHelper()
          .getDataFromSharedPref("selectedIntervalValue");
      selectedStartOfDay = await SharedPreferencesHelper()
          .getDataFromSharedPref("selectedStartOfDay");
      selectedEndOfDay = await SharedPreferencesHelper()
          .getDataFromSharedPref("selectedEndOfDay");
      int hour = int.parse(selectedStartOfDay!.split(":")[0]);
      int endHour = int.parse(selectedEndOfDay!.split(":")[0]);
      int interval = int.parse(selectedIntervalValue ?? "60");

      await showNotifications(hour, endHour, interval);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //   final bloc = context.watch<WaterBloc>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 136, top: 32.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              children: [
                const SizedBox(width: double.infinity),
                Text(
                  "Settings",
                  style: theme.textTheme.headline4,
                ),
                const VerticalSpace(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 6, right: 4),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text("Reminders"),
                      ),
                      RollingSwitchButton(
                        value: alarmStatus,
                        colorOff: theme.errorColor,
                        onChange: changeAlarmSituation,
                      ),
                    ],
                  ),
                ),
                const VerticalSpace(height: 32),
                TextButton(
                  onPressed: () => showConsumptionDialog(context),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        theme.primaryColor.withOpacity(0.06)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Daily consumption",
                            style: theme.textTheme.bodyText2,
                          ),
                        ),
                        Text(
                          "$count",
                          style: theme.textTheme.bodyText2
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SelectTimeSchema(isFromSetting: true),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          theme.errorColor.withOpacity(0.06)),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Change Notification Interval",
                          style: theme.textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PastConsumption(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          theme.errorColor.withOpacity(0.06)),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Past Consumption",
                          style: theme.textTheme.bodyText2,
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ConsumptionCalculationScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          theme.errorColor.withOpacity(0.06)),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Our Daily water calculation algorithm.",
                          style: theme.textTheme.bodyText2?.copyWith(
                            color: theme.errorColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalSpace(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => clearDataStore(context),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          theme.errorColor.withOpacity(0.06)),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Hard Reset",
                          style: theme.textTheme.bodyText2?.copyWith(
                            color: theme.errorColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createAPeriodTitle(String? selectedIntervalValue) {
    if (controller.text.isNotEmpty) {
      return "every ${controller.text} minutes";
    } else {
      return selectedIntervalValue ?? "Chose Notification Sending Interval";
    }
  }

  Future saveAndComplete() async {
    await stopNotification();
    await SharedPreferencesHelper().setDataToSharedPref("selectedIntervalValue",
        getIntervalPeriodTime(selectedIntervalValue ?? "").toString());
    await SharedPreferencesHelper()
        .setDataToSharedPref("selectedStartOfDay", selectedStartOfDay ?? "");
    await SharedPreferencesHelper()
        .setDataToSharedPref("selectedEndOfDay", selectedEndOfDay ?? "");
    await initialNotifications();
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
    }
  }

  int getIntervalPeriodTime(String intervalName) {
    if (controller.text.isNotEmpty) {
      return int.parse(controller.text);
    } else {
      return calculateIntervalDate(intervalName);
    }
  }

  Future<void> clearDataStore(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: "Hard Reset",
      content:
          "You are about to reset all the application data. This action cannot be undone.",
    );
    if (confirmed) {
      // await _notificationHelper.stopNotification();
      await _personRepository.deleteUsers();
      _hydrationPoolLogic.reset();
      var sa = await _personRepository.getPerson();
      var mi = await _personRepository.getConsumptionCount();
      await stopNotification();
      await NotificationService().allDeleteNotification();
      print("mi: $mi");
      print("sa: $sa");
      await Future.delayed(const Duration(microseconds: 10)).then((s) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPageViewBuilder(),
            ),
            (route) => false);
      });
    }
  }

  Future<void> showSureDialog(BuildContext context, bool value) async {
    final confirmed = await showConfirmationDialog(
      context,
      title: "Are you sure?",
      content: "Reminder notifications will be stopped.",
    );
    if (confirmed) {
      await stopNotification();
      setState(() {
        alarmStatus = value;
      });
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
