// ignore_for_file: file_names

import 'dart:async';

import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Realtime_Database/postScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 2), () => Get.to(const PostScreen()));
    } else {
      Timer(const Duration(seconds: 2), () => Get.to(const SignupScreen()));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Complete Firebase")),
    );
  }
}
