import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/utils/constants.dart';
import 'package:weather/utils/widgets/app_bar.dart';
import 'package:weather/view/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => inception());
  }

  inception() {
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ZeroAppBar(),
      body: Center(child: Lottie.asset("$animationPath/preloader.json")),
    );
  }
}
