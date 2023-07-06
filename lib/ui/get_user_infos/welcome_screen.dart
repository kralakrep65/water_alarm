import 'package:flutter/material.dart';
import 'package:water_alarm/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:water_alarm/ui/get_user_infos/login/login_page_builder.dart';
import 'package:water_alarm/ui/widgets/primary_button.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                AppLocalizations.of(context)!.welcome,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Hi, I'm your personal water consumption assistant.",
                  style: TextStyle(fontSize: 30),
                ),
                VerticalSpace(height: 10),
                Text(
                  "In order to give personalized water consumption advice, I need to get some basic information. This information will only stay on your phone.",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            ),
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PrimaryButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginPageViewBuilder(),
                                ),
                                (route) => false);
                          },
                          title: "Get Started"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
