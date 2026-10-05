import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/utils/app_constatns.dart';
import 'package:flutter_application_1/features/home/home_screen.dart';
import 'package:flutter_application_1/features/login/data/user_model.dart';
import 'package:flutter_application_1/features/login/login_screen.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _nextPage);
  }

  void _nextPage() {
    if (!mounted) return;

    final user = Hive.box<UserModel>(
      AppConstants.userBoxName,
    ).get(AppConstants.currentUser);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user == null ? const LoginScreen() : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.asset('assets/icons/splash.json')),
    );
  }
}
