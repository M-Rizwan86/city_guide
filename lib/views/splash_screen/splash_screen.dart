import 'dart:async';

import 'package:city_guide/views/User_panel/Main_page.dart';
import 'package:city_guide/views/admin_panel/admin_screen.dart';
import 'package:city_guide/views/splash_screen/FirstScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../controller/user_controller.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(const Duration(seconds: 3 ), () {
      loggedIn(context);
    });
    super.initState();
  }

  Future<void> loggedIn(BuildContext context) async {
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Lottie.asset(
          backgroundLoading: true,
          'assets/animation/lotie.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
