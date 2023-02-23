// ignore_for_file: file_names

import 'package:complete_firbase/auth/signupScreen.dart';
import 'package:complete_firbase/components/containerBtn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPaswordScreen extends StatefulWidget {
  const ForgotPaswordScreen({super.key});

  @override
  State<ForgotPaswordScreen> createState() => _ForgotPaswordScreenState();
}

class _ForgotPaswordScreenState extends State<ForgotPaswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(
              height: 20,
            ),
            ContainerBtnComp(
                loading: loading,
                text: "Forgot",
                onclick: () {
                  setState(() {
                    loading = true;
                  });
                  auth
                      .sendPasswordResetEmail(
                          email: emailController.text.toString())
                      .then((value) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage().toastmsj("Password is reset");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    ToastMessage().toastmsj(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
