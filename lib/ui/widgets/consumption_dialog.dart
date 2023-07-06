import 'package:flutter/material.dart';
import 'package:water_alarm/constant/shared_preferences_helper.dart';
import 'package:water_alarm/domain/model/user_model.dart';
import 'package:water_alarm/ui/splash/splash_screen.dart';

import 'package:water_alarm/ui/widgets/primary_button.dart';
import 'package:water_alarm/ui/widgets/secondary_button.dart';

class ConsumptionDialog extends StatefulWidget {
  @override
  _ConsumptionDialogState createState() => _ConsumptionDialogState();
}

class _ConsumptionDialogState extends State<ConsumptionDialog> {
  final _form = GlobalKey<FormState>();
  String? _text;

  String? _validateText(String? value) {
    if (value == null) {
      return "20 ml minimun";
    }

    final number = int.tryParse(value);
    if (number != null && number >= 20) {
      return null;
    }

    return "20 ml minimun";
  }

  @override
  Widget build(BuildContext context) {
    // final bloc = context.watch<WaterBloc>();
    return AlertDialog(
      title: const Text(
        "Daily consumption",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Change your daily water consumption goal, in milliliters.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextFormField(
              maxLength: 5,
              initialValue:
                  UserModel.defaultConsumptionTarget.toStringAsFixed(2),
              // initialValue: bloc.state.recommendedMilliliters.toString(),
              keyboardType: TextInputType.number,
              onSaved: (value) => _text = value,
              validator: _validateText,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                hintText: "20 ml",
                counterText: "",
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () async {
                if (_form.currentState?.validate() ?? false) {
                  _form.currentState?.save();
                  UserModel.defaultConsumptionTarget = double.parse(_text!);
                  await SharedPreferencesHelper()
                      .setDataToSharedPref("defaultConsumptionTarget",
                          UserModel.defaultConsumptionTarget.toString())
                      .whenComplete(() {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                        (route) => false);
                  });

                  // context.read<WaterBloc>().setRecommendedMilliliters(
                  //       int.parse(_text!),
                  //     );

                }
              },
              title: "Confirm",
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              title: "Cancel",
            ),
          ],
        ),
      ),
    );
  }
}
