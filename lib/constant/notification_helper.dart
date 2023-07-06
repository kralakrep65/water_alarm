import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_background_service_ios/flutter_background_service_ios.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_alarm/constant/shared_preferences_helper.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotificationService() async {
  try {
    // final service = FlutterBackgroundService();

    if (Platform.isAndroid) {
      AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      // await service.configure(
      //   iosConfiguration:
      //       IosConfiguration(onForeground: onStart, autoStart: true),
      //   androidConfiguration: AndroidConfiguration(
      //       onStart: onStart,
      //       isForegroundMode: true,
      //       autoStart: true,
      //       notificationChannelId: channel.id,
      //       initialNotificationTitle: "Welcome to Water Reminder",
      //       initialNotificationContent: "Water is life, life is you..",
      //       foregroundServiceNotificationId: 88),
      // );
    } else if (Platform.isIOS) {
      AndroidInitializationSettings initializationSettingsAndroid =
          const AndroidInitializationSettings('flutter_logo');

      var initializationSettingsIOS = DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {});

      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin?.initialize(initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse notificationResponse) async {});
      // await service.configure(
      //   iosConfiguration: IosConfiguration(
      //       onForeground: onStart,
      //       autoStart: true,
      //       onBackground: onIosBackground),
      //   androidConfiguration: AndroidConfiguration(
      //       onStart: onStart,
      //       isForegroundMode: true,
      //       autoStart: true,
      //       initialNotificationTitle: "Welcome to Water Reminder",
      //       initialNotificationContent: "Water is life, life is you..",
      //       foregroundServiceNotificationId: 88),
      // );
    }
    // service.startService();
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  //await notificationPeriodMethod(service);
  return true;
}

notificationDetails() {
  return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max),
      iOS: DarwinNotificationDetails());
}

Future stopNotification() async {
  try {
    await flutterLocalNotificationsPlugin?.cancelAll();
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance instance) async {
  if (instance is AndroidServiceInstance) {
    instance.on('setAsForeground').listen((event) {
      instance.setAsBackgroundService();
    });
    instance.on('setAsBackground').listen((event) {
      instance.setAsBackgroundService();
    });
  }
  instance.on('stopService').listen((event) {
    instance.stopSelf();
  });
  await notificationPeriodMethod(instance);
}

notificationPeriodMethod(ServiceInstance instance) async {
  try {
    SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
    String? selectedIntervalValue = await sharedPreferencesHelper
        .getDataFromSharedPref("selectedIntervalValue");
    String? selectedStartOfDay = await sharedPreferencesHelper
        .getDataFromSharedPref("selectedStartOfDay");
    String? selectedEndOfDay =
        await sharedPreferencesHelper.getDataFromSharedPref("selectedEndOfDay");

    Timer.periodic(
      Duration(minutes: int.parse(selectedIntervalValue!)),
      (timer) async {
        if (instance is AndroidServiceInstance) {
          if (await instance.isForegroundService()) {
            if (isBetweenTime(selectedStartOfDay!, selectedEndOfDay!)) {
              flutterLocalNotificationsPlugin?.show(
                88,
                "Drink Water!!",
                "How about a glass of water",
                const NotificationDetails(
                    android: AndroidNotificationDetails(
                      "channelId",
                      "channelName",
                      channelDescription: "channelDescription",
                      importance: Importance.defaultImportance,
                      priority: Priority.max,
                      icon: "@mipmap/ic_launcher",
                    ),
                    iOS: DarwinNotificationDetails()),
              );
            }
          }
        } else if (instance is IOSServiceInstance) {
          if (isBetweenTime(selectedStartOfDay!, selectedEndOfDay!)) {
            flutterLocalNotificationsPlugin?.show(
              88,
              "Drink Water!!",
              "How about a glass of water",
              const NotificationDetails(
                  android: AndroidNotificationDetails(
                    "channelId",
                    "channelName",
                    channelDescription: "channelDescription",
                    importance: Importance.defaultImportance,
                    priority: Priority.max,
                    icon: "@mipmap/ic_launcher",
                  ),
                  iOS: DarwinNotificationDetails()),
            );
          }
        }
        print("Hello World background service is running");
        //  instance.invoke('update');
      },
    );
  } catch (e) {
    print(e);
  }
}

bool isBetweenTime(String startTime, String endTime) {
  DateTime now = DateTime.now();
  if (now.hour >= int.parse(startTime.split(":")[0]) &&
      now.hour <= int.parse(endTime.split(":")[0])) {
    return true;
  }
  return false;
}
