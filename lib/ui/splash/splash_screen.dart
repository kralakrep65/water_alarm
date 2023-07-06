import 'package:flutter/material.dart';
import 'package:water_alarm/domain/model/user_model.dart';
import 'package:water_alarm/domain/repository/person_repository.dart';
import 'package:water_alarm/resources/assets.dart';
import 'package:water_alarm/ui/get_user_infos/welcome_screen.dart';
import 'package:water_alarm/ui/home/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PersonRepository personRepository = PersonRepository();
  @override
  void initState() {
    super.initState();
    isThereUser().then((value) {
      if (value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    });
  }

  Future<bool> isThereUser() async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      return await personRepository.getPerson().then((value) {
        if (value.isNotEmpty) {
          UserModel.defaultConsumptionTarget = value[0].consumptionTarget ?? 20;
          print(
              "${UserModel.defaultConsumptionTarget}defaultConsumptionTarget");
        }
        return value.isNotEmpty;
      });
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff3C3F47),
        body: Stack(
          children: [
            Image.asset(
              Assets.appIcon,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
            ),
            const Positioned(
                bottom: 10,
                right: 0,
                left: 0,
                child: SafeArea(
                  child: Text(
                    "Powered by Bünyamin Arıcı",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ))
          ],
        ));
  }
}
