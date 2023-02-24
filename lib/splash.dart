import 'package:mouth_cancer/camera.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mouth_cancer/login%20page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    _navigatetohome();
    super.initState();
  }

  _navigatetohome() {
    Future.delayed(const Duration(milliseconds: 6000), () {
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => Login())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            Lottie.asset('assets/lottie/My project-1 (2).mp4.lottie (2).json'),
      ),
    );
  }
}
