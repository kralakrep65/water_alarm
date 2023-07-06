import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_alarm/constant/loader.dart';
import 'package:water_alarm/constant/notification_service.dart';
import 'package:water_alarm/constant/shared_preferences_helper.dart';
import 'package:water_alarm/domain/model/user_model.dart';
import 'package:water_alarm/domain/repository/person_repository.dart';
import 'package:water_alarm/resources/assets.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/gender_screen.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/height_screen.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/sleep_time_screen.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/weight_screen.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/weka_up_screen.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_screens/widget/top_period_widget.dart';
import 'package:water_alarm/ui/home/home_page.dart';
import 'package:water_alarm/ui/widgets/primary_button.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';

class LoginPageViewBuilder extends StatefulWidget {
  const LoginPageViewBuilder({super.key});

  static _LoginPageViewBuilderState? of(BuildContext context) =>
      context.findRootAncestorStateOfType<_LoginPageViewBuilderState>();
  @override
  State<LoginPageViewBuilder> createState() => _LoginPageViewBuilderState();
}

class _LoginPageViewBuilderState extends State<LoginPageViewBuilder> {
  final PageController _pageController = PageController();
  List<AssetsModel> assetList = [
    AssetsModel("Gender", Assets.sexIcon),
    AssetsModel("Weight(kg)", Assets.weightIcon),
    AssetsModel("Height(cm)", Assets.heightIcon),
    AssetsModel("Wake up time", Assets.alarmIcon),
    AssetsModel("Sleep time", Assets.nightIcon),
  ];
  final PersonRepository personRepository = PersonRepository();

  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  nextPage() async {
    if (currentIndex == 4) {
      wakeUpTime ??= "${DateTime.now().hour}:00";
      sleepTime ??= "23:00";
      weight ??= 60;
      height ??= 170;
      genderId ??= 1;
      if (genderId != null &&
          weight != null &&
          height != null &&
          wakeUpTime != null &&
          sleepTime != null) {
        await createUsers(UserModel(
            weight: double.parse(weight.toString()),
            height: double.parse(height.toString()),
            name: "",
            consumptionTarget: double.parse(
                calculateDailyWaterIntake(weight!, height!, genderId.toString())
                    .toString())));
      } else {
        print("$genderId genderId");
        print("$weight weight");
        print("$height height");
        print("$wakeUpTime wakeUpTime");
        print("$sleepTime sleepTime");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill all fields(gender)"),
          ),
        );
      }
    } else {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 900),
          curve: Curves.fastOutSlowIn);
    }
  }

  Future createUsers(UserModel user) async {
    CustomLoader.of(context)?.showLoader();
    await SharedPreferencesHelper()
        .setDataToSharedPref("selectedIntervalValue", "60");
    await SharedPreferencesHelper()
        .setDataToSharedPref("selectedStartOfDay", wakeUpTime ?? "");
    await SharedPreferencesHelper()
        .setDataToSharedPref("selectedEndOfDay", sleepTime ?? "");
    await SharedPreferencesHelper().setDataToSharedPref(
        "defaultConsumptionTarget",
        UserModel.defaultConsumptionTarget.toString());
    int hour = int.parse(wakeUpTime!.split(":")[0]);

    int endHour = int.parse(sleepTime!.split(":")[0]);

    print("hour: $hour");

    print("endHour: $endHour");

    int minute = 0;
    for (int i = hour; i <= endHour; i++) {
      await NotificationService().showSheduleDailyNotification(
        id: int.parse("$i$minute"),
        body: "How about a glass of water",
        payLoad: 'payload',
        sheduleTime: Time(i, minute),
        title: "Drink Water!!",
        finishTime: DateTime(2024),
      );
    }
    await personRepository.createUsers(user).then((val) {
      CustomLoader.of(context)?.hideLoader();
      if (val) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false);
      }
    });
  }

  double calculateDailyWaterIntake(int weight, int height, String gender) {
    double waterIntake;

    if (gender == "1") {
      waterIntake = (weight * 0.04);
    } else if (gender == "0") {
      waterIntake = (weight * 0.035);
    } else {
      throw Exception("Geçersiz cinsiyet bilgisi.");
    }
    UserModel.defaultConsumptionTarget = waterIntake * 1000;
    return double.parse((waterIntake * 1000).toStringAsFixed(2));
  }

  backPage() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 900),
        curve: Curves.fastOutSlowIn);
  }

  int? genderId;
  setGender(int gender) {
    genderId = gender;
    print(genderId);
  }

  int? weight;
  setWeight(int w) {
    weight = w;
    print(weight);
  }

  int? height;
  setHeight(int h) {
    height = h;
    print(height);
  }

  String? wakeUpTime;
  setWakeUpTime(DateTime time) {
    wakeUpTime = "${time.hour}:${time.minute}";
    print(wakeUpTime);
  }

  String? sleepTime;
  setSleepTime(DateTime time) {
    sleepTime = "${time.hour}:${time.minute}";
    print(sleepTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const VerticalSpace(height: 10),
            TopPeriodWidget(assetList: assetList, currentIndex: currentIndex),
            const VerticalSpace(height: 10),
            Text(assetList[currentIndex].iconName,
                style: const TextStyle(
                  fontSize: 30,
                )),
            Expanded(
              child: PageView.builder(
                itemCount: assetList.length,
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                controller: _pageController,
                itemBuilder: (context, index) => [
                  GenderPage(setGender: setGender),
                  WeightScreen(setWeight: setWeight),
                  HeightPage(setHeight: setHeight),
                  WakeUpPage(setWekaUp: setWakeUpTime),
                  SleepTimeScreen(
                    setSleepTime: setSleepTime,
                  )
                ].elementAt(index),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: currentIndex != 0,
                  child: Expanded(
                      child: PrimaryButton(onPressed: backPage, title: "Back")),
                ),
                Visibility(
                  visible: currentIndex != 0,
                  child: const SizedBox(
                    width: 10,
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: PrimaryButton(
                        onPressed: nextPage,
                        title: currentIndex != 4 ? "Next" : "Finish")),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const VerticalSpace(height: 10)
          ],
        ),
      ),
    );
  }
}

class AssetsModel {
  final String iconName;
  final String iconPath;

  AssetsModel(this.iconName, this.iconPath);
}
