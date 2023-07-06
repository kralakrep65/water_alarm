import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/ui/widgets/confirmation_dialog.dart';
import 'package:water_alarm/ui/widgets/consumption_dialog.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';

Future<bool> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
}) async {
  final bool confirmed = await showModal(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            title: title,
            content: content,
            onConfirm: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          );
        },
      ) ??
      false;

  return confirmed;
}

Future<void> showConsumptionDialog(BuildContext context) {
  return showModal(
    context: context,
    builder: (context) => ConsumptionDialog(),
  );
}

findRepeatInterval(String value) {
  switch (value) {
    case 'Hourly':
      return RepeatInterval.hourly;
    case 'Daily':
      return RepeatInterval.daily;
    case 'Weekly':
      return RepeatInterval.weekly;
    case 'Every Minute':
      return RepeatInterval.everyMinute;
    default:
      return RepeatInterval.hourly;
  }
}

void showPickerDialog(BuildContext context,
    {required List<String> stringList,
    required Function(int index) onSelectedItemChanged,
    TextEditingController? textEditingController,
    VoidCallback? onConfirm,
    GlobalKey<FormState>? formkey}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: const Text('Select Interval'),
        content: SizedBox(
          height: sizeConfig.heightSize(context, 256),
          child: Column(
            children: [
              const VerticalSpace(height: 20),
              Expanded(
                flex: 2,
                child: CupertinoPicker(
                  itemExtent: 50,
                  onSelectedItemChanged: onSelectedItemChanged,
                  children: stringList.map((value) {
                    return Center(
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const VerticalSpace(height: 36),
              const Text("Custom Interval", style: TextStyle(fontSize: 16)),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Form(
                      key: formkey,
                      child: TextFormField(
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (Platform.isIOS) {
                            if (int.parse(value ?? '0') < 25) {
                              return 'Please input less 25';
                            }
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          hintText: "Enter Interval(minutes)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            onPressed: onConfirm ??
                () {
                  Navigator.of(context).pop();
                },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}

Future<void> selectTime(
    BuildContext context, Function(DateTime dateTime) onChange) async {
  await showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 300.0,
        child: CupertinoPopupSurface(
          isSurfacePainted: true,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime.now(),
            use24hFormat: true,
            onDateTimeChanged: onChange,
          ),
        ),
      );
    },
  );
}

class AnimatedPopup extends StatefulWidget {
  const AnimatedPopup({super.key, this.title});

  @override
  _AnimatedPopupState createState() => _AnimatedPopupState();
  final String? title;
}

class _AnimatedPopupState extends State<AnimatedPopup>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _animationController?.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          RotationTransition(
            turns: _animation!,
            child: Icon(
              Icons.warning,
              color: Colors.yellow[800],
            ),
          ),
          const SizedBox(width: 8.0),
          const Text('Warning'),
        ],
      ),
      content: Text(widget.title ?? ''),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

void showAnimatedPopup(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedPopup(
        title: title,
      );
    },
  );
}
