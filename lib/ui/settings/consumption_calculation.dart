import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_alarm/constant/size_config.dart';
import 'package:water_alarm/ui/widgets/primary_button.dart';
import 'package:water_alarm/ui/widgets/vertical_space.dart';

class ConsumptionCalculationScreen extends StatelessWidget {
  const ConsumptionCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),

          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.center,
          padding: const EdgeInsets.all(20),
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: sizeConfig.heightSize(context, 10))),
            const Text("First of all you should know that i am not a doctor...",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
            ),
            const Text(
                "I am just a reminder who wants to help you to drink more water. So, you should consult your doctor for your daily water consumption."
                " I calculated your daily water consumption according to a simple algorithm.",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
            const Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
            ),
            Row(
              children: const [
                Text("Here is the algorithm:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ],
            ),
            Divider(
              color: Colors.black54,
              height: 20,
              thickness: 1,
              endIndent: sizeConfig.widthSize(context, 120),
            ),
            const Text("if you are a woman: Your weight * 0.035",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            const Divider(
              color: Colors.white,
              height: 20,
              thickness: 1,
              indent: 5,
            ),
            const Text("if you are a man: Your weight * 0.04",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            const Divider(
              color: Colors.white,
              height: 18,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            const Text("if you have questions about the algorithm:",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            const VerticalSpace(
              height: 20,
            ),
            PrimaryButton(
              onPressed: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'bunyamin.arici@gmail.com',
                  query: 'subject=Water_alarm&body=',
                );
                var url = Uri.parse(params.toString());
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              title: "Send us an e-mail",
              color: Colors.white,
              textColor: Colors.black,
            ),
            const VerticalSpace(
              height: 20,
            ),
          ],
        ));
  }
}
