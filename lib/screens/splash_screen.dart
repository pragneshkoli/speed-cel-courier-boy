import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_cel_courier_boy_app/screens/courier_list_screen.dart';
import 'package:speed_cel_courier_boy_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Simulate a delay for the splash screen
    nextScreen();
  }

  Future<void> nextScreen() async {
    final prefs = await SharedPreferences.getInstance();
   String userData = prefs.getString('token') ?? "";
   print(userData);
   if(userData.isEmpty) {
     Future.delayed(const Duration(seconds: 3), () {
       // Navigate to the home screen after the delay
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => const LoginScreen()),
       );
     });
   }else{
     Future.delayed(const Duration(seconds: 3), () {
       // Navigate to the home screen after the delay
       print("has data");
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => const CourierListScreen()),
       );
     });
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
